import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with WidgetsBindingObserver {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _scanned = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      controller.start();
    }
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_scanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final barcode = barcodes.first;
    final value = barcode.rawValue ?? '';
    if (value.isEmpty) return;

    setState(() => _scanned = true);
    controller.stop();

    _showResultDialog(value, barcode.format.name);
  }

  void _showResultDialog(String value, String format) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFE8EAFF), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.qr_code, color: Color(0xFF5B67CA)),
            ),
            const SizedBox(width: 12),
            const Text('QR Scanned!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Format: $format', style: const TextStyle(color: Color(0xFF5B67CA), fontSize: 12)),
            ),
            const SizedBox(height: 12),
            const Text('Scanned Value:', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            SelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            // Show action buttons based on content type
            if (value.startsWith('http://') || value.startsWith('https://'))
              _ActionChip(icon: Icons.open_in_browser, label: 'Open URL')
            else if (value.contains('@'))
              _ActionChip(icon: Icons.email_outlined, label: 'Send Email')
            else if (RegExp(r'^\d{10,13}$').hasMatch(value))
              _ActionChip(icon: Icons.menu_book, label: 'Search Book by ISBN')
            else
              _ActionChip(icon: Icons.copy, label: 'Copy to Clipboard'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _scanned = false);
              controller.start();
            },
            child: const Text('Scan Again', style: TextStyle(color: Color(0xFF5B67CA))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B67CA),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
            onPressed: () {
              controller.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: controller,
            onDetect: _handleDetection,
          ),

          // Overlay with scanning frame
          CustomPaint(
            painter: _ScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),

          // Bottom instruction
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Point camera at any QR code or barcode',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supports QR codes, barcodes, ISBN codes',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  // Manual entry button
                  OutlinedButton.icon(
                    onPressed: () => _showManualEntryDialog(),
                    icon: const Icon(Icons.keyboard, color: Colors.white, size: 18),
                    label: const Text('Enter Code Manually', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_scanned)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF5B67CA)),
              ),
            ),
        ],
      ),
    );
  }

  void _showManualEntryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enter Code Manually'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter QR value, ISBN, or URL...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                Navigator.pop(context);
                _showResultDialog(value, 'Manual');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B67CA), foregroundColor: Colors.white),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF5B67CA), size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFF5B67CA), fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);
    final double frameSize = size.width * 0.65;
    final double left = (size.width - frameSize) / 2;
    final double top = (size.height - frameSize) / 2 - 40;
    final frameRect = Rect.fromLTWH(left, top, frameSize, frameSize);

    // Draw dark overlay with cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Draw frame corners
    final cornerPaint = Paint()
      ..color = const Color(0xFF5B67CA)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 24.0;
    const r = 16.0;

    // Top-left
    canvas.drawLine(Offset(left + r, top), Offset(left + r + cornerLen, top), cornerPaint);
    canvas.drawLine(Offset(left, top + r), Offset(left, top + r + cornerLen), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(left, top, r * 2, r * 2), -3.14, 3.14 / 2, false, cornerPaint);

    // Top-right
    final right = left + frameSize;
    canvas.drawLine(Offset(right - r - cornerLen, top), Offset(right - r, top), cornerPaint);
    canvas.drawLine(Offset(right, top + r), Offset(right, top + r + cornerLen), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(right - r * 2, top, r * 2, r * 2), -3.14 / 2, 3.14 / 2, false, cornerPaint);

    // Bottom-left
    final bottom = top + frameSize;
    canvas.drawLine(Offset(left + r, bottom), Offset(left + r + cornerLen, bottom), cornerPaint);
    canvas.drawLine(Offset(left, bottom - r - cornerLen), Offset(left, bottom - r), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(left, bottom - r * 2, r * 2, r * 2), 3.14 / 2, 3.14 / 2, false, cornerPaint);

    // Bottom-right
    canvas.drawLine(Offset(right - r - cornerLen, bottom), Offset(right - r, bottom), cornerPaint);
    canvas.drawLine(Offset(right, bottom - r - cornerLen), Offset(right, bottom - r), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(right - r * 2, bottom - r * 2, r * 2, r * 2), 0, 3.14 / 2, false, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
