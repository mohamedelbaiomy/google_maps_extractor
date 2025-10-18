// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_extractor/google_maps_extractor.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Maps Extractor Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const LocationExtractorPage(),
//     );
//   }
// }
//
// class LocationExtractorPage extends StatefulWidget {
//   const LocationExtractorPage({super.key});
//
//   @override
//   State<LocationExtractorPage> createState() => _LocationExtractorPageState();
// }
//
// class _LocationExtractorPageState extends State<LocationExtractorPage> {
//   final _urlController = TextEditingController();
//   bool _isLoading = false;
//   Map<String, double>? _coordinates;
//   Map<String, dynamic>? _metadata;
//   String? _errorMessage;
//
//   @override
//   void dispose() {
//     _urlController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _extractLocation() async {
//     final url = _urlController.text.trim();
//
//     // Clear previous results
//     setState(() {
//       _coordinates = null;
//       _metadata = null;
//       _errorMessage = null;
//     });
//
//     // Validate URL
//     if (url.isEmpty) {
//       setState(() => _errorMessage = 'Please enter a URL');
//       return;
//     }
//
//     if (!GoogleMapsExtractor.isGoogleMapsUrl(url)) {
//       setState(() => _errorMessage = 'Invalid Google Maps URL');
//       return;
//     }
//
//     // Start loading
//     setState(() => _isLoading = true);
//
//     try {
//       // Extract coordinates
//       final coords = await GoogleMapsExtractor.processGoogleMapsUrl(url);
//
//       // Extract metadata
//       final metadata = GoogleMapsExtractor.extractMetadata(url);
//
//       setState(() {
//         _coordinates = coords;
//         _metadata = metadata;
//         _isLoading = false;
//
//         if (coords == null) {
//           _errorMessage = 'Could not extract coordinates from URL';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _pasteFromClipboard() async {
//     final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
//     if (clipboardData?.text != null) {
//       _urlController.text = clipboardData!.text!;
//     }
//   }
//
//   void _clearAll() {
//     setState(() {
//       _urlController.clear();
//       _coordinates = null;
//       _metadata = null;
//       _errorMessage = null;
//     });
//   }
//
//   void _copyCoordinates() {
//     if (_coordinates != null) {
//       final text =
//           '${_coordinates!['latitude']}, ${_coordinates!['longitude']}';
//       Clipboard.setData(ClipboardData(text: text));
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Coordinates copied to clipboard!')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('🗺️ URL Extractor'),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Header
//             const Text(
//               'Extract Location from Google Maps URL',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Paste any Google Maps URL to extract coordinates',
//               style: TextStyle(color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//
//             // URL Input Field
//             TextField(
//               controller: _urlController,
//               decoration: InputDecoration(
//                 labelText: 'Google Maps URL',
//                 hintText: 'https://maps.google.com/...',
//                 prefixIcon: const Icon(Icons.link),
//                 suffixIcon: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.paste),
//                       onPressed: _pasteFromClipboard,
//                       tooltip: 'Paste from clipboard',
//                     ),
//                     if (_urlController.text.isNotEmpty)
//                       IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: _clearAll,
//                         tooltip: 'Clear',
//                       ),
//                   ],
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 errorText: _errorMessage,
//               ),
//               maxLines: 3,
//               onChanged: (_) => setState(() => _errorMessage = null),
//             ),
//             const SizedBox(height: 16),
//
//             // Extract Button
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : _extractLocation,
//               icon: _isLoading
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//                   : const Icon(Icons.search),
//               label: Text(_isLoading ? 'Extracting...' : 'Extract Location'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Results Section
//             if (_coordinates != null) ...[
//               _buildResultCard(),
//               const SizedBox(height: 16),
//             ],
//
//             // Metadata Section
//             if (_metadata != null) ...[
//               _buildMetadataCard(),
//               const SizedBox(height: 16),
//             ],
//
//             // Example URLs
//             _buildExamplesSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResultCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.check_circle, color: Colors.green),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Location Found',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.copy),
//                   onPressed: _copyCoordinates,
//                   tooltip: 'Copy coordinates',
//                 ),
//               ],
//             ),
//             const Divider(),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               Icons.location_on,
//               'Latitude',
//               _coordinates!['latitude'].toString(),
//             ),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               Icons.location_on,
//               'Longitude',
//               _coordinates!['longitude'].toString(),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Open in maps app
//                 final lat = _coordinates!['latitude'];
//                 final lng = _coordinates!['longitude'];
//                 final url = 'https://www.google.com/maps?q=$lat,$lng';
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Open: $url')),
//                 );
//               },
//               icon: const Icon(Icons.map),
//               label: const Text('Open in Maps'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(40),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMetadataCard() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.info_outline, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text(
//                   'Additional Information',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(),
//             const SizedBox(height: 8),
//             if (_metadata!.containsKey('placeName'))
//               _buildInfoRow(
//                 Icons.place,
//                 'Place',
//                 _metadata!['placeName'],
//               ),
//             if (_metadata!.containsKey('zoom'))
//               _buildInfoRow(
//                 Icons.zoom_in,
//                 'Zoom Level',
//                 _metadata!['zoom'].toString(),
//               ),
//             if (_metadata!.containsKey('mapType'))
//               _buildInfoRow(
//                 Icons.map,
//                 'Map Type',
//                 _metadata!['mapType'],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey),
//         const SizedBox(width: 8),
//         Text(
//           '$label:',
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildExamplesSection() {
//     final examples = [
//       (
//       'Standard URL',
//       'https://www.google.com/maps?q=40.7128,-74.0060',
//       ),
//       (
//       'Place URL',
//       'https://www.google.com/maps/place/Cairo/@30.0444,31.2357,12z',
//       ),
//       (
//       'Shortened URL',
//       'https://maps.app.goo.gl/example',
//       ),
//     ];
//
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.lightbulb_outline, color: Colors.orange),
//                 SizedBox(width: 8),
//                 Text(
//                   'Example URLs',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(),
//             ...examples.map(
//                   (example) => ListTile(
//                 dense: true,
//                 title: Text(example.$1),
//                 subtitle: Text(
//                   example.$2,
//                   style: const TextStyle(fontSize: 12),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.arrow_forward),
//                   onPressed: () {
//                     _urlController.text = example.$2;
//                     _extractLocation();
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
