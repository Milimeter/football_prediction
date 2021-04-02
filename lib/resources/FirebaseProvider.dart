import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  // free predictions
  Future<List<DocumentSnapshot>> fetchFreePredictionFirstList() async {
    return (await Firestore.instance
            .collection("freepredictions")
            .orderBy("date")
            .limit(10)
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchFreePredictionNextList(
      List<DocumentSnapshot> documentList) async {
    return (await Firestore.instance
            .collection("freepredictions")
            .orderBy("date")
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .getDocuments())
        .documents;
  }
  // for sponsored predictions
  Future<List<DocumentSnapshot>> fetchSponsoredPredictionFirstList() async {
    return (await Firestore.instance
            .collection("sponsoredpredictions")
            .orderBy("date")
            .limit(10)
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchSponsoredPredictionNextList(
      List<DocumentSnapshot> documentList) async {
    return (await Firestore.instance
            .collection("sponsoredpredictions")
            .orderBy("date")
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .getDocuments())
        .documents;
  }

  // for vip predictions
  Future<List<DocumentSnapshot>> fetchVipPredictionFirstList() async {
    return (await Firestore.instance
            .collection("vippredictions")
            .orderBy("date")
            .limit(10)
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchVipPredictionNextList(
      List<DocumentSnapshot> documentList) async {
    return (await Firestore.instance
            .collection("vippredictions")
            .orderBy("date")
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .getDocuments())
        .documents;
  }
}
