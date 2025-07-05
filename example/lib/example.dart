import 'package:firestore_service_api/firestore_service_api.dart';

void main() async {
  final api = FirestoreServiceApi();

  await api.init(projectId: 'ella500'); // <<< your project name

  await _addDoc(api);
}

Future<void> _addDoc(FirestoreServiceApi api) async {
  await api.repo.addDocument(
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
