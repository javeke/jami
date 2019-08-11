import 'package:flutter/material.dart';
import 'dart:async';

class DateAndTime extends StatefulWidget{
  @override
  _State createState() => new _State();

}
class _State extends State<DateAndTime>{
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2017),
        lastDate: new DateTime.now()
    );

    if(picked != null && picked != _date){
     print('Date selected: ${_date.toString()}');
      //print('Date Selected: ${_date.year}-${_date.month}-${_date.day}');
      setState((){
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time
    );


    if (picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  new Container(
        padding: new EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading:
                 new RaisedButton(
                   color: Colors.deepOrange,
                   child: new Text('Select Date', style: TextStyle( color: Colors.black54 ),textAlign: TextAlign.left ),
                   onPressed: (){_selectDate(context);},
                 ),
              trailing:
                 new RaisedButton(
                  color : Colors.deepOrange,
                   child: new Text('Select Time', style: TextStyle( color: Colors.black54),textAlign: TextAlign.left),
                   onPressed: (){_selectTime(context);},
                 ),
            ),

            new Text('Date Selected: ${_date.year}-${_date.month}-${_date.day} and Time selected: ${_time.toString()}', style: TextStyle( color: Colors.black54), textAlign: TextAlign.center),
           ],
         )
    );

  }
}
