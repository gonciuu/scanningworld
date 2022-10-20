import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> tryLaunchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

Future<void> sendEmail(
   String toEmail,
   String subject,
   String body,
    ) async {
  String mailUrl =
      _getEmailString(toEmail: toEmail, subject: subject, body: body);
  try {
    await tryLaunchUrl(mailUrl);
  } catch (e) {
    await Clipboard.setData(ClipboardData(text: '$subject \n $body'));
    rethrow;
  }
}

String _getEmailString({
  required String toEmail,
  required String subject,
  required String body,
}) {
  final Uri emailReportUri = Uri(
    scheme: 'mailto',
    path: toEmail,
    query: _encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': body,
    }),
  );

  return emailReportUri.toString();
}

/// Using `queryParameters` above encodes the text incorrectly.
/// We use `query` and this helper function to encode properly.
String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
