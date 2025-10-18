import 'package:google_maps_extractor/google_maps_extractor.dart';

void main() async {
  print('🗺️  Google Maps Extractor - Examples\n');
  print('=' * 60);

  // Example 1: Basic coordinate extraction
  await example1BasicExtraction();

  // Example 2: Shortened URL expansion
  await example2ShortenedUrls();

  // Example 3: Multiple URL formats
  await example3MultipleFormats();

  // Example 4: Metadata extraction
  await example4MetadataExtraction();

  // Example 5: URL validation
  await example5UrlValidation();

  // Example 6: Error handling
  await example6ErrorHandling();

  // Example 7: Batch processing
  await example7BatchProcessing();

  // Example 8: Performance comparison
  await example8PerformanceComparison();

  print('\n${'=' * 60}');
  print('✅ All examples completed successfully!');
}

/// Example 1: Basic coordinate extraction from a standard URL
Future<void> example1BasicExtraction() async {
  print('\n📍 Example 1: Basic Coordinate Extraction');
  print('-' * 60);

  const url = 'https://www.google.com/maps?q=30.0444,31.2357';
  print('URL: $url');

  final coordinates = await GoogleMapsExtractor.processGoogleMapsUrl(url);

  if (coordinates != null) {
    print('✅ Success!');
    print('   Latitude:  ${coordinates['latitude']}');
    print('   Longitude: ${coordinates['longitude']}');
  } else {
    print('❌ Failed to extract coordinates');
  }
}

/// Example 2: Expanding and extracting from shortened URLs
Future<void> example2ShortenedUrls() async {
  print('\n🔗 Example 2: Shortened URL Expansion');
  print('-' * 60);

  // Note: This is an example URL. Replace with actual shortened URL for testing
  const shortUrl = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
  print('Short URL: $shortUrl');

  print('⏳ Expanding URL...');
  final coordinates = await GoogleMapsExtractor.processGoogleMapsUrl(shortUrl);

  if (coordinates != null) {
    print('✅ Successfully expanded and extracted!');
    print('   Latitude:  ${coordinates['latitude']}');
    print('   Longitude: ${coordinates['longitude']}');
  } else {
    print('❌ Could not expand or extract from URL');
    print(
      '   (This may happen if the URL is invalid or network is unavailable)',
    );
  }
}

/// Example 3: Different URL format types
Future<void> example3MultipleFormats() async {
  print('\n📋 Example 3: Multiple URL Formats');
  print('-' * 60);

  final testUrls = {
    'Standard Query': 'https://www.google.com/maps?q=40.7128,-74.0060',
    'View Mode': 'https://www.google.com/maps/@40.7128,-74.0060,15z',
    'Place URL': 'https://www.google.com/maps/place/Cairo/@30.0444,31.2357,12z',
    'Search URL': 'https://www.google.com/maps/search/30.0444,31.2357',
    'Directions':
        'https://www.google.com/maps/dir/?api=1&origin=40.7128,-74.0060&destination=34.0522,-118.2437',
    'Street View': 'https://www.google.com/maps?cbll=48.857832,2.295226',
    'Legacy Format': 'https://www.google.com/maps?ll=51.5074,-0.1278',
    'Center Param':
        'https://www.google.com/maps?center=35.6762,139.6503&zoom=12',
  };

  for (final entry in testUrls.entries) {
    print('\n${entry.key}:');
    print('   URL: ${entry.value}');

    final coords = GoogleMapsExtractor.extractCoordinates(entry.value);
    if (coords != null) {
      print('   ✅ Lat: ${coords['latitude']}, Lng: ${coords['longitude']}');
    } else {
      print('   ❌ Could not extract coordinates');
    }
  }
}

