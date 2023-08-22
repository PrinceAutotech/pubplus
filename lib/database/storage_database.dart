import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../model/campaign.dart';
import '../model/post_campaign.dart';
import 'realtime_database.dart';

class StorageDatabase {
  Future<void> writeData(
      List<Campaign> campaigns,
      String currentUser,
      String articleName,
      List<PostCampaign> postCampaign,
      String articleLink) async {
    UploadTask uploadTask;
    final metaData = SettableMetadata(contentType: 'image/png');
    final storageRef = FirebaseStorage.instance.ref();
    var imagesRef = storageRef.child(currentUser).child(articleName);

    for (var i = 0; i < campaigns.length; i++) {
      Reference ref = imagesRef.child('${DateTime.now()}_$i.png');
      if (kIsWeb) {
        uploadTask =
            ref.putData(await campaigns[i].imageFile.readAsBytes(), metaData);
      } else {
        uploadTask = ref.putFile(File(campaigns[i].imageFile.path), metaData);
      }
      await uploadTask.then((picValue) async {
        await picValue.ref.getDownloadURL().then((downloadUrl) {
          if (kDebugMode) {
            print('URL : $downloadUrl');
          }
          postCampaign.add(
            PostCampaign(
                date: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                title: campaigns[i].title,
                heading: campaigns[i].heading,
                desc: campaigns[i].desc,
                link: articleLink,
                imageFile: downloadUrl,
                feedback: 'false'),
          );
        });
      });
    }
    await RealtimeDatabase().writeData(currentUser, articleName, postCampaign);
  }
}
