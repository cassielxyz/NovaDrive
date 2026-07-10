class ContentSanitizer {
  /// Base sanitization: removes scripts, HTML, and neutralizes markdown.
  static String sanitizePlainText(String input) {
    if (input.isEmpty) return '';

    String safe = input;

    // 1. Remove script and style blocks entirely, including content.
    safe = safe.replaceAll(RegExp(r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>', caseSensitive: false, multiLine: true), '');
    safe = safe.replaceAll(RegExp(r'<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>', caseSensitive: false, multiLine: true), '');

    // 2. Remove all HTML tags (e.g. <img ...>, <b>, </a>)
    safe = safe.replaceAll(RegExp(r'<[^>]+>'), '');

    // 3. Remove markdown images: ![alt](url) -> alt or nothing
    safe = safe.replaceAllMapped(RegExp(r'!\[([^\]]*)\]\([^ ]+\)'), (match) {
      return match.group(1) ?? '';
    });

    // 4. Extract text from markdown links: [text](url) -> text
    safe = safe.replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^ ]+\)'), (match) {
      return match.group(1) ?? '';
    });

    // 5. Remove control characters (except basic whitespace \n, \t, \r)
    safe = safe.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');

    // 6. Normalize whitespace
    safe = safe.replaceAll(RegExp(r'\s+'), ' ');

    return safe.trim();
  }

  static String sanitizeGitHubTitle(String input) {
    String safe = sanitizePlainText(input);
    if (safe.length > 120) {
      safe = '${safe.substring(0, 117)}...';
    }
    return safe.isEmpty ? 'Untitled Issue' : safe;
  }

  static String sanitizeGitHubPreview(String input) {
    String safe = sanitizePlainText(input);
    if (safe.length > 280) {
      safe = '${safe.substring(0, 277)}...';
    }
    return safe.isEmpty ? 'No description provided.' : safe;
  }

  static String sanitizeLabel(String input) {
    String safe = sanitizePlainText(input);
    if (safe.length > 40) {
      safe = '${safe.substring(0, 37)}...';
    }
    return safe;
  }

  static String sanitizeUsername(String input) {
    String safe = sanitizePlainText(input);
    // Remove typical username illegal chars just in case
    safe = safe.replaceAll(RegExp(r'[^a-zA-Z0-9\-_]'), '');
    if (safe.length > 40) {
      safe = '${safe.substring(0, 37)}...';
    }
    return safe.isEmpty ? 'Unknown User' : safe;
  }
}
