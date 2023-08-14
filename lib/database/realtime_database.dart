import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../model/post_campaign.dart';

class RealtimeDatabase {
  Future<void> writeData(
    String currentUser,
    String articleName,
    List<PostCampaign> postCampaign,
  ) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref =
        database.ref('Users').child(currentUser).child('Campaign');
    for (var i = 0; i < postCampaign.length; i++) {
      await ref.child('${DateTime.now().microsecondsSinceEpoch}_$i').set({
        'articleName': articleName,
        'date': postCampaign[i].date,
        'link': postCampaign[i].link,
        'title': postCampaign[i].title,
        'heading': postCampaign[i].heading,
        'desc': postCampaign[i].desc,
        'imageFile': postCampaign[i].imageFile,
      });
    }
  }

  Future<void> readData(
    String currentUser,
  ) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    final snapshot =
        await database.ref('Users').child(currentUser).child('Campaign').get();

    // for (var i = 0; i < GetCampaign.length; i++) {
    //
    // }
    if (snapshot.exists) {
      if (kDebugMode) {
        print(snapshot.value);
      }
    } else {
      if (kDebugMode) {
        print('No data available.');
      }
    }
  }
}
