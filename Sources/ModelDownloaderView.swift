import SwiftUI

struct AIModelItem: Identifiable {
    let id = UUID()
    let name: String
    let family: String
    let sizeText: String
    let iconName: String
    let color: Color
    let downloadURL: String
}

struct ModelDownloaderView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "Alle"
    @State private var downloadingID: UUID?
    @State private var downloadedIDs: Set<UUID> = []
    @Environment(\.openURL) private var openURL

    let filters = ["Alle", "GGUF", "Llama", "Mistral", "Phi"]

    let models: [AIModelItem] = [
        AIModelItem(name: "Llama 3.2 3B", family: "Llama", sizeText: "GGUF • 1.9 GB", iconName: "infinity", color: .blue, downloadURL: "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF"),
        AIModelItem(name: "Mistral 7B", family: "Mistral", sizeText: "GGUF • 4.1 GB", iconName: "square.stack.3d.up.fill", color: .orange, downloadURL: "https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF"),
        AIModelItem(name: "Phi 3 Mini", family: "Phi", sizeText: "GGUF • 2.4 GB", iconName: "square.grid.2x2.fill", color: .cyan, downloadURL: "https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf"),
        AIModelItem(name: "Qwen 2.5 7B", family: "GGUF", sizeText: "GGUF • 3.9 GB", iconName: "atom", color: .purple, downloadURL: "https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF"),
        AIModelItem(name: "Gemma 2B", family: "GGUF", sizeText: "GGUF • 1.4 GB", iconName: "sparkles", color: .teal, downloadURL: "https://huggingface.co/google/gemma-2b-it-GGUF")
    ]

    var filteredModels: [AIModelItem] {
        models.filter { model in
            let matchesFilter = (selectedFilter == "Alle" || selectedFilter == "GGUF" || model.family == selectedFilter)
            let matchesSearch = searchText.isEmpty || model.name.localizedCaseInsensitiveContains(searchText)
            return matchesFilter && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                // Zoekbalk
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Zoek modellen...", text: $searchText)
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { filter in
                            Button {
                                selectedFilter = filter
                            } label: {
                                Text(filter)
                                    .font(.subheadline.weight(.medium))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedFilter == filter ? Color.blue : Color(.secondarySystemBackground))
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Modellijst
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredModels) { model in
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(model.color.opacity(0.2))
                                        .frame(width: 46, height: 46)
                                    Image(systemName: model.iconName)
                                        .font(.title3.bold())
                                        .foregroundStyle(model.color)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(model.name)
                                        .font(.headline)
                                    Text(model.sizeText)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Button {
                                    if let url = URL(string: model.downloadURL) {
                                        downloadedIDs.insert(model.id)
                                        openURL(url)
                                    }
                                } label: {
                                    Image(systemName: downloadedIDs.contains(model.id) ? "checkmark" : "arrow.down.to.line")
                                        .font(.body.bold())
                                        .foregroundStyle(.white)
                                        .frame(width: 38, height: 38)
                                        .background(downloadedIDs.contains(model.id) ? Color.green : Color.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        // Open in Safari knop
                        Button {
                            if let url = URL(string: "https://huggingface.co/models?library=gguf") {
                                openURL(url)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "safari.fill").foregroundStyle(.blue)
                                Text("Open in Safari").fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)

                        StorageBarView()
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Model Downloader")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "arrow.down.to.line").foregroundStyle(.blue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gearshape.fill").foregroundStyle(.blue)
                }
            }
        }
    }
}

struct StorageBarView: View {
    var storageInfo: (freeGB: Double, totalGB: Double, ratio: Double) {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        if let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey]),
           let free = values.volumeAvailableCapacityForImportantUsage,
           let total = values.volumeTotalCapacity, total > 0 {
            let freeGB = Double(free) / 1_000_000_000
            let totalGB = Double(total) / 1_000_000_000
            let usedRatio = min(max((totalGB - freeGB) / totalGB, 0.05), 1.0)
            return (freeGB, totalGB, usedRatio)
        }
        return (62.3, 256.0, 0.75)
    }

    var body: some View {
        let info = storageInfo
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Beschikbare opslag")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: "%.1f GB / %.0f GB", info.freeGB, info.totalGB))
                    .font(.caption.bold())
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.tertiarySystemFill))
                    Capsule()
                        .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * info.ratio)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 6)
    }
}
