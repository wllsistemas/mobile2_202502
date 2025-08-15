import 'package:flutter/material.dart';

class Loading {
  static OverlayEntry? _modalOverlay;

  static void show(BuildContext context, {required String mensagem}) {
    if (_modalOverlay != null) return;

    _modalOverlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    mensagem,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_modalOverlay!);
  }

  static void hide() {
    _modalOverlay?.remove();
    _modalOverlay = null;
  }
}
