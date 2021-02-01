class Banner {
  int code;
  List<BannerItem> result;

  Banner({this.code, this.result});

  Banner.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<BannerItem>();
      json['result'].forEach((v) {
        result.add(new BannerItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerItem {
  String linkUrl;
  String picUrl;
  int id;

  BannerItem({this.linkUrl, this.picUrl, this.id});

  BannerItem.fromJson(Map<String, dynamic> json) {
    linkUrl = json['linkUrl'];
    picUrl = json['picUrl'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkUrl'] = this.linkUrl;
    data['picUrl'] = this.picUrl;
    data['id'] = this.id;
    return data;
  }
}