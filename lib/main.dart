// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:orientation/orientation.dart';
import 'package:flutter/services.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OrientationPlugin.forceOrientation(DeviceOrientation.landscapeLeft);
  runApp(MaterialApp(home: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['Ode an die Freude'];
    final List<String> imgs = <String>['graphics/beethoven.jpg'];

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Choose your music',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
              )),
          backgroundColor: Color(0xFF26c6da),
        ),
        body: Center(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((20.0))
                ),
                width: 220,
                margin: EdgeInsets.all(20.0),
                alignment: Alignment.bottomCenter,
                child: (Column(
                  children: <Widget>[
                    Expanded (
                      flex: 1,
                      child: Image.asset('${imgs[index]}',
                        fit: BoxFit.fitHeight
                         )
                    ),
                    Container(
                      color: Color(0xFF102027),
                      height: 80,
                      width: 220,
                      alignment: Alignment.center,
                      child: (
                          Text(
                              '${entries[index]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFffffff),
                              )
                          )
                      )
                    )
                  ],
                )),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
        ),
      ),
    );
  }
}

