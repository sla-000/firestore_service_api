import 'package:firestore_service_api/src/firestore_api_provider.dart';
import 'package:firestore_service_api/src/firestore_path_utils.dart';
import 'package:firestore_service_api/src/path_utils.dart';

import 'firestore_repo.dart';

class FirestoreServiceApi {
  FirestoreServiceApi()
      : repo = FirestoreRepo(
          firestoreApiProvider: FirestoreApiProvider(),
          firestorePathUtils: FirestorePathUtils(),
          pathUtils: PathUtils(),
        );

  final FirestoreRepo repo;

  Future<void> init({
    required String projectId,
    String databaseId = '(default)',
  }) async =>
      repo.init(projectId: projectId, databaseId: databaseId);

  Future<void> dispose() async => repo.dispose();
}
