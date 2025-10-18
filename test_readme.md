# Test Suite for Google Maps Extractor

This directory contains comprehensive tests for the Google Maps Extractor package.

## Test Files

### `google_maps_extractor_test.dart`
Main test suite with 80+ test cases covering:

#### 1. **extractCoordinates Tests**
- ✅ Standard embedded format (!3d!4d)
- ✅ Query parameter formats (q=, ll=, center=)
- ✅ Plus sign handling in coordinates
- ✅ View mode coordinates (@lat,lng,zoom)
- ✅ Directions (origin/destination)
- ✅ Street View (cbll parameter)
- ✅ Place URLs
- ✅ Search URLs
- ✅ URL fragments
- ✅ Negative coordinates
- ✅ High precision coordinates
- ✅ International domains
- ✅ Invalid coordinate validation
- ✅ Complex URLs with multiple parameters
- ✅ Zero-value coordinates

#### 2. **isGoogleMapsUrl Tests**
- ✅ Standard Google Maps URLs
- ✅ maps.google.com variants
- ✅ Shortened URLs (goo.gl, maps.app.goo.gl)
- ✅ International domains (UK, Canada, Australia)
- ✅ Plus codes
- ✅ Case-insensitive validation
- ✅ Invalid URL rejection
- ✅ Edge cases (empty strings)

#### 3. **extractMetadata Tests**
- ✅ Zoom level extraction
- ✅ Map type detection (satellite, hybrid, terrain, roadmap)
- ✅ Place name extraction
- ✅ URL-encoded place names
- ✅ Multiple metadata fields
- ✅ Special characters in place names
- ✅ Layer parameter handling

#### 4. **processGoogleMapsUrl Tests**
- ✅ Standard URL processing
- ✅ URLs without http prefix
- ✅ Whitespace handling
- ✅ Invalid URL handling
- ✅ Complex place URLs
- ✅ Directions with multiple coordinates

#### 5. **expandShortUrl Tests**
- ✅ Non-redirect URL handling
- ✅ Timeout handling
- ✅ Error handling

#### 6. **Edge Cases**
- ✅ Equator and prime meridian (0,0)
- ✅ North Pole (90,0)
- ✅ South Pole (-90,0)
- ✅ International Date Line (±180)
- ✅ Very long URLs
- ✅ Special characters
- ✅ Malformed coordinates
- ✅ Partially valid coordinates

#### 7. **Performance Tests**
- ✅ Multiple pattern checks efficiency
- ✅ URL validation efficiency

### `google_maps_extractor_mock_test.dart`
Mock tests for HTTP functionality (requires implementation modification):

- Mock HTTP redirect responses (301, 302, 307, 308)
- Meta refresh redirect parsing
- JavaScript redirect parsing
- Error handling scenarios
- Timeout scenarios
- Malformed responses

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/google_maps_extractor_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Generate coverage report
```bash
# Install lcov first (if not installed)
# macOS: brew install lcov
# Linux: sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report
open coverage/html/index.html
```

## Test Coverage

Current test coverage targets:
- **extractCoordinates**: 21 URL pattern tests + edge cases = ~95% coverage
- **isGoogleMapsUrl**: All domain variants = 100% coverage
- **extractMetadata**: All metadata types = 100% coverage
- **processGoogleMapsUrl**: Main flow + edge cases = ~90% coverage
- **expandShortUrl**: Basic functionality (limited due to network calls) = ~60% coverage

**Overall Target**: 85%+ code coverage

## Test Categories

### Unit Tests
Tests for individual methods in isolation:
- Pattern matching
- Coordinate validation
- URL validation
- Metadata extraction

### Integration Tests
Tests for complete workflows:
- URL processing with coordinate extraction
- Shortened URL expansion and extraction
- Error handling across multiple methods

### Edge Case Tests
Tests for boundary conditions:
- Extreme coordinates (poles, date line)
- Invalid inputs
- Malformed URLs
- Empty/null values

### Performance Tests
Tests to ensure efficiency:
- Pattern matching speed
- Validation speed
- Memory usage with large URLs

## Known Limitations

### Network-dependent Tests
The `expandShortUrl` method makes actual HTTP requests, which:
- Cannot be easily mocked without modifying the implementation
- May fail due to network issues
- Are slow compared to pure unit tests

**Recommendation**: Consider refactoring `expandShortUrl` to accept an optional `http.Client` parameter for better testability.

### Suggested Implementation Change
```dart
static Future<String?> expandShortUrl(
  String shortUrl, {
  int timeoutSeconds = 10,
  http.Client? client,  // Add this parameter
}) async {
  final httpClient = client ?? http.Client();
  // Use httpClient instead of creating new one
  // ... rest of implementation
}
```

## Adding New Tests

When adding new URL patterns or features:

1. **Add pattern test**: Test the new regex pattern works correctly
2. **Add integration test**: Test the pattern works in `processGoogleMapsUrl`
3. **Add edge cases**: Test boundary conditions for the new pattern
4. **Update coverage**: Ensure coverage remains above 85%

### Example Test Template
```dart
test('extracts coordinates from new pattern', () {
  const url = 'https://www.google.com/maps/your-new-pattern/40.7128,-74.0060';
  final result = GoogleMapsExtractor.extractCoordinates(url);

  expect(result, isNotNull);
  expect(result!['latitude'], 40.7128);
  expect(result['longitude'], -74.0060);
});
```

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
```

## Test Data Sources

Real Google Maps URLs used in tests come from:
- Official Google Maps documentation
- Common user-generated URLs
- International domain variants
- Various map view modes (satellite, terrain, etc.)

## Contributing

When contributing tests:
1. Follow existing test patterns
2. Use descriptive test names
3. Test both success and failure cases
4. Add comments for complex scenarios
5. Ensure tests are deterministic (no flaky tests)
6. Keep tests fast (< 1ms per test when possible)

## Troubleshooting

### Tests fail with network errors
- `expandShortUrl` tests may fail without internet
- Consider using mock clients for these tests
- Or skip network-dependent tests in CI

### Tests fail on different platforms
- Ensure regex patterns are platform-independent
- Test on multiple platforms (iOS, Android, Web)
- Use platform-agnostic assertions

### Performance tests fail
- Adjust thresholds for slower CI environments
- Use relative performance checks when possible
- Consider skipping performance tests in CI