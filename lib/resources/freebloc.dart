import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:predict_vip/resources/FirebaseProvider.dart';
import 'package:rxdart/rxdart.dart';

class FreeListBloc {
  FirebaseProvider firebaseProvider;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> freeListController; //initial movieController

  BehaviorSubject<bool> showIndicatorController;

  FreeListBloc() {
    freeListController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseProvider = FirebaseProvider();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get freePredictionStream => freeListController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = await firebaseProvider.fetchFreePredictionFirstList();
      print(documentList);
      freeListController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          freeListController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      freeListController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      freeListController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextFreePredictions() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
          await firebaseProvider.fetchFreePredictionNextList(documentList);
      documentList.addAll(newDocumentList);
      freeListController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          freeListController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      freeListController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      freeListController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    freeListController.close();
    showIndicatorController.close();
  }
}
