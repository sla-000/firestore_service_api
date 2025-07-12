import 'package:firestore_service_api/src/firestore_api_provider.dart';
import 'package:firestore_service_api/src/firestore_path_utils.dart';
import 'package:firestore_service_api/src/path_utils.dart';

import 'firestore_repo.dart';

/// A service class for interacting with Firestore.
///
/// This class provides methods to initialize and dispose of the Firestore connection.
class FirestoreService {
  /// Creates a new instance of [FirestoreService].
  FirestoreService()
      : repo = FirestoreRepo(
          firestoreApiProvider: FirestoreApiProvider(),
          firestorePathUtils: FirestorePathUtils(),
          pathUtils: PathUtils(),
        );

  final FirestoreRepo repo;

  /// Initializes the Firestore service.
  ///
  /// This method must be called before any other methods of this class.
  ///
  /// [projectId] is the ID of the Firebase project.
  /// [databaseId] is the ID of the Firestore database. Defaults to '(default)'.
  Future<void> init({
    required String projectId,
    String databaseId = '(default)',
  }) async =>
      repo.init(projectId: projectId, databaseId: databaseId);

  /// Disposes of the Firestore service.
  ///
  /// This method should be called when the service is no longer needed to release
  /// any resources it may be holding.
  Future<void> dispose() async => repo.dispose();
}
