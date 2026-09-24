import XCTest
@testable import DebouncedSearchField

final class DebouncedSearchFieldTests: XCTestCase {
    func testValidDelayIsPreserved() {
        XCTAssertEqual(
            DebounceConfiguration.normalizedDelay(0.4),
            0.4,
            accuracy: 0.0001
        )
    }

    func testZeroDelayIsClamped() {
        XCTAssertEqual(
            DebounceConfiguration.normalizedDelay(0),
            DebounceConfiguration.minimumDelay,
            accuracy: 0.0001
        )
    }

    func testNegativeDelayIsClamped() {
        XCTAssertEqual(
            DebounceConfiguration.normalizedDelay(-1),
            DebounceConfiguration.minimumDelay,
            accuracy: 0.0001
        )
    }

    func testInfiniteDelayUsesFallback() {
        XCTAssertEqual(
            DebounceConfiguration.normalizedDelay(.infinity),
            DebounceConfiguration.fallbackDelay,
            accuracy: 0.0001
        )
    }

    func testNaNDelayUsesFallback() {
        XCTAssertEqual(
            DebounceConfiguration.normalizedDelay(.nan),
            DebounceConfiguration.fallbackDelay,
            accuracy: 0.0001
        )
    }
}
