import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class ViewAlertBox extends StatelessWidget {
  ViewAlertBox({super.key, required this.imageUri});

  String imageUri;

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
                  Image.network(
                    imageUri,
                    width: 500,
                    height: 500,
                    cacheHeight: 450,
                    cacheWidth: 450,
                    scale: 1,
                    filterQuality: FilterQuality.low,

                  )
                ],
              ),
            ),
          );
        },
      );
}
