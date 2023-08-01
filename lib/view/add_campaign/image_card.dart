import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../model/campaign.dart';

class ImageCard extends StatelessWidget {
  final List<Campaign> campaigns;
  EmojiParser parser = EmojiParser();

  ImageCard({super.key, required this.campaigns});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (final campaign in campaigns)
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
                          padding: EdgeInsets.all(5.0),
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
                          child: Text(
                            parser.emojify('${campaign.title}'),
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
                          padding: EdgeInsets.all(5.0),
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
                            parser.emojify('${campaign.heading}'),
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
                          padding: EdgeInsets.all(5.0),
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
                            parser.emojify('${campaign.desc}'),
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
}
