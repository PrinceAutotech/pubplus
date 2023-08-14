import 'get_campaign.dart';

class GetListCampaign {
  List<GetCampaign>? articleName;

  GetListCampaign({
    this.articleName,
  });

  factory GetListCampaign.fromJson(Map<String, dynamic> json) => GetListCampaign(
      articleName: List<GetCampaign>.from(json['songs'].map((x) => GetCampaign.fromJson(x))),
    );
}
