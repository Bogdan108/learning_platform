// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

void downloadFileWeb(Uint8List bytes, String name) {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute('download', name)
    ..click();

  html.Url.revokeObjectUrl(url);
}
