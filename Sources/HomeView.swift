import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header kaart
                    VStack(spacing: 12) {
                        Image(systemName: "cpu")
                            .font(.system(size: 48))
                            .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        Text("JJS-Pocket")
                            .font(.title.bold())
                        Text("Zuiver Native iOS • Geen limieten")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // Snelle acties
                    VStack(spacing: 12) {
                        Button { selectedTab = 1 } label: {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill").font(.title2).foregroundStyle(.blue)
                                VStack(alignment: .leading) {
                                    Text("Model Downloader").font(.headline)
                                    Text("Beheer en download GGUF modellen").font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)

                        Button { selectedTab = 2 } label: {
                            HStack {
                                Image(systemName: "ellipsis.message.fill").font(.title2).foregroundStyle(.blue)
                                VStack(alignment: .leading) {
                                    Text("AI Developer Chat").font(.headline)
                                    Text("Ontwerp je iOS-app zonder restricties").font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)

                        Button { selectedTab = 3 } label: {
                            HStack {
                                Image(systemName: "chevron.left.forwardslash.chevron.right").font(.title2).foregroundStyle(.blue)
                                VStack(alignment: .leading) {
                                    Text("Project Generator").font(.headline)
                                    Text("Exporteer direct naar MyProject.zip").font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }

                    StorageBarView()
                }
                .padding()
            }
            .navigationTitle("JJS-Pocket")
        }
    }
}
