class PostCampaign {
  String? articleName;
  String? date;
  String? link;
  String? title;
  String? heading;
  String? desc;
  String? imageFile;
  String feedback = 'DisApprove';

  PostCampaign(
      {this.articleName,
      this.date,
      this.link,
      this.title,
      this.heading,
      this.desc,
      this.imageFile,
      required this.feedback});

  @override
  String toString() =>
      '{\n\ndate: $date\n\tlink: $link\n\ttitle: $title\n\theading: $heading\n\tdesc: $desc\n\timageFile:$imageFile\n}';
}
