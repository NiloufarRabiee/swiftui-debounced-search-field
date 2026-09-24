# DebouncedSearchField

A lightweight reusable **SwiftUI search field with debouncing, task cancellation, and configurable delay**.

It is useful when you do not want to trigger expensive filtering or network requests for every keystroke.

Common use cases include:

- API search
- Product search
- User search
- Location search
- Autocomplete
- Filtering large lists
- Remote suggestions

## Features

- Native SwiftUI
- No third-party dependencies
- Configurable debounce delay
- Cancels pending debounce tasks when text changes
- Async search callback
- Immediate search on Return / Submit
- Optional submit callback
- Optional clear button
- Optional loading indicator
- iOS and macOS support
- Swift Package Manager support

## Requirements

- iOS 16+
- macOS 13+
- Swift 5.9+

## Installation

### Swift Package Manager

In Xcode:

1. Open your project.
2. Go to **File > Add Package Dependencies...**
3. Enter:

```
https://github.com/NiloufarRabiee/swiftui-debounced-search-field
```

4. Add the `DebouncedSearchField` package to your app target.

Then import it:

```swift
import DebouncedSearchField
```

## Basic Usage

```swift
struct ContentView: View {
    @State private var query = ""

    var body: some View {
        DebouncedSearchField(
            text: $query,
            delay: 0.4
        ) { value in
            await search(for: value)
        }
        .padding()
    }

    private func search(for value: String) async {
        print("Search:", value)
    }
}
```

The search callback runs only after the user stops typing for the configured delay.

## Loading State

```swift
DebouncedSearchField(
    text: $query,
    prompt: "Search products",
    delay: 0.4,
    isLoading: isLoading
) { value in
    await searchProducts(for: value)
}
```

When `isLoading` is true, the trailing clear button is replaced by a small progress indicator.

## Submit Immediately

Pressing Return cancels the pending debounce delay and runs the search immediately.

You can also observe submit separately:

```swift
DebouncedSearchField(
    text: $query,
    onSubmit: { value in
        print("Submitted:", value)
    }
) { value in
    await search(for: value)
}
```

## Disable the Clear Button

```swift
DebouncedSearchField(
    text: $query,
    showsClearButton: false
) { value in
    await search(for: value)
}
```

## Parameters

| Parameter | Description | Default |
|---|---|---|
| `text` | Search text binding | Required |
| `prompt` | Text field placeholder | `Search` |
| `delay` | Debounce delay in seconds | `0.4` |
| `showsClearButton` | Shows a clear button when text is not empty | `true` |
| `isLoading` | Shows a progress indicator | `false` |
| `onSubmit` | Optional callback when Return is pressed | `nil` |
| `onSearch` | Async debounced search callback | Required |

## How Debouncing Works

Without debouncing, typing:

```
swift
```

could trigger separate searches for:

```
s
sw
swi
swif
swift
```

This component cancels the previous pending task every time the text changes. The callback runs only after the user pauses for the configured delay.

That reduces unnecessary filtering, database work, and network requests.

## Task Cancellation

The debounce task is cancelled whenever:

- The query changes before the delay finishes
- The user presses Return
- The search field disappears

If your `onSearch` closure performs long-running async work, that work should also cooperate with Swift task cancellation when appropriate.

## Example

A complete async filtering example is included in:

```
Examples/ProductSearchExample.swift
```

## Testing

Run:

```bash
swift test
```

GitHub Actions CI is included.

## Contributing

Contributions and improvements are welcome.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is available under the MIT License.

See [LICENSE](LICENSE).

---

Created by **Niloufar Rabiee**
