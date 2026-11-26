import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct AIDeveloperChatView: View {
    @Binding var selectedTab: Int
    @State private var inputText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Ik wil een iOS-app maken waarmee ik mijn projecten kan beheren.", isUser: true),
        ChatMessage(text: "Prima! Wat voor functionaliteit moet de app hebben? Denk aan een dashboard, instellingen en exportmogelijkheden.", isUser: false),
        ChatMessage(text: "Maak een app met een dashboard, projectbeheer en export naar ZIP.", isUser: true),
        ChatMessage(text: "Begrijp ik het goed: je wilt een app die projecten kan beheren, een dashboard toont en de mogelijkheid biedt om te exporteren als ZIP-bestand?", isUser: false),
        ChatMessage(text: "Ja, dat is correct.", isUser: true)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(messages) { msg in
                                HStack(alignment: .bottom, spacing: 10) {
                                    if !msg.isUser {
                                        Image(systemName: "cpu")
                                            .foregroundStyle(.cyan)
                                            .padding(8)
                                            .background(Color(.secondarySystemBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        Spacer()
                                    }

                                    Text(msg.text)
                                        .font(.subheadline)
                                        .padding(14)
                                        .background(msg.isUser ? Color.blue : Color(.secondarySystemBackground))
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))

                                    if msg.isUser {
                                        Image(systemName: "person.circle.fill")
                                            .font(.title3)
                                            .foregroundStyle(.blue)
                                    } else {
                                        Spacer()
                                    }
                                }
                                .id(msg.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }

                // Invoerbalk onderaan
                HStack(spacing: 10) {
                    TextField("Stel een vraag...", text: $inputText)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Capsule())

                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
            .navigationTitle("AI Developer Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "ellipsis.message.fill").foregroundStyle(.blue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        messages.removeAll()
                    } label: {
                        Image(systemName: "trash").foregroundStyle(.blue)
                    }
                }
            }
        }
    }

    private func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(text: trimmed, isUser: true))
        inputText = ""

        let reply = "Projectconfiguratie bijgewerkt voor '\(trimmed)'. Ga naar het tabblad Projects om direct je native Swift-project als ZIP te exporteren."
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            messages.append(ChatMessage(text: reply, isUser: false))
        }
    }
}
