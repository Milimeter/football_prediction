import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:predict_vip/screen/upload/update.dart';

class UploadPredictions extends StatefulWidget {
  @override
  _UploadPredictionsState createState() => _UploadPredictionsState();
}

class _UploadPredictionsState extends State<UploadPredictions> {
  TextEditingController _firstTeamTextEditingController =
      TextEditingController();
  TextEditingController _secondTeamTextEditingController =
      TextEditingController();
  TextEditingController _predictionTextEditingController =
      TextEditingController();
  TextEditingController _leagueNameTextEditingController =
      TextEditingController();
  TextEditingController _gameOddTextEditingController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  List<String> _gameState = ['Won', 'Pending'];
  String _selectedStatus = 'Pending';
  List<String> _predictionCollectionState = [
    'freepredictions',
    'sponsoredpredictions',
    'vippredictions'
  ];
  String _predictionCollectionStatus = 'freepredictions';
  DateTime dateToUpload;
  String predictionId;

  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();
  TimeOfDay _time;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // This will change to light theme.
          child: child,
        );
      },
    );
    /*This method actually calls showDatePicker function and waits for the date selected by the admin. 
    If the admin does not select anything then the date return will be null otherwise the selected date.*/
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        //dateToUpload = "${selectedDate.toLocal()}".split(' ')[0];
        dateToUpload = selectedDate;
      });
    print(dateToUpload);
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // This will change to light theme.
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: child,
            ),
          ),
        );
      },
    );
    if (time != null) {
      setState(() {
        _time = time;
      });
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  // Check if form is valid before uploading
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
      print(dateToUpload == null ? "date null" : dateToUpload);
      print("${_time.hour}:${_time.minute}:${_time.hourOfPeriod}" == null
          ? "null"
          : "${_time.hour}:${_time.minute}:${_time.hourOfPeriod}");
      print("id " + predictionId);

      try {
        // generate random tag
        Firestore.instance
            .collection(_predictionCollectionStatus)
            .document(predictionId)
            .setData({
          "Team-A": _firstTeamTextEditingController.text,
          "Team-B": _secondTeamTextEditingController.text,
          "GameDate": "${selectedDate.toLocal()}".split(' ')[0],
          "GameTime": "${_time.hour}:${_time.minute}",
          "GameODD": _gameOddTextEditingController.text,
          "Prediction": _predictionTextEditingController.text,
          "LeagueName": _leagueNameTextEditingController.text,
          "GameStatus": _selectedStatus,
          "Team-A-Score": "0",
          "Team-B-Score": "0",
          "date": DateTime.now().toString(),
          "PredictionId": predictionId, // generate random tag
        });
        print("upload done");
      } catch (e) {
        print('Error: $e');
        
      }
      setState(() {
          _isLoading = false;
          _firstTeamTextEditingController.text = "";
          _secondTeamTextEditingController.text = "";
          _predictionTextEditingController.text = "";
          _leagueNameTextEditingController.text = "";
          _gameOddTextEditingController.text = "";
           print('New ID');
          predictionId = generateRandomString(8);
          
        });
    }
   // print(predictionId);
    
    
    
  }

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
    predictionId = generateRandomString(8);
    dateToUpload = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    print(predictionId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Admin',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Update()),
                  ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
           _showCircularProgress(),
            Container(
              margin: EdgeInsets.only(top: 40),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
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
                    // Team A input Field
                    Text(
                      "Enter League Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _leagueNameTextEditingController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "League name Cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "League Name",
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
                    // Team A input Field
                    Text(
                      "Enter first Team Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _firstTeamTextEditingController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Team name Cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Team A",
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

                    // Team B input field
                    Text(
                      "Enter Second Team Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _secondTeamTextEditingController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Team name cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Team B",
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
                    //current Game Date
                    RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        'Select Game date',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.blueGrey),
                      child: Center(
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Game Time
                    RaisedButton(
                      onPressed: () => _selectTime(context),
                      child: Text(
                        'Select Game time',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.blueGrey),
                      child: Center(
                        child: Text(
                          "Time : ${_time.hour}:${_time.minute}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // prediction

                    Text(
                      "Enter Game Prediction",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _predictionTextEditingController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Prediction cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Game Prediction",
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

                    // game odd
                    Text(
                      "Enter Game ODD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _gameOddTextEditingController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Game ODD cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Game ODD",
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

                    //DropDown Button
                    DropdownButton(
                      hint: Text('Please choose Game Status'),
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

                    // match result is 0-0 initially

                    Container(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () => validateAndSubmit(),
                        child: Text(
                          'Upload Prediction Data',
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
             
          ],
        ),
      ),
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
