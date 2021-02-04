import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase wrraper, can be use for firebase crud
class Api {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference ref;
  final String path;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection(data) {
    return ref.where('date', isEqualTo: data).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).update(data);
  }
}
