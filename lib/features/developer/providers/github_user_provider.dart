import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/nova_logger.dart';

final githubUsernameProvider = NotifierProvider<GitHubUsernameNotifier, String?>(() {
  return GitHubUsernameNotifier();
});

class GitHubUsernameNotifier extends Notifier<String?> {
  @override
  String? build() {
    _loadUsername();
    return null;
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('nova_github_username');
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nova_github_username', username);
    state = username;
  }

  Future<void> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nova_github_username');
    state = null;
  }
}

class GitHubContribution {
  final int mergedPrs;
  
  GitHubContribution({required this.mergedPrs});
}

final githubContributionProvider = FutureProvider.autoDispose<GitHubContribution?>((ref) async {
  final username = ref.watch(githubUsernameProvider);
  if (username == null || username.isEmpty) {
    return null;
  }

  final url = 'https://api.github.com/search/issues?q=repo:cassielxyz/NovaDrive+author:$username+type:pr+is:merged';
  
  try {
    NovaLogger.community('Fetching GitHub contributions for $username');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final count = data['total_count'] ?? 0;
      NovaLogger.community('GitHub contributions fetched for $username: $count');
      return GitHubContribution(mergedPrs: count);
    } else {
      NovaLogger.error('NOVA_COMMUNITY', 'Failed to load contributions: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    NovaLogger.error('NOVA_COMMUNITY', 'GitHub fetch error: $e');
    return null;
  }
});
