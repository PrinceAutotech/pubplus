import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase_options.dart';
import 'model/data.dart';
import 'service/save/save.dart';

class AddCampaign extends StatelessWidget {
  const AddCampaign({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MultipleImageSelector(),

    );
  }
}

class MultipleImageSelector extends StatefulWidget {
  const MultipleImageSelector({super.key});

  @override
  State<MultipleImageSelector> createState() => _MultipleImageSelectorState();
}

class _MultipleImageSelectorState extends State<MultipleImageSelector> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  ScreenshotController screenshotController = ScreenshotController();
  final controller = ScreenshotController();
  List<Data> data = [];
  final Save _save = Save();
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Images Select'),
        actions: const [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text('Select Image from Gallery and Camera'),
              onPressed: () {
                getImages();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  log('${data.length}');
                  for (var dataItem in data) {
                    log('$dataItem');
                  }
                  screenshotController
                      .captureFromLongWidget(
                    InheritedTheme.captureAll(
                      context,
                      Material(child: buildImage()),
                    ),
                    delay: const Duration(milliseconds: 1000),
                    context: context,
                  )
                      .then((value) {
                    showCapturedWidget(context, value);
                  });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    textStyle: const TextStyle(color: Colors.white)),
                child: const Text('Download'),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 18.0),
            //   child: ElevatedButton(
            //     onPressed: () async {
            //       var image = await controller.captureFromWidget(buildImage());
            //       await showCapturedWidget(context, image);
            //       //   final directory = (await getTemporaryDirectory()).path;
            //     },
            //     style: ElevatedButton.styleFrom(
            //         elevation: 12.0,
            //         textStyle: const TextStyle(color: Colors.white)),
            //     child: const Text('Downland Button'),
            //   ),
            // ),
            Expanded(
              child: Form(
                key: _formKey,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380.0,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      mainAxisExtent: 490.0),
                  itemBuilder: (BuildContext context, int index) {
                    final Data dataObject = data[index];
                    return SizedBox(
                      height: 3,
                      width: 3,
                      child: Card(
                        child: Container(
                          color: Colors.blue.shade50,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter the Title',
                                  ),
                                  onSaved: (value) {
                                    dataObject.title = value;
                                  },
                                ),
                              ),
                              kIsWeb
                                  ? Image.network(
                                      dataObject.imageFile.path,
                                      height: 250,
                                      width: 250,
                                    )
                                  : Image.file(
                                      dataObject.imageFile,
                                      height: 250,
                                      width: 250,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter the Heading',
                                  ),
                                  onSaved: (value) {
                                    dataObject.heading = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter the Description',
                                  ),
                                  onSaved: (value) {
                                    dataObject.desc = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 600, maxWidth: 600);
    if (pickedFile.isNotEmpty) {
      setState(() {
        for (final xFile in pickedFile) {
          data.add(Data(imageFile: File(xFile.path)));
        }
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Widget buildImage() => Expanded(
    child: Row(
          children: [
            for (final dataObject in data)
              Card(
                child: Container(
                  width: 400,
                  color: Colors.blue.shade50,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            height:5,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: AutoSizeText(
                              "Title :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: AutoSizeText(
                              "${dataObject.title}",
                              maxLines: 3,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height:2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: kIsWeb
                            ? Image.network(
                                dataObject.imageFile.path,
                                height: 360,
                                width: 360,
                              )
                            : Image.file(
                                dataObject.imageFile,
                                height: 360,
                                width: 360,
                              ),
                      ),
                      const SizedBox(
                        height:5,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Heading :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16,)
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: AutoSizeText(
                              "${dataObject.heading}",
                              maxLines: 3,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height:5,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Description :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16,),
                            ),
                          ),
                          SizedBox(
                            width: 300.0,
                            child: AutoSizeText(
                              "${dataObject.desc}",
                              maxLines: 3,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
  );

  Widget buildImage1() => Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380.0,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              mainAxisExtent: 490.0),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Container(
                width: 360,
                color: Colors.blue.shade50,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${data[index].title}",
                          maxLines: 3,
                        )),
                    kIsWeb
                        ? Image.network(
                            data[index].imageFile.path,
                            height: 350,
                            width: 350,
                          )
                        : Image.file(
                            data[index].imageFile,
                            height: 350,
                            width: 350,
                          ),
                    Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          "${data[index].heading}",
                          maxLines: 3,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        "${data[index].desc}",
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _save.saveFile(capturedImage, 'filename.png');
          },
          child: const Icon(Icons.download),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }
}
