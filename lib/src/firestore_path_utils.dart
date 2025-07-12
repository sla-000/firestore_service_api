/// Helper to handle Firestore paths.
class FirestorePathUtils {
  FirestorePathUtils();

  late String _projectId;
  late String _databaseId;

  /// Initialize the util.
  void init({
    required String projectId,
    String databaseId = '(default)',
  }) {
    _projectId = projectId;
    _databaseId = databaseId;
  }

  /// Prepends `rootPath` to `relativePath` and returns it.
  ///
  /// Example: `users/123` => `projects/test-project/databases/(default)/documents/users/123`
  String absolutePathFromRelative(String relativePath) {
    final path = relativePath.trim();

    if (path.isEmpty || path.startsWith('/')) {
      return '$rootPath'
          '$path';
    } else {
      return '$rootPath'
          '/'
          '$path';
    }
  }

  /// Removes `rootPath` from `absolutePath` and returns it.
  ///
  /// Example: `projects/test-project/databases/(default)/documents/users/123` => `users/123`
  String relativePathFromAbsolute(String absolutePath) {
    final segments = absolutePath.split(
      RegExp('^$rootPath/'),
    );

    if (segments.length < 2) {
      return '';
    }

    return segments[1];
  }

  /// Root path of Firestore documents.
  String get rootPath =>
      'projects/$_projectId/databases/$_databaseId/documents';
}
