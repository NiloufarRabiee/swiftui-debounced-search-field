import SwiftUI

/// A reusable SwiftUI search field that delays search work until
/// the user pauses typing.
public struct DebouncedSearchField: View {
    @Binding private var text: String

    private let prompt: String
    private let delay: TimeInterval
    private let showsClearButton: Bool
    private let isLoading: Bool
    private let onSearch: (String) async -> Void
    private let onSubmit: ((String) -> Void)?

    @State private var searchTask: Task<Void, Never>?

    public init(
        text: Binding<String>,
        prompt: String = "Search",
        delay: TimeInterval = 0.4,
        showsClearButton: Bool = true,
        isLoading: Bool = false,
        onSubmit: ((String) -> Void)? = nil,
        onSearch: @escaping (String) async -> Void
    ) {
        self._text = text
        self.prompt = prompt
        self.delay = DebounceConfiguration.normalizedDelay(delay)
        self.showsClearButton = showsClearButton
        self.isLoading = isLoading
        self.onSubmit = onSubmit
        self.onSearch = onSearch
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            TextField(prompt, text: $text)
                .textFieldStyle(.plain)
                .onSubmit {
                    submitImmediately()
                }
                .accessibilityLabel(prompt)

            trailingAccessory
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.secondary.opacity(0.10))
        )
        .onChange(of: text) { newValue in
            scheduleSearch(for: newValue)
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }

    @ViewBuilder
    private var trailingAccessory: some View {
        if isLoading {
            ProgressView()
                .controlSize(.small)
                .accessibilityLabel("Searching")
        } else if showsClearButton && !text.isEmpty {
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Clear search")
        }
    }

    private func scheduleSearch(for query: String) {
        searchTask?.cancel()

        searchTask = Task {
            do {
                try await Task.sleep(
                    nanoseconds: UInt64(delay * 1_000_000_000)
                )
            } catch {
                return
            }

            guard !Task.isCancelled else { return }
            await onSearch(query)
        }
    }

    private func submitImmediately() {
        searchTask?.cancel()
        searchTask = nil

        let query = text
        onSubmit?(query)

        searchTask = Task {
            guard !Task.isCancelled else { return }
            await onSearch(query)
        }
    }
}

enum DebounceConfiguration {
    static let minimumDelay: TimeInterval = 0.05
    static let fallbackDelay: TimeInterval = 0.4

    static func normalizedDelay(_ delay: TimeInterval) -> TimeInterval {
        guard delay.isFinite else {
            return fallbackDelay
        }

        return max(delay, minimumDelay)
    }
}

#Preview {
    SearchPreview()
}

private struct SearchPreview: View {
    @State private var query = ""
    @State private var result = "Start typing"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            DebouncedSearchField(
                text: $query,
                prompt: "Search cities",
                delay: 0.4
            ) { value in
                result = value.isEmpty
                    ? "Search cleared"
                    : "Searching for: \(value)"
            }

            Text(result)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
