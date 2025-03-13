import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context, String title, String message,
    VoidCallback onConfirm) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 50),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  });
}
