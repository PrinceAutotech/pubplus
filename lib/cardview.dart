import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _addCard = 0;
  final GlobalKey _globalKey = GlobalKey();
  void _incrementCard() {
    setState(() {
      _addCard++;
    });
  }
  var randomItemCount = Random().nextInt(100);
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Bar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          screenshotController
              .captureFromLongWidget(
            InheritedTheme.captureAll(
              context,
              Material(
                child:  RepaintBoundary(
                  key: _globalKey,
                  child: myLongWidget
                ),
              ),
            ),
            delay: const Duration(milliseconds: 100),
            context: context,
             constraints: const BoxConstraints(
               maxHeight: 1000,
               maxWidth: 1000,
             )
          )
              .then((capturedImage) {
            ShowCapturedWidget(context,capturedImage);
            _saveLocalImage();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: _addCard,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                color: Colors.blue,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/image/adduser.png",
                        color: Colors.white54,
                        height: 200,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  var myLongWidget = Builder(builder: (context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          border:
          Border.all(color: Colors.blueAccent, width: 5.0),
          color: Colors.redAccent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 50; i++)
              Text("Tile Index $i"),
          ],
        ));
  });


  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }

  _saveLocalImage() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
    await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print("hello $result");
    }
  }

}
