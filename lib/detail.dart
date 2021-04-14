import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piano_tutor/main.dart';
import 'package:piano_tutor/report.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Feedback {
  final double bpm;
  final double speed;
  final double note;
  final double rhythm;
  final double overall;
  final List<dynamic> data;

  Feedback({@required this.bpm, @required this.speed, @required this.note, @required this.rhythm, @required this.overall, @required this.data});

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      bpm: json['bpm'],
      speed: json['speed'],
      note: json['note'],
      rhythm: json['rhythm'],
      overall: json['overall'],
      data: json['data']
    );
  }
}

// The second screen.
class Detail extends StatefulWidget {
  final Song song;

  const Detail({Key key, @required this.song}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _DetailState extends State<Detail> {
  // UI components that may change with different recording states.
  IconData _recordIcon = Icons.play_arrow_rounded;
  String _recordText = 'Click To Start';
  // Recording state.
  RecordingState _recordingState = RecordingState.UnSet;
  // The path to the previous recording. Will be deleted when a new recording is made.
  String _prevRecordingPath = '';
  // Scroll Controller for the ListView that holds the sheet music.
  ScrollController _controller;
  // Whether the "Run Report" button is enabled
  bool showButton = false;
  // The holder for the feedback returned from the server after the user submitted the recording
  Feedback feedback;
  double selected_bpm = 120;

  // Recorder properties
  FlutterAudioRecorder audioRecorder;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  void initState() {
    super.initState();

    // Instantiate the controller for the music sheet.
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    FlutterAudioRecorder.hasPermissions.then((hasPermision) {
      if (hasPermision) {
        _recordingState = RecordingState.Set;
        _recordIcon = Icons.play_arrow_rounded;
        _recordText = 'Click to Start';
      }
    });
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    audioRecorder = null;
    deleteFile(_prevRecordingPath);
    super.dispose();
  }

  // Listening to events for the scroll controller of the music sheet.
  _scrollListener() async {
    double scroll_length = 71.0*100;
    if (_controller.offset == scroll_length){
      //_controller.jumpTo(scroll_length);
      await _stopRecording();
      showButton = true;
    }
  }

  // After 1685ms start the first note. Calculated from the screen size (926pt)
  _moveSheet() {
    double scroll_length = 71.0*100;
    //_controller.position.maxScrollExtent
    int time_for_one_beat = (60000 / selected_bpm).toInt();
    _controller.animateTo(scroll_length,
        curve: Curves.linear, duration: Duration(milliseconds: 71*time_for_one_beat));
  }

  _backtoStart() {
    showButton = false;
    _controller.animateTo(_controller.position.minScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    //final List<String> sheet = <String>['graphics/clef.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/notes/E4.png', 'graphics/notes/E4.png', 'graphics/notes/F4.png', 'graphics/notes/G4.png', 'graphics/notes/G4.png', 'graphics/notes/F4.png', 'graphics/notes/E4.png', 'graphics/notes/D4.png', 'graphics/notes/C4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/E4.png', 'graphics/notes/E4_dotted.png', 'graphics/notes/D4_eighth_half.png', 'graphics/notes/E4.png', 'graphics/notes/E4.png', 'graphics/notes/F4.png', 'graphics/notes/G4.png', 'graphics/notes/G4.png', 'graphics/notes/F4.png', 'graphics/notes/E4.png', 'graphics/notes/D4.png', 'graphics/notes/C4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/E4.png', 'graphics/notes/D4_dotted.png', 'graphics/notes/C4_eighth_half.png'];

    // Full version of Ode to Joy.
    final List<String> sheet = <String>['graphics/clef.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/notes/E4.png', 'graphics/notes/E4.png', 'graphics/notes/F4.png', 'graphics/notes/G4.png', 'graphics/notes/G4.png', 'graphics/notes/F4.png', 'graphics/notes/E4.png', 'graphics/notes/D4.png', 'graphics/notes/C4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/E4.png', 'graphics/notes/E4_dotted.png', 'graphics/notes/D4_eighth_half.png', 'graphics/notes/E4.png', 'graphics/notes/E4.png', 'graphics/notes/F4.png', 'graphics/notes/G4.png', 'graphics/notes/G4.png', 'graphics/notes/F4.png', 'graphics/notes/E4.png', 'graphics/notes/D4.png', 'graphics/notes/C4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/E4.png', 'graphics/notes/D4_dotted.png', 'graphics/notes/C4_eighth_half.png', 'graphics/notes/D4.png', 'graphics/notes/D4.png', 'graphics/notes/E4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/beam_E4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/beam_E4.png', 'graphics/notes/D4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/G3_half.png', 'graphics/empty.png', 'graphics/notes/E4.png', 'graphics/notes/E4.png', 'graphics/notes/F4.png', 'graphics/notes/G4.png', 'graphics/notes/G4.png', 'graphics/notes/F4.png', 'graphics/notes/E4.png', 'graphics/notes/D4.png', 'graphics/notes/C4.png', 'graphics/notes/C4.png', 'graphics/notes/D4.png', 'graphics/notes/E4.png', 'graphics/notes/D4_dotted.png', 'graphics/notes/C4_eighth_half.png', 'graphics/end.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png', 'graphics/empty.png'];

    final sheet_length = sheet.length;

    //print("-------------------screen: ");
    //print(MediaQuery. of(context). size. width);

    return FlutterEasyLoading(
        child: Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: Text(widget.song.name,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            backgroundColor: Color(0xFF26c6da),
            actions: <Widget>[
              /*Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.audiotrack,
                      size: 26.0,
                    ),
                  )
              ),*/
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _showBPMDialog();
                    },
                    child: Icon(
                      Icons.settings,
                    ),
                  )
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: new Stack(
                  children: <Widget> [
                    new Container(
                      //color: Colors.black,
                      margin: const EdgeInsets.only(top: 85.0),
                      child: ListView.builder(
                          controller: _controller,
                          // Remove the safe area before the first item.
                          padding: EdgeInsets.zero,
                          // Disable scrolling by screen touch.
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: sheet_length,
                          itemBuilder: (BuildContext context, int index) {
                            double w = 100;
                            if (sheet[index].contains('eighth_half'))
                              w = 250;
                            else if (sheet[index] == 'graphics/notes/beam_E4.png')
                              w = 200;
                            else if (sheet[index].contains("dotted"))
                              w = 150;
                            else if (sheet[index] == 'graphics/empty_half.png')
                              w = 50;
                            return new Container(
                                width: w,
                                alignment: Alignment.topCenter,
                                child: Image.asset('${sheet[index]}',
                                    fit: BoxFit.fitWidth
                                )
                            );
                          }
                      ),
                    ),
                    new Positioned(
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: new Container (
                                height: 200,
                                margin: const EdgeInsets.only(top: 45.0),
                                child: Image.asset('graphics/bar.png',
                                    fit: BoxFit.fitHeight
                                )
                            )
                        )
                    ),
                  ]
              )
          ),
          floatingActionButton: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    // Add your onPressed code here!
                    _uploadRecording();
                  },
                  label: const Text('Run Report',
                      style: TextStyle(
                          color: Colors.black)),
                  icon: const Icon(Icons.file_upload, color:Colors.black),
                  backgroundColor: Color(0xFFaec4c7),
                ),
                SizedBox(height: 20),
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    // Add your onPressed code here!
                    await _onRecordButtonPressed();
                    setState(() {});
                  },
                  label: Text(_recordText),
                  icon: Icon(_recordIcon),
                  backgroundColor: Color(0xFF102027),
                ),
              ]
          )
      )
    );
  }

  Future<void> _showBPMDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final prevBPM = selected_bpm;
          return AlertDialog(
              title: Text('Change your BPM',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  )
              ),
              content: new Container(
                width: 300,
                height: 60,
                child: new Align(
                  alignment: Alignment.center,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState){
                      return new DropdownButton<double>(
                        value: selected_bpm,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 18,
                        elevation: 16,
                        style: const TextStyle(
                          color: Color(0xFF0095a8),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold
                        ),
                        underline: Container(
                          height: 2,
                          width: 50,
                          color: Color(0xFF26c6da),
                        ),
                        onChanged: (double newValue) {
                          dropDownState(() {
                            selected_bpm = newValue;
                          });
                          print(selected_bpm);
                        },
                        items: <double>[60, 80, 100, 120]
                            .map<DropdownMenuItem<double>>((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text(value.toString()),
                          );
                        }).toList(),
                      );
                    }
                  )
                )
              ),
              actions: <Widget> [
                TextButton(
                    child: const Text('Cancel',
                      style: TextStyle(
                          color: Color(0xFF26c6da),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold
                      )
                    ),
                    onPressed: () {
                      setState(() {
                        selected_bpm = prevBPM;
                      });
                      Navigator.of(context).pop();
                    }
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF26c6da))
                  ),
                  child: Text('OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]
          );
        }
    );
  }

  Widget setupAlertDialogContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 450.0, // Change as per your requirement
      child: ListView(
        primary: false,
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Overall: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
              new RatingBarIndicator(
                rating: feedback.overall * 5,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 25.0,
              ),
            ]
          ),
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularPercentIndicator(
                    radius: 65.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 7.0,
                    percent: feedback.note,
                    center: new Text(
                      ((feedback.note*1000).toInt().toDouble() / 10).toString() + '%',
                      style:
                      new TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Color(0xFFcfd8dc),
                    progressColor: Color(0xFF26c6da),
                  ),
                  const Text('Note Accuracy',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ]
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularPercentIndicator(
                      radius: 65.0,
                      animation: true,
                      animationDuration: 1200,
                      lineWidth: 7.0,
                      percent: feedback.rhythm,
                      center: new Text(
                        ((feedback.rhythm*1000).toInt().toDouble() / 10).toString() + '%',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: Color(0xFFcfd8dc),
                      progressColor: Color(0xFFfff176),
                    ),
                    const Text('Rhythm Accuracy',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ]
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularPercentIndicator(
                      radius: 65.0,
                      animation: true,
                      animationDuration: 1200,
                      lineWidth: 7.0,
                      percent: feedback.speed,
                      center: new Text(
                        ((feedback.speed*1000).toInt().toDouble() / 10).toString() + '%',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: Color(0xFFcfd8dc),
                      progressColor: Color(0xFFf06292),
                    ),
                    const Text('Speed',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                    new Text('(your BPM is ' + feedback.bpm.toString() + ')',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        )),
                  ]
              )
            ]
          ),
        ],
      )
    );
  }

  // Show the dialog box when the result has returned.
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('General Report',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            )),
          content: setupAlertDialogContainer(),
          actions: <Widget>[
            TextButton(
              child: const Text('Back',
                style: TextStyle(color: Color(0xFF26c6da))
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF26c6da))
              ),
              child: Text('Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Report(data: feedback.data),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadRecording() async {
    // Can only upload the recording when the recording is stopped.
    if (showButton) {
      showButton = false;
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      var request = http.MultipartRequest('POST', Uri.http('127.0.0.1:8000', 'music/upload'));
      request.files.add(
          await http.MultipartFile.fromPath(
              'recording',
              _prevRecordingPath
          )
      );
      var screen = MediaQuery.of(context).size.width;
      var start_time = (800 - 0.5 * screen) * 600 / selected_bpm;
      // print("----------------screen: " + start_time.toString());
      request.fields['start_time'] = start_time.toString();
      request.fields['bpm'] = selected_bpm.toString();
      await request.send().then((response) async {
        print("--------------uploaded, the result is: ");
        await EasyLoading.dismiss();
        if (response.statusCode == 200) {
          print("uploaded");
          final respStr = await response.stream.bytesToString();
          feedback = Feedback.fromJson(jsonDecode(respStr));

          print(feedback.rhythm);
          _showDialog();
          showButton = true;
        }
      });
    } else {
      _scaffoldkey.currentState.hideCurrentSnackBar();
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text('You can only run the report when you have finished recording'),
      ));
    }
  }

  // The floating button for recording control is pressed.
  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.play_arrow_rounded;
        _recordText = 'Restart';
        _backtoStart();
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        _scaffoldkey.currentState.hideCurrentSnackBar();
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  // Delete the previous recording as it is no longer needed.
  Future<void> deleteFile(String filePath) async {
    try {
      if (await File(filePath).exists()) {
        await File(filePath).delete();
      }
      return filePath;
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  _initRecorder() async {
    // Delete the previous recording.
    if (_prevRecordingPath.length != 0) {
      deleteFile(_prevRecordingPath);
    }
    // Create the path for the new recording.
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.m4a';
    print("------------------record: file path is " + filePath);
    _prevRecordingPath = filePath;

    // Initialize the recorder for the new recording.
    audioRecorder =
        FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;

  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    await audioRecorder.stop();
  }

  Future<void> _recordVoice() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.replay;
      _recordText = 'Restart';
      _moveSheet();
    } else {
      _scaffoldkey.currentState.hideCurrentSnackBar();
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
  }
}


