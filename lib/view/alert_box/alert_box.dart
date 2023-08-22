import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import '../../service/save/save.dart';

class AlertBox extends StatelessWidget {
  AlertBox({super.key, required this.imageUri});

  String imageUri;
  final Save _save = Save();

  @override
  Widget build(BuildContext context) => ImageNetwork(
      image: imageUri,
      height: 180,
      width: 180,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_outlined),
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ImageNetwork(
                  image: imageUri,
                  height: 500,
                  width: 500,
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    List<int> list = utf8.encode(imageUri);
                    Uint8List bytes = Uint8List.fromList(list);
                    _save.saveFile(
                        bytes, '${DateTime.now().microsecondsSinceEpoch}.png');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: const Text('Download'),
                ),
              ),
            ],
          ),
        );
      },
    );
}
