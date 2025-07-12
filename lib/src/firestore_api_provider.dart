import 'dart:async';

import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

/// Wrapper around [FirestoreApi]
class FirestoreApiProvider {
  FirestoreApiProvider();

  /// The firestore api, this is exposed and can be used directly
  late FirestoreApi api;

  late AuthClient _client;

  /// Initialises the firestore api, this must be called before accessing [api]
  ///
  /// This will attempt to authenticate using application default credentials
  /// see https://cloud.google.com/docs/authentication/production
  Future<void> init() async {
    _client = await clientViaApplicationDefaultCredentials(
      scopes: [
        FirestoreApi.cloudPlatformScope,
        FirestoreApi.datastoreScope,
      ],
    );

    api = FirestoreApi(_client);
  }

  /// Closes the client and cleans up any resources associated with it
  void dispose() => _client.close();
}
