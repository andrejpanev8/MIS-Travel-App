import 'package:intl/intl.dart';

class Formatter {
  static String getFormattedDate(DateTime date) {
    return DateFormat('dd.MM.yyyy - HH:mm').format(date);
  }
  static String createInvitationEmail(String uniqueCode, DateTime expirationDate) {
    return '''
      <html lang="en">
        <body>
          <div style="font-family: Arial, sans-serif; color: #333;">
            <h2 style="color: #007BFF;">You're Invited to Join Quick Ride as a Driver!</h2>
            <p>Dear Driver,</p>
            <p>We are excited to invite you to join our platform as a driver. To complete your registration, please use the following registration code:</p>
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; font-size: 18px; font-weight: bold; color: #007BFF; text-align: center;">
              <p><strong>Registration Code:</strong> $uniqueCode</p>
            </div>
            <p style="margin-top: 20px;">This code is valid until <strong>${getFormattedDate(expirationDate)}</strong>. Please enter it in the app to finalize your registration.</p>
            <p style="margin-top: 20px;">Best regards,<br>Quick Ride Team</p>
            <hr>
            <footer style="font-size: 12px; color: #6c757d;">
              <p>&copy; 2025 Quick Ride. All rights reserved.</p>
            </footer>
          </div>
        </body>
      </html>
    ''';
  }
}