library default_connector;

import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultConnector {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final DefaultConnector _instance = DefaultConnector._internal();

  factory DefaultConnector() {
    return _instance;
  }

  DefaultConnector._internal();

  Future<void> saveData(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }
}
