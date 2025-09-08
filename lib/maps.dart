
// import 'dart:collection';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class HomeState extends StatefulWidget {
//   const HomeState({super.key});
//
//   @override
//   State<HomeState> createState() => _HomeStateState();
// }
//
// class _HomeStateState extends State<HomeState> {
//   var mymarkers = HashSet<Marker>();
//   LatLng? selectedLocation;
//
//   @override
//   Widget build(BuildContext context) {
//     final location = ModalRoute.of(context)!.settings.arguments as LatLng?;
//     if (location != null) {
//       selectedLocation = location;
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('location'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: selectedLocation ?? LatLng(30.085571005422036, 31.331259271164864),
//           zoom: 14,
//         ),
//         onMapCreated: (GoogleMapController googleMapController) {
//           setState(() {
//             mymarkers.add(Marker(
//               markerId: MarkerId('1'),
//               position: LatLng(30.085571005422036, 31.331259271164864),
//             ));
//             mymarkers.add(Marker(
//               markerId: MarkerId('2'),
//               position: LatLng(30.04895049389527, 31.374475828835138),
//             ));
//             mymarkers.add(Marker(
//               markerId: MarkerId('3'),
//               position: LatLng(30.085571005422036, 31.331259271164864),
//             ));
//             mymarkers.add(Marker(
//               markerId: MarkerId('4'),
//               position: LatLng(30.054398877176165, 31.492148999999998),
//             ));
//           });
//         },
//         markers: mymarkers,
//       ),
//     );
//   }
// }