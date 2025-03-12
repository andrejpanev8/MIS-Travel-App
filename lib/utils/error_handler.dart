import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String title, String message) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50),
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
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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

String getFirebaseErrorTitle(String code) {
  switch (code) {
    case "user-not-found":
      return "User Not Found";
    case "wrong-password":
      return "Incorrect Password";
    case "invalid-email":
      return "Invalid Email Format";
    case "email-already-in-use":
      return "Email Already In Use";
    case "weak-password":
      return "Weak Password";
    case "too-many-requests":
      return "Too Many Attempts";
    default:
      return "Firebase Error";
  }
}
