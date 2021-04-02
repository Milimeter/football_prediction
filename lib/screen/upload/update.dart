import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:predict_vip/screen/upload/delete.dart';

class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController _predictionIDTextEditingController =
      TextEditingController();
  TextEditingController _teamAScoreController = TextEditingController();
  TextEditingController _teamBScoreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _gameState = ['Won', 'Pending'];
  String _selectedStatus = 'Pending';

  List<String> _predictionCollectionState = [
    'freepredictions',
    'sponsoredpredictions',
    'vippredictions'
  ];
  String _predictionCollectionStatus = 'freepredictions';

  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  validateAndSubmit() async {
    print("upload process");
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // generate random tag
        Firestore.instance
            .collection(_predictionCollectionStatus)
            .document(_predictionIDTextEditingController.text)
            .updateData({
          "Team-A-Score": _teamAScoreController.text,
          "Team-B-Score": _teamBScoreController.text,
          "GameStatus": _selectedStatus,
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }

      setState(() {
        _isLoading = false;
        _teamAScoreController.text = "";
        _teamBScoreController.text = "";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return Delete();
                    });
              })
        ],
      ),
      body: Stack(children: [
        _showCircularProgress(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "Enter Game Prediction ID",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _predictionIDTextEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Prediction ID cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Prediction ID",
                      hintStyle: TextStyle(color: Colors.blue),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  DropdownButton(
                    hint: Text('Choose Won or Pending'),
                    value: _selectedStatus,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                    items: _gameState.map((status) {
                      return DropdownMenuItem(
                        child: new Text(status),
                        value: status,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  DropdownButton(
                    hint: Text('Please choose free or sponsored'),
                    value: _predictionCollectionStatus,
                    onChanged: (newValue) {
                      setState(() {
                        _predictionCollectionStatus = newValue;
                      });
                    },
                    items: _predictionCollectionState.map((status) {
                      return DropdownMenuItem(
                        child: new Text(status),
                        value: status,
                      );
                    }).toList(),
                  ),
                  Text(
                    "Enter Team A Score",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _teamAScoreController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Team A Score cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Team A Score",
                      hintStyle: TextStyle(color: Colors.blue),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Enter Team B Score",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _teamBScoreController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Team B Score cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Team B Score",
                      hintStyle: TextStyle(color: Colors.blue),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () => validateAndSubmit(),
                      child: Text(
                        'Update Prediction Data',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
