import 'dart:async';

import 'package:googleapis/firestore/v1.dart';
import 'package:meta/meta.dart';

import 'firestore_api_provider.dart';
import 'firestore_path_utils.dart';
import 'path_utils.dart';

class FirestoreRepo {
  FirestoreRepo({
    required this.firestoreApiProvider,
    required this.firestorePathUtils,
    required this.pathUtils,
  });

  @protected
  final FirestoreApiProvider firestoreApiProvider;
  @protected
  final FirestorePathUtils firestorePathUtils;
  @protected
  final PathUtils pathUtils;

  ProjectsDatabasesDocumentsResource get firestore =>
      firestoreApiProvider.api.projects.databases.documents;

  /// Initialize FirestoreRepoImpl with the given [projectId] and [databaseId].
  ///
  /// [projectId] is the ID of the Google Cloud Project.
  /// [databaseId] is the ID of the Firestore Database. By default, it's (default).
  ///
  /// It also initializes [documentMapper], [firestoreApiProvider] and [firestorePathUtils].
  Future<void> init({
    required String projectId,
    String databaseId = '(default)',
  }) async {
    await firestoreApiProvider.init();

    firestorePathUtils.init(
      projectId: projectId,
      databaseId: databaseId,
    );
  }

  /// Dispose the FirestoreRepoImpl.
  ///
  /// It disposes the [firestoreApiProvider].
  Future<void> dispose() async => firestoreApiProvider.dispose();

  /// Get all the [Document]s in the collection at [collectionPath]
  Future<List<Document>> getCollection({
    required String collectionPath,
  }) async {
    final collectionParent = pathUtils.parent(collectionPath);
    final collectionName = pathUtils.name(collectionPath);

    return await _getCollectionDocuments(
      documentPath:
          firestorePathUtils.absolutePathFromRelative(collectionParent),
      collectionName: collectionName,
    );
  }

  /// Get all the documents in a collection.
  ///
  /// [documentPath] is the path to the parent document.
  /// [collectionName] is the name of the collection.
  ///
  /// Returns a list of [Document] instances representing the documents in the
  /// collection.
  Future<List<Document>> _getCollectionDocuments({
    required String documentPath,
    required String collectionName,
  }) async {
    final documents = <Document>[];
    String? pageToken;

    while (true) {
      final listDocumentsResponse = await firestore.listDocuments(
        documentPath,
        collectionName,
        pageToken: pageToken,
        showMissing: true,
      );

      final listDocuments = listDocumentsResponse.documents;
      final nextPageToken = listDocumentsResponse.nextPageToken;

      if (listDocuments != null) {
        documents.addAll(listDocuments);
      }

      if (listDocuments == null || nextPageToken == null) {
        break;
      }

      pageToken = listDocumentsResponse.nextPageToken;
    }

    return documents;
  }

  /// Get a document at [documentPath]
  Future<Document> getDocument({required String documentPath}) async {
    final docPath = firestorePathUtils.absolutePathFromRelative(documentPath);

    return await firestore.get(docPath);
  }

  /// Add a document to a collection.
  ///
  /// [collectionPath] is the path to the collection.
  Future<Document> addDocument({
    required String collectionPath,
    required String id,
    required Map<String, Value> fields,
  }) async {
    final documentParent = pathUtils.parent(collectionPath);
    final absoluteParent =
        firestorePathUtils.absolutePathFromRelative(documentParent);
    final documentName = pathUtils.name(collectionPath);

    return await firestore.createDocument(
      Document(fields: fields),
      absoluteParent,
      documentName,
      documentId: id,
    );
  }

  /// Update a document at [documentPath]
  Future<Document> updateDocument({
    required String documentPath,
    required Map<String, Value> fields,
  }) async {
    final absolutePath =
        firestorePathUtils.absolutePathFromRelative(documentPath);

    return await firestore.patch(
      Document(fields: fields),
      absolutePath,
    );
  }

  /// Delete a document and all of it's collections recursively at [documentPath]
  Future<void> deleteDocument({
    required String documentPath,
  }) async {
    final docPath = firestorePathUtils.absolutePathFromRelative(documentPath);

    final collectionNames =
        await _getDocumentCollectionNames(absolutePath: docPath);

    for (final collectionName in collectionNames) {
      final collectionPath = pathUtils.join(docPath, collectionName);

      await deleteCollection(
          collectionPath:
              firestorePathUtils.relativePathFromAbsolute(collectionPath));
    }

    await firestore.delete(docPath);
  }

  /// Get all the collection names of a document.
  ///
  /// [absolutePath] is the absolute path to the document.
  /// [path] is the relative path to the document.
  ///
  /// Only one of [absolutePath] or [path] must be provided.
  /// Returns a list of collection names.
  Future<List<String>> _getDocumentCollectionNames({
    String absolutePath = '',
    String path = '',
  }) async {
    assert(
      absolutePath.isNotEmpty != path.isNotEmpty,
      'Only one parameter of absPath or relPath must be used',
    );

    var docPath = absolutePath;

    if (docPath.isEmpty) {
      docPath = firestorePathUtils.absolutePathFromRelative(path);
    }

    final response =
        await firestore.listCollectionIds(ListCollectionIdsRequest(), docPath);

    return response.collectionIds ?? [];
  }

  /// Delete a collection.
  ///
  /// [absolutePath] is the absolute path to the collection.
  /// [collectionPath] is the relative path to the collection.
  ///
  /// Only one of [absolutePath] or [collectionPath] must be provided.
  Future<void> deleteCollection({
    required String collectionPath,
  }) async {
    final colPath = firestorePathUtils.absolutePathFromRelative(collectionPath);

    final collectionParent = pathUtils.parent(colPath);
    final collectionName = pathUtils.name(colPath);

    final documents = await _getCollectionDocuments(
      documentPath: collectionParent,
      collectionName: collectionName,
    );

    for (final document in documents) {
      if (document.name != null) {
        await deleteDocument(
            documentPath:
                firestorePathUtils.relativePathFromAbsolute(document.name!));
      }
    }
  }
}
