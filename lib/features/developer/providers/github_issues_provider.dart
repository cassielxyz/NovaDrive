import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/nova_logger.dart';
import '../../../core/security/content_sanitizer.dart';

class GitHubIssuePreview {
  final int id;
  final int number;
  final String safeTitle;
  final String safePreview;
  final String safeAuthor;
  final List<String> safeLabels;
  final String state;
  final int commentCount;
  final DateTime updatedAt;
  final String htmlUrl;
  final bool isPullRequest;

  GitHubIssuePreview({
    required this.id,
    required this.number,
    required this.safeTitle,
    required this.safePreview,
    required this.safeAuthor,
    required this.safeLabels,
    required this.state,
    required this.commentCount,
    required this.updatedAt,
    required this.htmlUrl,
    required this.isPullRequest,
  });

  factory GitHubIssuePreview.fromJson(Map<String, dynamic> json) {
    final labelsRaw = (json['labels'] as List?)?.map((l) => l['name'] as String).toList() ?? [];
    return GitHubIssuePreview(
      id: json['id'] ?? 0,
      number: json['number'] ?? 0,
      safeTitle: ContentSanitizer.sanitizeGitHubTitle(json['title'] ?? ''),
      safePreview: ContentSanitizer.sanitizeGitHubPreview(json['body'] ?? ''),
      safeAuthor: ContentSanitizer.sanitizeUsername(json['user']?['login'] ?? ''),
      safeLabels: labelsRaw.map((l) => ContentSanitizer.sanitizeLabel(l)).toList(),
      state: json['state'] ?? 'open',
      commentCount: json['comments'] ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      htmlUrl: json['html_url'] ?? '',
      isPullRequest: json.containsKey('pull_request'),
    );
  }
}

final githubIssuesProvider = FutureProvider.autoDispose<List<GitHubIssuePreview>>((ref) async {
  const repoUrl = 'https://api.github.com/repos/cassielxyz/NovaDrive/issues?state=all&per_page=15';
  
  try {
    NovaLogger.community('Fetching GitHub issues');
    final response = await http.get(
      Uri.parse(repoUrl),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final allIssues = data.map((json) => GitHubIssuePreview.fromJson(json)).toList();
      // Hide PRs by default as requested
      final filteredIssues = allIssues.where((issue) => !issue.isPullRequest).toList();
      NovaLogger.community('GitHub issues fetched');
      return filteredIssues;
    } else if (response.statusCode == 403 || response.statusCode == 429) {
      NovaLogger.error('NOVA_COMMUNITY', 'GitHub rate limit: ${response.statusCode}');
      throw Exception('Rate limit exceeded');
    } else {
      NovaLogger.error('NOVA_COMMUNITY', 'GitHub issues fetch failed: ${response.statusCode}');
      throw Exception('Failed to load issues');
    }
  } catch (e) {
    NovaLogger.error('NOVA_COMMUNITY', 'GitHub fetch error: $e');
    rethrow; // Rethrow to be caught by AsyncError in UI
  }
});
