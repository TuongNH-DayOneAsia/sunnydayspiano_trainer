// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
//
// class ConnectivityManager extends StatefulWidget {
//   final Widget child;
//
//   ConnectivityManager({required this.child});
//
//   @override
//   _ConnectivityManagerState createState() => _ConnectivityManagerState();
// }
//
// class _ConnectivityManagerState extends State<ConnectivityManager> {
//   late StreamSubscription<ConnectivityResult> _subscription;
//   bool _isConnected = true;
//   bool _showRestored = false;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkConnectivity();
//     _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _checkConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     _updateConnectionStatus(connectivityResult);
//   }
//
//   void _updateConnectionStatus(ConnectivityResult result) {
//     setState(() {
//       bool wasConnected = _isConnected;
//       _isConnected = result != ConnectivityResult.none;
//
//       if (wasConnected && !_isConnected) {
//         _showRestored = false;
//         _timer?.cancel();
//       } else if (!wasConnected && _isConnected) {
//         _showRestored = true;
//         _startHideTimer();
//       }
//     });
//   }
//
//   void _startHideTimer() {
//     _timer?.cancel();
//     _timer = Timer(Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           _showRestored = false;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         widget.child,
//         if (!_isConnected)
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: NoInternetWidget(),
//             ),
//           ),
//         if (_isConnected && _showRestored)
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: InternetRestoredWidget(),
//             ),
//           ),
//       ],
//     );
//   }
// }
// class InternetRestoredWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.green,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         'Kết nối mạng đã được khôi phục',
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }
// }
//
// class NoInternetWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         'Không có kết nối mạng',
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }
// }
