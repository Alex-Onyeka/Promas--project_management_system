import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:promas/classes/commit.dart';
import 'package:promas/main.dart';

class CommitProvider extends ChangeNotifier {
  static final CommitProvider _instance =
      CommitProvider._internal();
  factory CommitProvider() => _instance;
  CommitProvider._internal();

  List<Commit> commits = [
    // Commit(
    //   sha: 'HJJSB',
    //   repo: 'Stockall-CRM',
    //   message: 'message',
    //   authorName: 'authorName',
    //   date: DateTime(2026, 6, 15),
    //   additions: 20,
    //   deletions: 40,
    //   total: 60,
    //   files: [],
    // ),
    // Commit(
    //   sha: 'fddsgr',
    //   repo: 'Stockall-CRM',
    //   message: 'message',
    //   authorName: 'authorName',
    //   date: DateTime(2026, 6, 17),
    //   additions: 20,
    //   deletions: 40,
    //   total: 100,
    //   files: [],
    // ),
    // Commit(
    //   sha: 'fddsgr',
    //   repo: 'Todo-App',
    //   message: 'message',
    //   authorName: 'authorName',
    //   date: DateTime(2026, 6, 17),
    //   additions: 20,
    //   deletions: 40,
    //   total: 100,
    //   files: [],
    // ),
    // Commit(
    //   sha: 'fddsgr',
    //   repo: 'Todo-App',
    //   message: 'message',
    //   authorName: 'authorName',
    //   date: DateTime(2026, 6, 18),
    //   additions: 20,
    //   deletions: 40,
    //   total: 90,
    //   files: [],
    // ),
    Commit(
      sha: 'fddsgr',
      repo: 'Stockall-CRM',
      message: 'message',
      authorName: 'authorName',
      date: DateTime.now(),
      additions: 0,
      deletions: 0,
      total: 0,
      files: [],
    ),
  ];

  void clearCache() {
    commits = [
      Commit(
        sha: 'fddsgr',
        repo: 'Stockall-CRM',
        message: 'message',
        authorName: 'authorName',
        date: DateTime.now(),
        additions: 0,
        deletions: 0,
        total: 0,
        files: [],
      ),
    ];
    // notifyListeners();
  }

  Future<void> fetchCommits({
    required String owner,
    required String repo,
    int perPage = 100,
  }) async {
    final Dio dio = Dio(
      BaseOptions(baseUrl: 'https://api.github.com'),
    );

    // Calculate date range: last 10 days
    final now = DateTime.now().toUtc();
    final since = now
        .subtract(Duration(days: 6))
        .toIso8601String();

    // 1. Fetch commit list (meta only) with date filter
    final res = await dio.get(
      '/repos/$owner/$repo/commits',
      queryParameters: {
        'per_page': perPage,
        'page': 1,
        'since': since,
        // optional: 'until': now.toIso8601String(),
      },
      options: Options(
        headers:
            returnCompany().currentCompany?.token != null
            ? {
                'Authorization':
                    'Bearer ${returnCompany().currentCompany?.token ?? ''}',
              }
            : null,
      ),
    );

    final List tempCommits = res.data;

    // 2. Enrich each commit (stats + files)
    final enriched = await Future.wait(
      tempCommits.map((c) async {
        final sha = c['sha'];

        final detailRes = await dio.get(
          '/repos/$owner/$repo/commits/$sha',
          options: Options(
            headers:
                returnCompany().currentCompany?.token !=
                    null
                ? {
                    'Authorization':
                        'Bearer ${returnCompany().currentCompany?.token ?? ''}',
                  }
                : null,
          ),
        );

        final data = detailRes.data;

        final commit = data['commit'];
        final stats = data['stats'];
        final files = (data['files'] as List?) ?? [];
        print('Commit Message: ${commit['message']}');
        print("Total Work Done: ${stats['total']}");

        return Commit(
          sha: sha,
          repo: repo,

          // metadata
          message: commit['message'] ?? '',
          authorName: commit['author']['name'] ?? '',
          authorUsername: c['author']?['login'],
          date: DateTime.parse(commit['author']['date']),

          // stats
          additions: stats['additions'] ?? 0,
          deletions: stats['deletions'] ?? 0,
          total: stats['total'] ?? 0,

          // files
          files: files.map<CommitFile>((json) {
            return CommitFile(
              filename: json['filename'] ?? '',
              additions: json['additions'] ?? 0,
              deletions: json['deletions'] ?? 0,
              changes: json['changes'] ?? 0,
              status: json['status'],
            );
          }).toList(),
        );
      }),
    );

    commits.addAll(enriched);
    notifyListeners();
  }
}
