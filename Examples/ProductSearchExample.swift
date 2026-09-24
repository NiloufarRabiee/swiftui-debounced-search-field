import SwiftUI
import DebouncedSearchField

struct ProductSearchExample: View {
    @State private var query = ""
    @State private var results: [String] = []
    @State private var isLoading = false

    private let products = [
        "MacBook Air",
        "MacBook Pro",
        "iPhone",
        "iPad",
        "Apple Watch",
        "AirPods"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DebouncedSearchField(
                text: $query,
                prompt: "Search products",
                delay: 0.4,
                isLoading: isLoading
            ) { value in
                await search(for: value)
            }

            List(results, id: \.self) { result in
                Text(result)
            }
        }
        .padding()
    }

    @MainActor
    private func search(for value: String) async {
        isLoading = true
        defer { isLoading = false }

        try? await Task.sleep(nanoseconds: 300_000_000)

        guard !Task.isCancelled else { return }

        if value.isEmpty {
            results = []
        } else {
            results = products.filter {
                $0.localizedCaseInsensitiveContains(value)
            }
        }
    }
}
