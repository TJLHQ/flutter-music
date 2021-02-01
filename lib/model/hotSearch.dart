class HotSearch {
  int code;
  List<HotSearchItem> result;

  HotSearch({this.code, this.result});

  HotSearch.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<HotSearchItem>();
      json['result'].forEach((v) {
        result.add(new HotSearchItem.fromJson(v));
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

class HotSearchItem {
  String k;
  int n;

  HotSearchItem({this.k, this.n});

  HotSearchItem.fromJson(Map<String, dynamic> json) {
    k = json['k'];
    n = json['n'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['k'] = this.k;
    data['n'] = this.n;
    return data;
  }
}