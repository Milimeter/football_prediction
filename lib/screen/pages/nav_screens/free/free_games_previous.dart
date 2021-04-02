import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:predict_vip/resources/freebloc.dart';

const String testDevice = '';

class FreeGamesScreenPrevious extends StatefulWidget {
  @override
  _FreeGamesScreenPreviousState createState() =>
      _FreeGamesScreenPreviousState();
}

class _FreeGamesScreenPreviousState extends State<FreeGamesScreenPrevious> {
  

  FreeListBloc freeListBloc;
  ScrollController controller = ScrollController();
  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      freeListBloc.fetchNextFreePredictions();
    }
  }

  @override
  void initState() {
    super.initState();
    freeListBloc = FreeListBloc();
    freeListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
    
    super.initState();
  }

 

  /// Defaults to previous date.
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    var previousDate = "${selectedDate.toLocal()}".split(' ')[0];
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
          child: Container(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: freeListBloc.freePredictionStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    controller: controller,
                    itemBuilder: (context, index) {
                      if (previousDate ==
                          snapshot.data[index]["GameDate"]) {
                        print(previousDate +
                            "    ==============>    " +
                            snapshot.data[index]["GameDate"]);
                        return dynamicList(
                          teamA: snapshot.data[index]["Team-A"],
                          teamB: snapshot.data[index]["Team-B"],
                          gameDate: snapshot.data[index]["GameDate"],
                          gameTime: snapshot.data[index]["GameTime"],
                          prediction: snapshot.data[index]["Prediction"],
                          leagueName: snapshot.data[index]["LeagueName"],
                          gameStatus: snapshot.data[index]["GameStatus"],
                          teamAScore: snapshot.data[index]
                              ["Team-A-Score"],
                          teamBScore: snapshot.data[index]
                              ["Team-B-Score"],
                          predictionID: snapshot.data[index]
                              ["PredictionId"],
                          gameODD: snapshot.data[index]["GameODD"],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }

  Widget dynamicList({
    @required String teamA,
    @required String teamB,
    @required String gameDate,
    @required String gameTime,
    @required String prediction,
    @required String leagueName,
    @required String gameStatus,
    @required String teamAScore,
    @required String teamBScore,
    @required String predictionID,
    @required String gameODD,
  }) {
    // just be adding the arguments in the fields that requires it
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0, left: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    gameTime, // Time
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    leagueName, // League Name
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        teamA, // League Name
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'vs', // League Name
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        teamB, // League Name
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    prediction, // League Name
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Column(children: <Widget>[
            Text(
              predictionID == null ? "null" : predictionID, //add field
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0),
            Container(
                width: 70.0,
                height: 20.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0)),
                alignment: Alignment.center,
                child: Text(
                  gameStatus,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 15.0),
            Text(
              gameODD == null ? "null" : gameODD,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15.0,
              ),
            ),
            Container(
                height: 20.0,
                child: Row(
                  children: [
                    Text(
                      teamAScore,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      '-',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      teamBScore,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ))
          ])
        ],
      ),
    );
  }
}
