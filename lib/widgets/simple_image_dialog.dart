import 'package:flutter/material.dart';

class SimpleImageDialog extends StatelessWidget {
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String backgroundImage;

  const SimpleImageDialog({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width * 0.99, // 80% of screen width
        height: size.width * 0.8, // Same as width to make it square
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
            // Modern responsive button at center bottom
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onButtonPressed();
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension for easy usage
extension SimpleDialogExtension on BuildContext {
  Future<void> showSimpleImageDialog({
    required String buttonText,
    required VoidCallback onButtonPressed,
    required String backgroundImage,
  }) {
    return showGeneralDialog(
      context: this,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SimpleImageDialog(
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
          backgroundImage: backgroundImage,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

// Usage example:
/*
context.showSimpleImageDialog(
  buttonText: 'Go to Screen',
  onButtonPressed: () {
    Navigator.pushNamed(context, '/another-screen');
  },
  backgroundImage: 'https://i.ibb.co/YT4zT23K/wtf.jpg',
);
*/
