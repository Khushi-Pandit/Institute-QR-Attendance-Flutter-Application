import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:softwareproject/ImageViewPage.dart';
import 'package:softwareproject/UI/Status/StatusScreen.dart';
import 'package:softwareproject/Utils/helper/helper_functions.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key, required this.studentId});
  final String studentId;

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        elevation: 8,
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_left, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              "Scan QR Code",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.deepPurpleAccent,
                    borderRadius: 16,
                    borderLength: 32,
                    borderWidth: 8,
                    cutOutSize: 280,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Align the QR code within the frame to scan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Flash Toggle Button
                FloatingActionButton.extended(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      isFlashOn = !isFlashOn;
                    });
                  },
                  label: Text(
                    isFlashOn ? 'Flash Off' : 'Flash On',
                    style: const TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    isFlashOn ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(!isScanned){
        setState(() {
          isScanned = true;
        });
        controller.pauseCamera();
        setState(() {});
        HelperFunctions.navigateToScreen(context, StatusScreen(
          qrData: getQRData(scanData.code!), studentId: widget.studentId,)
        );
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Map<String, dynamic> getQRData(String data) {
    final Map<String, dynamic> qrDataMap = {};

    final regex = RegExp(r"(\w+)='([^']*)'");
    final matches = regex.allMatches(data);

    for (final match in matches) {
      qrDataMap[match.group(1)!] = match.group(2)!;  // Group 1 is key, Group 2 is value
    }

    return qrDataMap;
  }

}

