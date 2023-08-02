import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import '../../model/campaign.dart';
import '../../service/save/save.dart';
import 'image_card.dart';

class AddCampaignPage extends StatefulWidget {
  const AddCampaignPage({super.key});

  @override
  State<AddCampaignPage> createState() => _AddCampaignPageState();
}

class _AddCampaignPageState extends State<AddCampaignPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  EmojiParser parser = EmojiParser();
  final ScreenshotController _screenshotController = ScreenshotController();
  final List<Campaign> _campaigns = [];
  final Save _save = Save();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Multiple Images Select'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImages,
                child: const Text('Select Image from Gallery'),
              ),
              const SizedBox(height: 20),
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
                      mainAxisExtent: 577.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final Campaign campaign = _campaigns[index];
                      return Card(
                        elevation: 10,
                        child: ColoredBox(
                          color: const Color(0xffF7F2FA),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _campaigns.remove(_campaigns[index]);
                                    });
                                  },
                                  child: const Text('Remove'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    hintText: 'Enter the Title',
                                  ),
                                  maxLength: 600,
                                  onSaved: (value) {
                                    campaign.title = parser.emojify('$value');
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
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    hintText: 'Enter the Heading',
                                  ),
                                  maxLength: 150,
                                  onSaved: (value) {
                                    campaign.heading = parser.emojify('$value');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    hintText: 'Enter the Description',
                                  ),
                                  maxLength: 255,
                                  onSaved: (value) {
                                    campaign.desc = parser.emojify('$value');
                                  },
                                ),
                              ),
                            ],
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     elevation: 12.0,
                      //     textStyle: const TextStyle(color: Colors.white),
                      //   ),
                      //   onPressed: () {
                      //     if (currentUser != null) {
                      //       if (kDebugMode) {
                      //         print(currentUser!.email);
                      //       }
                      //     }
                      //   },
                      //   child: const Text('Upload'),
                      // ),
                      // const SizedBox(
                      //   width: 15,
                      // ),
                      ElevatedButton(
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
                              // Material(child: ImageCard(campaigns: _campaigns)),
                              Material(
                                  child: ImageCard(
                                campaigns: _campaigns,
                              )),
                            ),
                            delay: const Duration(milliseconds: 1000),
                            context: context,
                          );
                          if (!mounted) return;
                          unawaited(showCapturedWidget(context, value));
                          if (currentUser != null) {
                            if (kDebugMode) {
                              print(currentUser!.email);
                            }
                          }
                        },
                        child: const Text('Download'),
                      ),
                    ],
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

  Widget buildImage1(List<Campaign> campaigns) => SizedBox(
        width: 500 * 3,
        child: Wrap(
          runSpacing: 4.0,
          spacing: 4.0,
          children: [
            for (final campaign in campaigns)
              Card(
                child: Container(
                  width: 488,
                  height: 490,
                  color: Colors.blue.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Expanded(
                              child: AutoSizeText(
                                '${campaign.title}',
                                maxLines: 3,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: kIsWeb
                                ? Image.network(
                                    campaign.imageFile.path,
                                    fit: BoxFit.fitHeight,
                                    // height: 360,
                                    // width: 360,
                                  )
                                : Image.file(
                                    campaign.imageFile,
                                    fit: BoxFit.fitHeight,
                                    // height: 360,
                                    // width: 360,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Expanded(
                                child: AutoSizeText(
                                  parser.emojify('${campaign.heading}'),
                                  maxLines: 3,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Expanded(
                              child: AutoSizeText(
                                parser.emojify('${campaign.desc}'),
                                maxLines: 3,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //   maxCrossAxisExtent: 380.0,
          //   crossAxisSpacing: 4.0,
          //   mainAxisSpacing: 4.0,
          //   mainAxisExtent: 490.0,
          // ),
        ),
      );

  Future<dynamic> showCapturedWidget(
          BuildContext context, Uint8List capturedImage) =>
      showDialog(
        useSafeArea: false,
        context: context,
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Captured screenshot'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _save.saveFile(capturedImage, 'filename.png');
              Navigator.popUntil(context, (route) => route.isFirst);
              unawaited(Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (_) => const AddCampaignPage())));
            },
            child: const Icon(Icons.download),
          ),
          body: Center(
            child: Image.memory(capturedImage),
          ),
        ),
      );
}
