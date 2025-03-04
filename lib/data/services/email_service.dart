import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../service/invitation_service.dart';
import '../../utils/formatter.dart';
import '../../utils/functions.dart';

class EmailService {
  final InvitationService _invitationService = InvitationService();
  final String senderEmail = dotenv.env['SMTP_EMAIL'] ?? '';
  final String senderPassword = dotenv.env['SMTP_PASSWORD'] ?? '';

  Future<bool> sendEmail(String recipientEmail) async {
    final smtpServer = gmail(senderEmail, senderPassword);
    String uniqueCode = Functions.generateUniqueCode();
    DateTime expirationDate = DateTime.now().add(const Duration(days: 1));
    String emailContent =
        Formatter.createInvitationEmail(uniqueCode, expirationDate);

    final message = Message()
      ..from = Address(senderEmail, 'Quick Ride Team')
      ..recipients.add(recipientEmail)
      ..subject = 'Invitation to Register as a Driver'
      ..html = emailContent;

    try {
      await send(message, smtpServer);
      _invitationService.createInvitationWithCodeAndDate(
          email: recipientEmail,
          uniqueCode: uniqueCode,
          expirationDate: expirationDate);
      return true;
    } catch (e) {
      return false;
    }
  }
}
