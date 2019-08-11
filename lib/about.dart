import 'package:flutter/material.dart';

class About extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Stack(
        children:<Widget>[
          Positioned(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 200),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Jami',
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 20
                      )
                    ),
                    TextSpan(
                      text: ' was made to provide users with live alerts which will allow users to receive important information concerning their safety within their location.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      )
                    )
                  ]
                ),
                softWrap: true,
              ),
            ),
          ),
          Image.asset('ps2pdf.png'),
        ] 
      ),
    );
  }
}