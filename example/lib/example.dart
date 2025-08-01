import 'dart:convert';
import 'dart:io';

import 'package:firestore_service_api/firestore_service_api.dart';

const kDocumentId = '111111111';
const kRootPath = 'test/doc2';
const kCollection = 'col2';
const kCollectionPath = '$kRootPath/$kCollection';

/// Example of using the FirestoreService API.
void main() async {
  /// Create a FirestoreService instance.
  final service = FirestoreService();

  /// Initialize the FirestoreService instance.
  await service.init(
    projectId: 'ella500', // <<< your project name, and optional databaseId
  );

  /// Add a document with various field types.
  await _addDoc(service);

  /// Get a document using the FirestoreService repository.
  await _getDoc(service);

  /// Get a document using the low-level Firestore API.
  await _getDocLowLevel(service);

  /// Get documents using the low-level Firestore API.
  await _getDocsLowLevel(service);

  /// Delete a document.
  await service.repo
      .deleteDocument(documentPath: '$kCollectionPath/$kDocumentId');
}

/// Demonstrates getting documents using the low-level Firestore API with orderBy.
Future<void> _getDocsLowLevel(FirestoreService service) async {
  final docs = await service.repo.firestore.listDocuments(
    service.repo.firestorePathUtils.absolutePathFromRelative(kRootPath),
    kCollection,
    orderBy: 'textField DESC',
  );
  stdout.writeln('-----------------');
  stdout.writeln(
    '_getDocsLowLevel: '
    'docs=`${jsonEncode(docs.documents!.map((e) => e.fields).toList())}`',
  );
}

/// Demonstrates getting a document using the low-level Firestore API.
Future<void> _getDocLowLevel(FirestoreService service) async {
  final doc = await service.repo.firestore.get(service.repo.firestorePathUtils
      .absolutePathFromRelative('$kCollectionPath/$kDocumentId'));
  stdout.writeln('-----------------');
  stdout.writeln(
    '_getDocLowLevel: '
    'doc=`${jsonEncode(_convertToJson(doc.fields!))}`',
  );
}

/// Demonstrates adding a document with various field types.
Future<void> _addDoc(FirestoreService service) async {
  final doc = await service.repo.addDocument(
    collectionPath: kCollectionPath,
    id: kDocumentId,
    fields: {
      'textField': Value(stringValue: 'textField1'),
      'boolField': Value(booleanValue: true),
      'integerField': Value(integerValue: '876543234567'),
      'doubleField': Value(doubleValue: 1234.4321),
      'arrayField': Value(
        arrayValue: ArrayValue(
          values: [
            Value(stringValue: 'textField1'),
            Value(booleanValue: true),
            Value(doubleValue: 1234.4321),
          ],
        ),
      ),
      'bytesField': Value(bytesValue: 'AQIDBAU='),
      'geoPointField': Value(
        geoPointValue: LatLng(
          latitude: 56,
          longitude: 45,
        ),
      ),
      'mapField': Value(
        mapValue: MapValue(
          fields: {
            'textField2': Value(stringValue: 'textField2'),
            'boolField2': Value(booleanValue: false),
            'integerField2': Value(integerValue: '786544432'),
            'doubleField2': Value(doubleValue: 76543.234567),
          },
        ),
      ),
      'nullField': Value(nullValue: 'NULL_VALUE'),
      'referenceField': Value(
          referenceValue:
              'projects/ella500/databases/(default)/documents/test/22222'),
      'timeUtcField': Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
    },
  );
  stdout.writeln('-----------------');
  stdout.writeln(
    '_addDoc: '
    'doc=`${jsonEncode(_convertToJson(doc.fields!))}`',
  );
}

/// Demonstrates getting a document using the FirestoreService repository.
Future<void> _getDoc(FirestoreService service) async {
  final doc = await service.repo
      .getDocument(documentPath: '$kCollectionPath/$kDocumentId');
  stdout.writeln('-----------------');
  stdout.writeln(
    '_getDoc: '
    'doc=`${jsonEncode(_convertToJson(doc.fields!))}`',
  );
  // result:
  // {
  //   "geoPointField": {
  //     "latitude": 56.0,
  //     "longitude": 45.0
  //   },
  //   "textField": {
  //     "stringValue": "textField1"
  //   },
  //   "bytesField": {
  //     "bytesValue": "AQIDBAU="
  //   },
  //   "referenceField": {
  //     "referenceValue": "projects/ella500/databases/(default)/documents/test/22222"
  //   },
  //   "integerField": {
  //     "integerValue": "876543234567"
  //   },
  //   "mapField": {
  //     "doubleField2": {
  //       "doubleValue": 76543.234567
  //     },
  //     "textField2": {
  //       "stringValue": "textField2"
  //     },
  //     "boolField2": {
  //       "booleanValue": false
  //     },
  //     "integerField2": {
  //       "integerValue": "786544432"
  //     }
  //   },
  //   "boolField": {
  //     "booleanValue": true
  //   },
  //   "timeUtcField": {
  //     "timestampValue": "2025-07-05T15:03:03.450975Z"
  //   },
  //   "arrayField": [
  //     {
  //       "stringValue": "textField1"
  //     },
  //     {
  //       "booleanValue": true
  //     },
  //     {
  //       "doubleValue": 1234.4321
  //     }
  //   ],
  //   "doubleField": {
  //     "doubleValue": 1234.4321
  //   },
  //   "nullField": {
  //     "nullValue": "NULL_VALUE"
  //   }
  // }
}

/// Converts a Firestore document (Map<String, Value>) to a JSON-compatible map.
/// Just for printing to stdout.
Map<String, dynamic> _convertToJson(Map<String, Value> doc) {
  final json = <String, dynamic>{};

  for (final entry in doc.entries) {
    if (entry.value.geoPointValue != null) {
      json[entry.key] = entry.value.geoPointValue!.toJson();
    } else if (entry.value.arrayValue != null) {
      json[entry.key] =
          entry.value.arrayValue!.values!.map((e) => e.toJson()).toList();
    } else if (entry.value.mapValue != null) {
      json[entry.key] = _convertToJson(entry.value.mapValue!.fields!);
    } else {
      final value = entry.value.toJson();
      json[entry.key] = value;
    }
  }

  return json;
}
