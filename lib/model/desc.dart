class Desc {
  int code;
  List<DescItem> result;

  Desc({this.code, this.result});

  Desc.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<DescItem>();
      json['result'].forEach((v) {
        result.add(new DescItem.fromJson(v));
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

class DescItem {
  String imgurl;
  String name;
  String dissname;
  String dissid;

  DescItem({this.imgurl, this.name, this.dissname, this.dissid});

  DescItem.fromJson(Map<String, dynamic> json) {
    imgurl = json['imgurl'];
    name = json['name'];
    dissname = json['dissname'];
    dissid = json['dissid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgurl'] = this.imgurl;
    data['name'] = this.name;
    data['dissname'] = this.dissname;
    data['dissid'] = this.dissid;
    return data;
  }
}