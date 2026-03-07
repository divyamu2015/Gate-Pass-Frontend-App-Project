// filepath: lib/screens/qr_generation_screen.dart
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrGenerationScreen extends StatelessWidget {
//  final String data;

  const QrGenerationScreen({super.key,
  // required this.data
   });
  final String data = "Sample QR Data"; // Replace with actual data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Generation')),
      body: Center(
        child: PrettyQrView.data(
          data: data,
          //  size: 250,
          errorCorrectLevel: QrErrorCorrectLevel.M,
          // roundEdges: true,
        ),
      ),
    );
  }
}
