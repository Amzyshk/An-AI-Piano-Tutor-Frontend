import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final List<dynamic> data;

  const Report({Key key, @required this.data}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<String> line_1 = <String>['graphics/breaker.png', 'graphics/clef.png', 'E4.png', 'E4.png', 'F4.png', 'G4.png', 'graphics/breaker.png', 'G4.png', 'F4.png', 'E4.png', 'D4.png','graphics/breaker.png', 'C4.png', 'C4.png', 'D4.png', 'E4.png', 'graphics/breaker.png', 'E4_dotted_short.png', 'D4_eighth.png', 'D4_half.png', 'graphics/breaker.png'];
  final List<String> line_2 = <String>['graphics/breaker.png', 'graphics/clef.png', 'E4.png', 'E4.png', 'F4.png', 'G4.png', 'graphics/breaker.png', 'G4.png', 'F4.png', 'E4.png', 'D4.png','graphics/breaker.png', 'C4.png', 'C4.png', 'D4.png', 'E4.png', 'graphics/breaker.png', 'D4_dotted_short.png', 'C4_eighth.png', 'C4_half.png', 'graphics/breaker.png'];
  final List<String> line_3 = <String>['graphics/breaker.png', 'graphics/clef.png', 'D4.png', 'D4.png', 'E4.png', 'C4.png', 'graphics/breaker.png', 'D4.png', 'beam_1_half.png', 'beam_2_half.png', 'E4.png', 'C4.png','graphics/breaker.png', 'D4.png', 'beam_1_half.png', 'beam_2_half.png', 'E4.png', 'D4.png', 'graphics/breaker.png', 'C4.png', 'D4.png', 'G3_half.png', 'graphics/breaker.png'];

  var data_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        backgroundColor: Color(0xFF26c6da),
      ),
      body: new ListView(
        children: <Widget> [
          new Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20.0),
            child: new Text('N - Wrong Note; R - Wrong Rhythm; O - Note omitted; E - Extra notes played',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ))
          ),
          new Container(
            height: 90,
            margin: const EdgeInsets.only(top: 15.0),
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: line_1.length,
                itemBuilder: (BuildContext context, int index) {
                  var target = line_1[index];
                  var path;
                  String text = "";
                  switch (widget.data[data_index]) {
                    case 1:
                      text = "N";
                      break;

                    case 2:
                      text = "O";
                      break;

                    case 3:
                      text = "E";
                      break;

                    case 4:
                      text = "R";
                      break;
                  }
                  double w = 50;
                  if (target.contains('graphics')) {
                    path = target;
                    text = "";
                    if (target.contains('breaker'))
                      w = 1.18;
                  } else if (widget.data[data_index] == 0) {
                    path = 'graphics/notes/' + target;
                    text = '';
                    data_index ++;
                  } else {
                    path = 'graphics/error_notes/' + target;
                    data_index ++;
                  }

                  return new Container(
                      width: w,
                      alignment: Alignment.topCenter,
                      child: new Column(
                        children: <Widget> [
                          Image.asset(path,
                              fit: BoxFit.fitWidth
                          ),
                          new Text(text,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ))
                        ]
                      )
                  );
                }
            ),
          ),
          new Container(
            height: 90,
            margin: const EdgeInsets.only(top: 10.0),
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: line_2.length,
                itemBuilder: (BuildContext context, int index) {
                  var target = line_2[index];
                  var path;
                  String text = "";
                  switch (widget.data[data_index]) {
                    case 1:
                      text = "N";
                      break;

                    case 2:
                      text = "O";
                      break;

                    case 3:
                      text = "E";
                      break;

                    case 4:
                      text = "R";
                      break;
                  }
                  double w = 50;
                  if (target.contains('graphics')) {
                    path = target;
                    text = "";
                    if (target.contains('breaker'))
                      w = 1.18;
                  } else if (widget.data[data_index] == 0) {
                    path = 'graphics/notes/' + target;
                    text = '';
                    data_index ++;
                  } else {
                    path = 'graphics/error_notes/' + target;
                    data_index ++;
                  }

                  return new Container(
                      width: w,
                      alignment: Alignment.topCenter,
                      child: new Column(
                          children: <Widget> [
                            Image.asset(path,
                                fit: BoxFit.fitWidth
                            ),
                            new Text(text,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ))
                          ]
                      )
                  );
                }
            ),
          ),
          new Container(
            height: 90,
            margin: const EdgeInsets.only(top: 10.0),
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: line_3.length,
                itemBuilder: (BuildContext context, int index) {
                  var target = line_3[index];
                  var path;
                  String text = "";
                  switch (widget.data[data_index]) {
                    case 1:
                      text = "N";
                      break;

                    case 2:
                      text = "O";
                      break;

                    case 3:
                      text = "E";
                      break;

                    case 4:
                      text = "R";
                      break;
                  }
                  double w = 50;
                  if (target.contains('beam_1'))
                    w = 5 * w / 6;
                  else if (target.contains('beam_2'))
                    w = 5 * w / 12;
                  if (target.contains('graphics')) {
                    path = target;
                    text = "";
                    if (target.contains('breaker'))
                      w = 1.18;
                  } else if (widget.data[data_index] == 0) {
                    path = 'graphics/notes/' + target;
                    text = '';
                    data_index ++;
                  } else {
                    path = 'graphics/error_notes/' + target;
                    data_index ++;
                  }

                  return new Container(
                      width: w,
                      alignment: Alignment.topCenter,
                      child: new Column(
                          children: <Widget> [
                            Image.asset(path,
                                fit: BoxFit.fitWidth
                            ),
                            new Text(text,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ))
                          ]
                      )
                  );
                }
            ),
          ),
          new Container(
            height: 90,
            margin: const EdgeInsets.only(top: 10.0),
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: line_2.length,
                itemBuilder: (BuildContext context, int index) {
                  var target = line_2[index];
                  var path;
                  String text = "";
                  if (data_index < widget.data.length){
                    switch (widget.data[data_index]) {
                      case 1:
                        text = "N";
                        break;

                      case 2:
                        text = "O";
                        break;

                      case 3:
                        text = "E";
                        break;

                      case 4:
                        text = "R";
                        break;
                    }
                  }

                  double w = 50;
                  if (target.contains('graphics')) {
                    path = target;
                    text = "";
                    if (target.contains('breaker'))
                      w = 1.18;
                  } else if (data_index < widget.data.length && widget.data[data_index] == 0) {
                    path = 'graphics/notes/' + target;
                    text = '';
                    data_index ++;
                  } else {
                    path = 'graphics/error_notes/' + target;
                    data_index ++;
                  }

                  return new Container(
                      width: w,
                      alignment: Alignment.topCenter,
                      child: new Column(
                          children: <Widget> [
                            Image.asset(path,
                                fit: BoxFit.fitWidth
                            ),
                            new Text(text,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ))
                          ]
                      )
                  );
                }
            ),
          ),
        ]
      ),
    );
  }
}