/// Example 4: Extracting metadata from URLs
Future<void> example4MetadataExtraction() async {
  print('\n🎨 Example 4: Metadata Extraction');
  print('-' * 60);

  final testCases = [
    'https://www.google.com/maps/place/Cairo/@30.0444,31.2357,12z',
    'https://www.google.com/maps/place/New+York/@40.7128,-74.0060,15z?t=k',
    'https://www.google.com/maps/place/Tokyo/@35.6762,139.6503,10z?t=h',
  ];

  for (var i = 0; i < testCases.length; i++) {
    final url = testCases[i];
    print('\nCase ${i + 1}:');
    print('   URL: $url');

    final metadata = GoogleMapsExtractor.extractMetadata(url);
    final coords = GoogleMapsExtractor.extractCoordinates(url);

    if (coords != null) {
      print('   📍 Coordinates: ${coords['latitude']}, ${coords['longitude']}');
    }

    if (metadata != null) {
      print('   🔍 Metadata:');
      if (metadata.containsKey('placeName')) {
        print('      Place: ${metadata['placeName']}');
      }
      if (metadata.containsKey('zoom')) {
        print('      Zoom: ${metadata['zoom']}');
      }
      if (metadata.containsKey('mapType')) {
        print('      Map Type: ${metadata['mapType']}');
      }
    } else {
      print('   ℹ️  No metadata found');
    }
  }
}

/// Example 5: URL validation before processing
Future<void> example5UrlValidation() async {
  print('\n✅ Example 5: URL Validation');
  print('-' * 60);

  final testUrls = [
    'https://www.google.com/maps?q=40.7128,-74.0060',
    'https://maps.google.com/maps?q=51.5074,-0.1278',
    'https://www.google.co.uk/maps?q=48.8566,2.3522',
    'https://maps.app.goo.gl/abc123',
    'https://goo.gl/maps/xyz789',
    'https://www.openstreetmap.org', // Invalid
    'https://www.example.com', // Invalid
    'not a url at all', // Invalid
  ];

  for (final url in testUrls) {
    final isValid = GoogleMapsExtractor.isGoogleMapsUrl(url);
    final icon = isValid ? '✅' : '❌';
    final status = isValid ? 'Valid' : 'Invalid';
    print(
      '$icon $status: ${url.substring(0, url.length > 50 ? 50 : url.length)}...',
    );
  }
}

/// Example 6: Error handling and edge cases
Future<void> example6ErrorHandling() async {
  print('\n⚠️  Example 6: Error Handling');
  print('-' * 60);

  final edgeCases = {
    'Empty String': '',
    'Just Whitespace': '   ',
    'No Coordinates': 'https://www.google.com/maps',
    'Invalid Coords': 'https://www.google.com/maps?q=invalid,coordinates',
    'Out of Range': 'https://www.google.com/maps?q=91.0,181.0',
    'Malformed URL': 'htp://google.com/maps',
  };

  for (final entry in edgeCases.entries) {
    print('\n${entry.key}: "${entry.value}"');

    try {
      final coords = await GoogleMapsExtractor.processGoogleMapsUrl(
        entry.value,
      );
      if (coords != null) {
        print('   ✅ Extracted: ${coords['latitude']}, ${coords['longitude']}');
      } else {
        print('   ℹ️  Returned null (expected for invalid input)');
      }
    } catch (e) {
      print('   ⚠️  Exception caught: $e');
    }
  }
}

/// Example 7: Batch processing multiple URLs
Future<void> example7BatchProcessing() async {
  print('\n📦 Example 7: Batch Processing');
  print('-' * 60);

  final urls = [
    'https://www.google.com/maps?q=40.7128,-74.0060', // New York
    'https://www.google.com/maps?q=51.5074,-0.1278', // London
    'https://www.google.com/maps?q=35.6762,139.6503', // Tokyo
    'https://www.google.com/maps?q=30.0444,31.2357', // Cairo
    'https://www.google.com/maps?q=-33.8688,151.2093', // Sydney
  ];

  print('Processing ${urls.length} URLs...\n');

  final results = await Future.wait(
    urls.map((url) => GoogleMapsExtractor.processGoogleMapsUrl(url)),
  );

  final cities = ['New York', 'London', 'Tokyo', 'Cairo', 'Sydney'];

  for (var i = 0; i < results.length; i++) {
    final coords = results[i];
    if (coords != null) {
      print(
        '✅ ${cities[i].padRight(10)}: ${coords['latitude']}, ${coords['longitude']}',
      );
    } else {
      print('❌ ${cities[i].padRight(10)}: Failed to extract');
    }
  }
}

