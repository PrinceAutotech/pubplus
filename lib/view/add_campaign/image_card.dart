import 'dart:io';

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
  Widget build(BuildContext context) => SizedBox(
        width: 500 * 3,
        child: Wrap(
          runSpacing: 4.0,
          spacing: 4.0,
          children: [
            for (final campaign in campaigns)
              Card(
                color: const Color(0xffF7F2FA),
                child: SizedBox(
                  width: 488,
                  height: 490,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            const Padding(
                              padding: EdgeInsets.all(10),
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
                                    File(campaign.imageFile.path),
                                    fit: BoxFit.fitHeight,
                                    // height: 360,
                                    // width: 360,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
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
                              padding: EdgeInsets.all(5.0),
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
}
