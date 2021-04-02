import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Delete extends StatefulWidget {
  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  TextEditingController _deleteController = TextEditingController();
  List<String> _deleteState = [
    'freepredictions',
    'sponsoredpredictions',
    'vippredictions',
  ];
  String _deleteStatus = 'freepredictions';
  @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Delete Prediction",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
            hint: Text('Delete From'),
            value: _deleteStatus,
            onChanged: (newValue) {
              setState(() {
                _deleteStatus = newValue;
              });
            },
            items: _deleteState.map((status) {
              return DropdownMenuItem(
                child: new Text(status),
                value: status,
              );
            }).toList(),
          ),
          TextFormField(
            controller: _deleteController,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                  onPressed: () {
                    try {
                      if (_deleteController.text.isNotEmpty) {
                        Firestore.instance
                            .collection(_deleteStatus)
                            .document(_deleteController.text)
                            .delete();
                      }
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                  child:
                      Text("Delete Data", style: TextStyle(color: Colors.red))),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.blue)))
            ],
          )
        ],
      ),
    );
  }
}
