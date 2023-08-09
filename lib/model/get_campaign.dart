class GetCampaign {
  String? articleName;
  String? date;
  String? title;
  String? heading;
  String? desc;
  String? imageFile;
  String? articleLink;
  bool isSelected = false;
  bool isExpanded = false;

  GetCampaign({
    this.articleName,
    this.date,
    this.title,
    this.heading,
    this.desc,
    this.imageFile,
    this.articleLink,
  });

  factory GetCampaign.fromJson(Map<String, dynamic> json) => GetCampaign(
        articleName: json['articleName'],
        date: json['date'],
        desc: json['desc'],
        heading: json['heading'],
        imageFile: json['imageFile'],
        articleLink: json['link'],
        title: json['title'],
      );

  @override
  String toString() =>
      '{\n\ttitle: $title\n\theading: $heading\n\tdesc: $desc\n\timageFile: $imageFile\n}';
}
