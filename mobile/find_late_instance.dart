import 'dart:io';

void main() {
  final dir = Directory(r'C:\Users\graci\AppData\Local\Pub\Cache\hosted\pub.dev');
  final regex = RegExp(r'late\s+[a-zA-Z0-9_<>]+(?:\?)?\s+_instance');
  for (var file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      try {
        final content = file.readAsStringSync();
        if (regex.hasMatch(content)) {
          print(file.path);
        }
      } catch (_) {}
    }
  }
}
