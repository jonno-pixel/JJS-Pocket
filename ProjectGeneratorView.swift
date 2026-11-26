import SwiftUI

struct ProjectGeneratorView: View {
    @State private var exportedFileURL: URL?
    @State private var showShareSheet = false

    let checklist = [
        "Swift bestanden",
        "Assets",
        "Configuratie",
        "README.md"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // Grote groene/cyaan vink
                ZStack {
                    Circle()
                        .stroke(LinearGradient(colors: [.green, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5)
                        .frame(width: 96, height: 96)
                        .shadow(color: .cyan.opacity(0.4), radius: 12)
                    Image(systemName: "checkmark")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.cyan)
                }

                VStack(spacing: 6) {
                    Text("Klaar!")
                        .font(.title.bold())
                    Text("Het project is succesvol aangemaakt.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Project Inhoud kaart
                VStack(alignment: .leading, spacing: 14) {
                    Text("Project Inhoud:")
                        .font(.headline)

                    ForEach(checklist, id: \.self) { item in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text(item)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                }
                .padding(20)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)

                // Blauwe knop: Exporteren als ZIP
                Button {
                    generateAndShareProject()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Exporteren als ZIP")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Project Generator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left.forwardslash.chevron.right").foregroundStyle(.blue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { generateAndShareProject() } label: {
                        Image(systemName: "play.fill").foregroundStyle(.blue)
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let url = exportedFileURL {
                    ShareSheet(activityItems: [url])
                }
            }
        }
    }

    private func generateAndShareProject() {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent("MyProject", isDirectory: true)
        try? fm.removeItem(at: tempDir)
        try? fm.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let swiftCode = """
        import SwiftUI

        @main
        struct MyProjectApp: App {
            var body: some Scene {
                WindowGroup {
                    Text("Gegenereerd met JJS-Pocket")
                }
            }
        }
        """
        let readme = "# MyProject\nGegenereerd door JJS-Pocket (Zuiver Native iOS)."

        try? swiftCode.write(to: tempDir.appendingPathComponent("ContentView.swift"), atomically: true, encoding: .utf8)
        try? readme.write(to: tempDir.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)

        // Gebruik iOS native NSFileCoordinator om een echte .zip te maken zonder third-party libraries
        let zipDestination = fm.temporaryDirectory.appendingPathComponent("MyProject.zip")
        try? fm.removeItem(at: zipDestination)

        var error: NSError?
        NSFileCoordinator().coordinate(readingItemAt: tempDir, options: .forUploading, error: &error) { zippedURL in
            try? fm.copyItem(at: zippedURL, to: zipDestination)
        }

        if fm.fileExists(atPath: zipDestination.path) {
            exportedFileURL = zipDestination
            showShareSheet = true
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
