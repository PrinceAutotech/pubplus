import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import '../../model/campaign.dart';
import '../../service/save/save.dart';

class AddCampaignPage extends StatefulWidget {
  const AddCampaignPage({super.key});

  @override
  State<AddCampaignPage> createState() => _AddCampaignPageState();
}

class _AddCampaignPageState extends State<AddCampaignPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ScreenshotController _screenshotController = ScreenshotController();
  final List<Campaign> _campaigns = [];
  final Save _save = Save();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Multiple Images Select'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: getImages,
                child: const Text('Select Image from Gallery and Camera'),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _campaigns.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380.0,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      mainAxisExtent: 490.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final Campaign campaign = _campaigns[index];
                      return SizedBox(
                        height: 3,
                        width: 3,
                        child: Card(
                          child: ColoredBox(
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
                                      campaign.title = value;
                                    },
                                  ),
                                ),
                                if (kIsWeb)
                                  Image.network(
                                    campaign.imageFile.path,
                                    height: 250,
                                    width: 250,
                                  )
                                else
                                  Image.file(
                                    campaign.imageFile,
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
                                      campaign.heading = value;
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
                                      campaign.desc = value;
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
              if (_campaigns.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _formKey.currentState?.save();
                      var value =
                          await _screenshotController.captureFromLongWidget(
                        InheritedTheme.captureAll(
                          context,
                          Material(child: buildImage()),
                        ),
                        delay: const Duration(milliseconds: 1000),
                        context: context,
                      );
                      if (!mounted) return;
                      unawaited(showCapturedWidget(context, value));
                    },
                    child: const Text('Download'),
                  ),
                ),
            ],
          ),
        ),
      );

  Future getImages() async {
    final pickedFile = await _picker.pickMultiImage(
        imageQuality: 100, maxHeight: 600, maxWidth: 600);
    if (pickedFile.isNotEmpty) {
      setState(() {
        for (final xFile in pickedFile) {
          _campaigns.add(Campaign(imageFile: File(xFile.path)));
        }
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Widget buildImage() => Row(
        children: [
          for (final campaign in _campaigns)
            Card(
              child: Container(
                width: 400,
                color: Colors.blue.shade50,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: AutoSizeText(
                            'Title :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: AutoSizeText(
                            '${campaign.title}',
                            maxLines: 3,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: kIsWeb
                          ? Image.network(
                              campaign.imageFile.path,
                              height: 360,
                              width: 360,
                            )
                          : Image.file(
                              campaign.imageFile,
                              height: 360,
                              width: 360,
                            ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            'Heading :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: AutoSizeText(
                            '${campaign.heading}',
                            maxLines: 3,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            'Description :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300.0,
                          child: AutoSizeText(
                            '${campaign.desc}',
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
      );

  Widget buildImage1() => GridView.builder(
        shrinkWrap: true,
        itemCount: _campaigns.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 380.0,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          mainAxisExtent: 490.0,
        ),
        itemBuilder: (BuildContext context, int index) => Card(
          child: Container(
            width: 360,
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${_campaigns[index].title}',
                    maxLines: 3,
                  ),
                ),
                if (kIsWeb)
                  Image.network(
                    _campaigns[index].imageFile.path,
                    height: 350,
                    width: 350,
                  )
                else
                  Image.file(
                    _campaigns[index].imageFile,
                    height: 350,
                    width: 350,
                  ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    '${_campaigns[index].heading}',
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    '${_campaigns[index].desc}',
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<dynamic> showCapturedWidget(
          BuildContext context, Uint8List capturedImage) =>
      showDialog(
        useSafeArea: false,
        context: context,
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Captured widget screenshot'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _save.saveFile(capturedImage, 'filename.png');
            },
            child: const Icon(Icons.download),
          ),
          body: Center(
            child: Image.memory(capturedImage),
          ),
        ),
      );
}