/// Example 8: Performance comparison between direct and async extraction
Future<void> example8PerformanceComparison() async {
  print('\n⚡ Example 8: Performance Comparison');
  print('-' * 60);

  const url = 'https://www.google.com/maps?q=40.7128,-74.0060';
  const iterations = 1000;

  // Test direct extraction (synchronous)
  print('\nTesting direct extraction ($iterations iterations)...');
  final directStopwatch = Stopwatch()..start();

  for (var i = 0; i < iterations; i++) {
    GoogleMapsExtractor.extractCoordinates(url);
  }

  directStopwatch.stop();
  final directMs = directStopwatch.elapsedMilliseconds;
  final directAvg = directMs / iterations;

  print('   Total time: ${directMs}ms');
  print('   Average: ${directAvg.toStringAsFixed(3)}ms per extraction');

  // Test validation (very fast)
  print('\nTesting URL validation ($iterations iterations)...');
  final validationStopwatch = Stopwatch()..start();

  for (var i = 0; i < iterations; i++) {
    GoogleMapsExtractor.isGoogleMapsUrl(url);
  }

  validationStopwatch.stop();
  final validationMs = validationStopwatch.elapsedMilliseconds;
  final validationAvg = validationMs / iterations;

  print('   Total time: ${validationMs}ms');
  print('   Average: ${validationAvg.toStringAsFixed(3)}ms per validation');

  // Test async processing (single call)
  print('\nTesting async processing (single call)...');
  final asyncStopwatch = Stopwatch()..start();

  await GoogleMapsExtractor.processGoogleMapsUrl(url);

  asyncStopwatch.stop();
  print('   Time: ${asyncStopwatch.elapsedMilliseconds}ms');

  // Summary
  print('\n📊 Performance Summary:');
  print('   Direct extraction:  ~${directAvg.toStringAsFixed(3)}ms per call');
  print(
    '   URL validation:     ~${validationAvg.toStringAsFixed(3)}ms per call',
  );
  print(
    '   Async processing:   ~${asyncStopwatch.elapsedMilliseconds}ms per call',
  );
  print(
    '\n   💡 Tip: Use direct extraction for non-shortened URLs for better performance!',
  );
}

/// Bonus: Real-world integration example
void realWorldExample() {
  print('\n🌟 Real-World Integration Example');
  print('-' * 60);
  print('''
// In a Flutter app, you might use it like this:

class LocationShareScreen extends StatefulWidget {
  @override
  _LocationShareScreenState createState() => _LocationShareScreenState();
}

class _LocationShareScreenState extends State<LocationShareScreen> {
  final _controller = TextEditingController();
  Map<String, double>? _coordinates;
  bool _isLoading = false;
  String? _error;

  Future<void> _extractLocation() async {
    // Validate first
    if (!GoogleMapsExtractor.isGoogleMapsUrl(_controller.text)) {
      setState(() => _error = 'Please enter a valid Google Maps URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final coords = await GoogleMapsExtractor.processGoogleMapsUrl(
        _controller.text,
      );

      setState(() {
        _coordinates = coords;
        _isLoading = false;
        if (coords == null) {
          _error = 'Could not extract location from URL';
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Error: \$e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Share Location')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Paste Google Maps URL',
                errorText: _error,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _extractLocation,
                ),
              ),
            ),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_coordinates != null)
              Card(
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Location Found'),
                  subtitle: Text(
                    'Lat: \${_coordinates!['latitude']}\\n'
                    'Lng: \${_coordinates!['longitude']}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
''');
}
