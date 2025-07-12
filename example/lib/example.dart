import 'dart:convert';
import 'dart:io';

import 'package:firestore_service_api/firestore_service_api.dart';

void main() async {
  final service = FirestoreService();
  await service.init(projectId: 'ella500'); // <<< your project name

  await _addDoc(service);

  await _getDoc(service);
  await _getDocLowLevel(service);

  await service.repo.deleteDocument(documentPath: 'test/111111111');
}

Future<void> _getDocLowLevel(FirestoreService service) async {
  final doc = await service.repo.firestore.get(service.repo.firestorePathUtils
      .absolutePathFromRelative('test/111111111'));
  stdout.writeln('doc2=${jsonEncode(_convertToJson(doc.fields!))}');
}

Future<void> _addDoc(FirestoreService service) async {
  await service.repo.addDocument(
    collectionPath: 'test',
    id: '111111111',
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
}

Future<void> _getDoc(FirestoreService service) async {
  final doc = await service.repo.getDocument(documentPath: 'test/111111111');
  stdout.writeln('doc=${jsonEncode(_convertToJson(doc.fields!))}');
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
