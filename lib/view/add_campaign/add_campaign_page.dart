import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/dashboard.dart';
import '../../database/storage_database.dart';
import '../../model/campaign.dart';
import '../../model/post_campaign.dart';
import '../../service/save/save.dart';
import '../startup/login_page.dart';
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
  TextEditingController articleController = TextEditingController();
  TextEditingController articleNameController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  final List<Campaign> _campaigns = [];
  late final List<PostCampaign> _postCampaign = [];
  final Save _save = Save();
  User? currentUser = FirebaseAuth.instance.currentUser;
  String articleLink = 'nbn';
  String articleName = 'jk';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Multiple Images Select'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  unawaited(Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (_) => const Dashboard())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Add Campaigns'),
                onTap: () {
                  unawaited(Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => const AddCampaignPage())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await _auth.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('auth', false);
                  if (!mounted) return;
                  unawaited(
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const LoginPage()),
                    ),
                  );
                },
              )
            ],
          ),
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
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: articleNameController,
                  onChanged: (value) {
                    articleName = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'Enter the Article Name',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: articleController,
                  onChanged: (value) {
                    articleLink = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'Enter the Article Link',
                  ),
                ),
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
                                  File(campaign.imageFile.path),
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 12.0,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          _formKey.currentState?.save();
                          var value = await _screenshotController
                              .captureFromLongWidget(
                            InheritedTheme.captureAll(
                              context,
                              Material(
                                child: ImageCard(
                                  campaigns: _campaigns,
                                ),
                              ),
                            ),
                            delay: const Duration(milliseconds: 1000),
                            context: context,
                          )
                              .whenComplete(() async {
                            await StorageDatabase()
                                .writeData(_campaigns, currentUser!.uid,
                                    articleName, _postCampaign, articleLink)
                                .whenComplete(() {
                              _postCampaign.clear();
                              _campaigns.clear();
                            });
                          });
                          if (!mounted) return;
                          unawaited(showCapturedWidget(context, value));
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
          _campaigns.add(Campaign(imageFile: xFile));
        }
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

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
              _save.saveFile(capturedImage, '$articleName.png');
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
