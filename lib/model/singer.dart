class Singer {
  int code;
  List<SingerItem> result;

  Singer({this.code, this.result});

  Singer.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<SingerItem>();
      json['result'].forEach((v) {
        result.add(new SingerItem.fromJson(v));
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

class SingerItem {
  String title;
  List<Items> items;

  SingerItem({this.title, this.items});

  SingerItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String name;
  String avatar;

  Items({this.id, this.name, this.avatar});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}


class SingerTitle{
  String title;
  int currentIndex;
  SingerTitle(this.title,this.currentIndex);
}