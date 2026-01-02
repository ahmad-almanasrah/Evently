import 'package:evently/providers/friend-provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrJoinScanner extends StatefulWidget {
  const QrJoinScanner({super.key});

  @override
  State<QrJoinScanner> createState() => _QrJoinScannerState();
}

class _QrJoinScannerState extends State<QrJoinScanner> {
  bool _isProcessing = false; // Prevent double-scanning

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan to Join")),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return; // Stop if already loading

          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              setState(() => _isProcessing = true);
              final String code = barcode.rawValue!;

              // 1. Attempt to parse the ID
              try {
                final int eventId = int.parse(code);
                _joinEvent(eventId);
              } catch (e) {
                _showError("Invalid QR Code");
                setState(() => _isProcessing = false);
              }
              break; // Stop after first valid code
            }
          }
        },
      ),
    );
  }

  Future<void> _joinEvent(int eventId) async {
    try {
      // 2. Call your Provider -> Service -> Backend
      await Provider.of<FriendProvider>(
        context,
        listen: false,
      ).joinEventViaQr(eventId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success! You joined the event.")),
        );
        Navigator.pop(context); // Close scanner
      }
    } catch (e) {
      _showError(e.toString());
      if (mounted) {
        setState(() => _isProcessing = false); // Allow scanning again
      }
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }
}
