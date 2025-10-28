import 'package:flutter/material.dart';

class WavySection extends StatelessWidget {
  final List<Widget> children;
  final Color backgroundColor;
  final double height;
  final EdgeInsetsGeometry? padding;

  const WavySection({
    Key? key,
    required this.children,
    this.backgroundColor = const Color(0xFFF5F3F0), // Light beige/cream
    this.height = 350,
    this.padding = const EdgeInsets.symmetric(vertical: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavyPainter(backgroundColor: backgroundColor),
      size: Size(double.infinity, height),
      child: Container(
        width: double.infinity,
        height: height,
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class WavyPainter extends CustomPainter {
  final Color backgroundColor;

  WavyPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left with wave
    path.moveTo(0, 20);

    // Top wave curve
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 20);
    path.quadraticBezierTo(size.width * 0.75, 40, size.width, 20);

    // Right side
    path.lineTo(size.width, size.height - 20);

    // Bottom wave curve
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 30,
      size.width * 0.5,
      size.height - 20,
    );
    path.quadraticBezierTo(size.width * 0.25, size.height, 0, size.height - 20);

    // Left side back to start
    path.lineTo(0, 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Example usage
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wavy Sections'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20), // Box spacing

            WavySection(
              height: 150,
              children: [
                const Text(
                  'First Section',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Your widgets go here'),
              ],
            ),

            const SizedBox(height: 30), // Box spacing between sections

            WavySection(
              height: 180,
              children: [
                const Text(
                  'Second Section',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button Example'),
                ),
              ],
            ),

            const SizedBox(height: 30), // Box spacing

            WavySection(
              height: 160,
              backgroundColor: const Color(
                0xFFE8E6E3,
              ), // Slightly different shade
              children: [
                const Icon(Icons.star, size: 40, color: Colors.orange),
                const SizedBox(height: 10),
                const Text('Third Section with different color'),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
