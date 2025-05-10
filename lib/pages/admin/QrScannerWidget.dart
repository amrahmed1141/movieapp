import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  List qrcodedata;
  QrCodeScanner({super.key, required this.qrcodedata});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController _cameraController = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;
        if (widget.qrcodedata.contains(code)) {
          _cameraController.stop();
          _showDialog(code);
        }
        break;
      }
    }
  }

  void _showDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Matched'),
          content: Text('Code detected: $code'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qr Code Scanner'),
      ),
      body: MobileScanner(onDetect: _onDetect, controller: _cameraController),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
