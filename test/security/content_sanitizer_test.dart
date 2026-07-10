import 'package:flutter_test/flutter_test.dart';
import 'package:novadrive/core/security/content_sanitizer.dart'; // Ensure correct import if package name is different

void main() {
  group('ContentSanitizer Tests', () {
    test('Removes script tags completely', () {
      final input = "<script>alert('xss')</script>Hello";
      final output = ContentSanitizer.sanitizePlainText(input);
      expect(output, 'Hello');
    });

    test('Removes image tags and javascript handlers', () {
      final input = "<img src=x onerror=alert(1)>Image bug";
      final output = ContentSanitizer.sanitizePlainText(input);
      expect(output, 'Image bug');
    });

    test('Extracts text from markdown link, drops malicious javascript', () {
      final input = "[Click](javascript:alert(1))";
      final output = ContentSanitizer.sanitizePlainText(input);
      expect(output, 'Click');
    });

    test('Extracts text from safe markdown link', () {
      final input = "[Safe](https://github.com/cassielxyz/NovaDrive)";
      final output = ContentSanitizer.sanitizePlainText(input);
      expect(output, 'Safe');
    });

    test('Truncates very long text safely', () {
      final input = List.filled(5000, 'A').join('');
      final output = ContentSanitizer.sanitizeGitHubPreview(input);
      expect(output.length, lessThanOrEqualTo(280));
      expect(output.endsWith('...'), isTrue);
    });

    test('Removes control characters', () {
      // \x00 is null char
      final input = "Safe\x00\x08Text\x1F";
      final output = ContentSanitizer.sanitizePlainText(input);
      expect(output, 'SafeText');
    });

    test('Preserves normal issue text', () {
      final input = "This is a normal issue description.\n\nIt has multiple lines.";
      final output = ContentSanitizer.sanitizePlainText(input);
      expect(output, 'This is a normal issue description. It has multiple lines.');
    });
  });
}
