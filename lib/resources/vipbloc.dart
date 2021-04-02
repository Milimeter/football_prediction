import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:predict_vip/resources/FirebaseProvider.dart';
import 'package:rxdart/rxdart.dart';
  // please don't touch any core function here
class VipListBloc {
  FirebaseProvider firebaseProvider;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> vipListController; //initial movieController

  BehaviorSubject<bool> showIndicatorController;

  VipListBloc() {
    vipListController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseProvider = FirebaseProvider();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get vipPredictionStream => vipListController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = await firebaseProvider.fetchVipPredictionFirstList();
      print(documentList);
      vipListController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          vipListController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      vipListController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      vipListController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextVipPrediction() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
          await firebaseProvider.fetchVipPredictionNextList(documentList);
      documentList.addAll(newDocumentList);
      vipListController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          vipListController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      vipListController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      vipListController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    vipListController.close();
    showIndicatorController.close();
  }
}
