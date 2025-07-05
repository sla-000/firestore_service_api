import 'dart:async';

import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirestoreApiProvider {
  FirestoreApiProvider();

  late FirestoreApi api;

  late AuthClient _client;

  Future<void> init() async {
    _client = await clientViaApplicationDefaultCredentials(
      scopes: [
        FirestoreApi.cloudPlatformScope,
        FirestoreApi.datastoreScope,
      ],
    );

    api = FirestoreApi(_client);
  }

  void dispose() => _client.close();
}
