class Commit {
  final String sha;
  final String repo;

  // metadata
  final String message;
  final String authorName;
  final String? authorEmail;
  final DateTime date;

  // stats
  final int additions;
  final int deletions;
  final int total;

  // file-level info
  final List<CommitFile> files;

  Commit({
    required this.sha,
    required this.repo,
    required this.message,
    required this.authorName,
    required this.authorEmail,
    required this.date,
    required this.additions,
    required this.deletions,
    required this.total,
    required this.files,
    // this.authorUsername,
  });

  // List<CommitFile> getFiles() {
  //   files.sort((a, b) => a.filename.compareTo(b.filename));
  //   return files;
  // }
}

class CommitFile {
  final String filename;
  final int additions;
  final int deletions;
  final int changes;
  final String? status;

  CommitFile({
    required this.filename,
    required this.additions,
    required this.deletions,
    required this.changes,
    this.status,
  });
}
