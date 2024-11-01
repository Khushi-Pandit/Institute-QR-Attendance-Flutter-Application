import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  final String qrCodeData;

  ImageViewPage({required this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Data'),
      ),
      body: Center(
        child: Text('Scanned QR Code Data: $qrCodeData'),
      ),
    );
  }
}