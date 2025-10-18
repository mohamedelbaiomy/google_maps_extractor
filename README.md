<div align="center">

# 🗺️ Google Maps Extractor

### *Extract location data from any Google Maps URL with ease*

[![pub package](https://img.shields.io/pub/v/google_maps_extractor.svg)](https://pub.dev/packages/google_maps_extractor)
[![popularity](https://img.shields.io/pub/popularity/google_maps_extractor?logo=dart)](https://pub.dev/packages/google_maps_extractor/score)
[![likes](https://img.shields.io/pub/likes/google_maps_extractor?logo=dart)](https://pub.dev/packages/google_maps_extractor/score)
[![pub points](https://img.shields.io/pub/points/google_maps_extractor?logo=dart)](https://pub.dev/packages/google_maps_extractor/score)

A comprehensive Flutter package for extracting coordinates and metadata from Google Maps URLs. Supports **21 different URL formats** including shortened URLs, place links, directions, and more.

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Examples](#-examples) • [API](#-api-reference) • [Contributing](#-contributing)

</div>

---

## ✨ Features

- 🎯 **Universal Support** - Works with all known Google Maps URL formats
- 🔗 **Shortened URLs** - Automatically expands goo.gl and maps.app.goo.gl links
- 🌍 **International Domains** - Supports all Google domain variants (.com, .co.uk, .ca, etc.)
- 📍 **Multiple Formats** - Place URLs, directions, street view, embedded maps, and more
- 🎨 **Metadata Extraction** - Get zoom level, map type, and place names
- ⚡ **High Performance** - Optimized pattern matching with 21 regex patterns
- 🛡️ **Robust** - Comprehensive validation and error handling
- ✅ **Well Tested** - 100+ test scenarios with 85%+ coverage
- 📱 **Flutter Ready** - Built specifically for Flutter applications

---

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  google_maps_extractor: ^1.0.2
```

Then run:

```bash
flutter pub get
```

Or install it from the command line:

```bash
flutter pub add google_maps_extractor
```

---

## 📖 Usage

### Quick Start

```dart
import 'package:google_maps_extractor/google_maps_extractor.dart';

// Extract coordinates from any Google Maps URL
final coordinates = await GoogleMapsExtractor.processGoogleMapsUrl(
  'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7'
);

if (coordinates != null) {
  print('📍 Latitude: ${coordinates['latitude']}');
  print('📍 Longitude: ${coordinates['longitude']}');
}
```

### Validate URLs Before Processing

```dart
final url = 'https://www.google.com/maps?q=30.0444,31.2357';

if (GoogleMapsExtractor.isGoogleMapsUrl(url)) {
  final coords = await GoogleMapsExtractor.processGoogleMapsUrl(url);
  // Use coordinates...
}
```

### Extract Metadata

```dart
final url = 'https://www.google.com/maps/place/Cairo/@30.0444,31.2357,12z';
final metadata = GoogleMapsExtractor.extractMetadata(url);

print('🔍 Zoom: ${metadata['zoom']}');
print('🗺️ Map Type: ${metadata['mapType']}');
print('📌 Place: ${metadata['placeName']}');
```

---

## 💡 Examples

### Example 1: Location Sharing App

```dart
class LocationExtractor extends StatefulWidget {
  @override
  _LocationExtractorState createState() => _LocationExtractorState();
}

class _LocationExtractorState extends State<LocationExtractor> {
  final _controller = TextEditingController();
  Map<String, double>? _coordinates;
  bool _isLoading = false;

  Future<void> _extractLocation() async {
    setState(() => _isLoading = true);
    
    final coords = await GoogleMapsExtractor.processGoogleMapsUrl(
      _controller.text,
    );
    
    setState(() {
      _coordinates = coords;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Paste Google Maps URL',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _extractLocation,
            ),
          ),
        ),
        if (_isLoading)
          CircularProgressIndicator()
        else if (_coordinates != null)
          Text('📍 ${_coordinates!['latitude']}, ${_coordinates!['longitude']}'),
      ],
    );
  }
}
```

### Example 2: Batch URL Processing

```dart
Future<List<Map<String, double>?>> extractMultipleLocations(
  List<String> urls,
) async {
  return await Future.wait(
    urls.map((url) => GoogleMapsExtractor.processGoogleMapsUrl(url)),
  );
}

// Usage
final urls = [
  'https://goo.gl/maps/abc123',
  'https://www.google.com/maps?q=40.7128,-74.0060',
  'https://maps.app.goo.gl/xyz789',
];

final locations = await extractMultipleLocations(urls);
for (var location in locations) {
  if (location != null) {
    print('Found: ${location['latitude']}, ${location['longitude']}');
  }
}
```

### Example 3: Map Integration

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> navigateToSharedLocation(String mapsUrl) async {
  final coords = await GoogleMapsExtractor.processGoogleMapsUrl(mapsUrl);
  final metadata = GoogleMapsExtractor.extractMetadata(mapsUrl);
  
  if (coords != null) {
    final position = LatLng(
      coords['latitude']!,
      coords['longitude']!,
    );
    
    // Move camera to location
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: metadata?['zoom']?.toDouble() ?? 15.0,
        ),
      ),
    );
  }
}
```

---

## 🎯 Supported URL Formats

The package recognizes and extracts coordinates from **21 different patterns**:

<details>
<summary><b>📋 Click to see all supported formats</b></summary>

| Format | Example URL |
|--------|-------------|
| **Standard Query** | `google.com/maps?q=40.7128,-74.0060` |
| **View Mode** | `google.com/maps/@40.7128,-74.0060,15z` |
| **Place URLs** | `google.com/maps/place/Cairo/@30.0444,31.2357` |
| **Search URLs** | `google.com/maps/search/30.0444,31.2357` |
| **Directions** | `google.com/maps/dir/?origin=40.7128,-74.0060` |
| **Shortened URLs** | `maps.app.goo.gl/abc123` |
| **Legacy goo.gl** | `goo.gl/maps/xyz789` |
| **Street View** | `google.com/maps?cbll=48.858,2.295` |
| **Embedded Maps** | `google.com/maps/embed?pb=...` |
| **Plus Codes** | `plus.codes/8FVC9G8F+6X` |
| **URL Fragments** | `google.com/maps#40.7128,-74.0060` |
| **Center Parameter** | `google.com/maps?center=40.7128,-74.0060` |
| **Legacy ll** | `google.com/maps?ll=40.7128,-74.0060` |
| **International** | `google.co.uk/maps?q=51.5074,-0.1278` |
| **Mobile Deep Links** | `google.com/maps?coordinates=40.7128,-74.0060` |
| And 6+ more formats... | |

</details>

---

## 📚 API Reference

### Core Methods

#### `processGoogleMapsUrl(String url)`

Processes any Google Maps URL and extracts coordinates.

**Parameters:**
- `url` (String): The Google Maps URL to process

**Returns:** `Future<Map<String, double>?>` with keys `'latitude'` and `'longitude'`, or `null` if extraction fails

**Example:**
```dart
final coords = await GoogleMapsExtractor.processGoogleMapsUrl(url);
```

---

#### `extractCoordinates(String url)`

Directly extracts coordinates from a URL without expansion (faster for non-shortened URLs).

**Parameters:**
- `url` (String): The Google Maps URL to parse

**Returns:** `Map<String, double>?` with keys `'latitude'` and `'longitude'`, or `null`

**Example:**
```dart
final coords = GoogleMapsExtractor.extractCoordinates(url);
```

---

#### `isGoogleMapsUrl(String url)`

Validates whether a URL is a Google Maps URL.

**Parameters:**
- `url` (String): The URL to validate

**Returns:** `bool` - `true` if valid Google Maps URL

**Example:**
```dart
if (GoogleMapsExtractor.isGoogleMapsUrl(url)) {
  // Process the URL
}
```

---

#### `extractMetadata(String url)`

Extracts additional metadata from the URL.

**Parameters:**
- `url` (String): The Google Maps URL

**Returns:** `Map<String, dynamic>?` containing:
- `zoom` (int): Zoom level
- `mapType` (String): 'satellite', 'hybrid', 'terrain', or 'roadmap'
- `placeName` (String): Decoded place name

**Example:**
```dart
final metadata = GoogleMapsExtractor.extractMetadata(url);
print('Zoom: ${metadata['zoom']}');
```

---

#### `expandShortUrl(String shortUrl, {int timeoutSeconds = 10})`

Expands shortened URLs (goo.gl, maps.app.goo.gl).

**Parameters:**
- `shortUrl` (String): The shortened URL
- `timeoutSeconds` (int): Request timeout (default: 10)

**Returns:** `Future<String?>` - Expanded URL or `null`

**Example:**
```dart
final expanded = await GoogleMapsExtractor.expandShortUrl(shortUrl);
```

---

## 🎨 Advanced Usage

### Custom Error Handling

```dart
try {
  final coords = await GoogleMapsExtractor.processGoogleMapsUrl(url);
  
  if (coords == null) {
    // Handle invalid URL
    showSnackBar('Could not extract location from URL');
  } else {
    // Use coordinates
    navigateToLocation(coords);
  }
} catch (e) {
  // Handle errors
  print('Error processing URL: $e');
}
```

### URL Pre-validation

```dart
Future<Map<String, double>?> safeExtractCoordinates(String url) async {
  // Validate before processing
  if (!GoogleMapsExtractor.isGoogleMapsUrl(url)) {
    throw ArgumentError('Not a valid Google Maps URL');
  }
  
  return await GoogleMapsExtractor.processGoogleMapsUrl(url);
}
```

### Performance Optimization

```dart
// For known non-shortened URLs, use direct extraction (faster)
final coords = GoogleMapsExtractor.extractCoordinates(url);

// For shortened URLs, use full processing
final coords = await GoogleMapsExtractor.processGoogleMapsUrl(url);
```

---

## 🧪 Testing

The package includes comprehensive tests with 85%+ coverage:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🌟 Real-World Use Cases

- 📱 **Location Sharing Apps** - Extract locations from shared Google Maps links
- 🗺️ **Map Applications** - Parse user-provided URLs to display locations
- 📍 **Travel Planners** - Extract coordinates from itinerary links
- 🚗 **Navigation Apps** - Process destination URLs
- 📊 **Analytics Tools** - Extract location data from social media posts
- 🏢 **Business Apps** - Validate and process customer location shares

---

## ⚙️ Requirements

- **Dart SDK:** >=3.0.0 <4.0.0
- **Flutter SDK:** Any version
- **Dependencies:**
    - `http: ^1.2.0`

---

## 🐛 Troubleshooting

### Issue: Shortened URLs not expanding

**Solution:** Check your internet connection. The package requires network access to expand shortened URLs.

```dart
final expanded = await GoogleMapsExtractor.expandShortUrl(
  shortUrl,
  timeoutSeconds: 15, // Increase timeout
);
```

### Issue: Coordinates not extracted

**Solution:** Verify the URL format is supported. Enable debug mode:

```dart
import 'package:flutter/foundation.dart';

// Debug output will show pattern matching attempts
debugPrint('Processing URL: $url');
```

### Issue: Performance concerns

**Solution:** Use direct extraction for non-shortened URLs:

```dart
// Fast (synchronous)
final coords = GoogleMapsExtractor.extractCoordinates(url);

// Slower (async, handles shortened URLs)
final coords = await GoogleMapsExtractor.processGoogleMapsUrl(url);
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 Fork the repository
2. 🔨 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. ✅ Add tests for your changes
4. 💾 Commit your changes (`git commit -m 'Add amazing feature'`)
5. 📤 Push to the branch (`git push origin feature/amazing-feature`)
6. 🎉 Open a Pull Request

### Development Setup

```bash
# Clone the repository
git clone https://github.com/mohamedelbaiomy/google_maps_extractor.git

# Install dependencies
flutter pub get

# Run tests
flutter test

# Check code quality
flutter analyze
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Mohamed Elbaiomy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 🙏 Acknowledgments

- Built with ❤️ for the Flutter community
- Inspired by the need for robust Google Maps URL parsing
- Thanks to all contributors and users

---

## 📞 Support

- 📧 **Email:** mohamedelbaiomy262003@gmail.com
- 🐛 **Issues:** [GitHub Issues](https://github.com/mohamedelbaiomy/google_maps_extractor/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/mohamedelbaiomy/google_maps_extractor/discussions)
- 📖 **Documentation:** [pub.dev](https://pub.dev/packages/google_maps_extractor)

---

## 📊 Package Statistics

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=mohamedelbaiomy/google_maps_extractor&type=Date)](https://star-history.com/#mohamedelbaiomy/google_maps_extractor&Date)

</div>

---

## 🗺️ Roadmap

- [ ] Add support for Apple Maps URLs
- [ ] Add support for OpenStreetMap URLs
- [ ] Add coordinate format conversion utilities
- [ ] Add reverse geocoding support
- [ ] Add offline caching for expanded URLs
- [ ] Add support for What3Words codes

---

<div align="center">

### Made with ❤️ by Mohamed Elbaiomy

**If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/mohamedelbaiomy/google_maps_extractor)!**

[⬆ Back to top](#-google-maps-url-extractor)

</div>