class DescDetail {
  int code;
  List<DescDetailItem> result;

  DescDetail({this.code, this.result});

  DescDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<DescDetailItem>();
      json['result'].forEach((v) {
        result.add(new DescDetailItem.fromJson(v));
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

class DescDetailItem {
  int id;
  String mid;
  String singer;
  String name;
  String album;
  int duration;
  String image;
  String url;

  DescDetailItem(
      {this.id,
      this.mid,
      this.singer,
      this.name,
      this.album,
      this.duration,
      this.image,
      this.url});

  DescDetailItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    singer = json['singer'];
    name = json['name'];
    album = json['album'];
    duration = json['duration'];
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['singer'] = this.singer;
    data['name'] = this.name;
    data['album'] = this.album;
    data['duration'] = this.duration;
    data['image'] = this.image;
    data['url'] = this.url;
    return data;
  }
}
class SongUrl {
  int code;
  String result;

  SongUrl({this.code, this.result});

  SongUrl.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['result'] = this.result;
    return data;
  }
}

class Lyric {
  int code;
  List<LyricItem> result;

  Lyric({this.code, this.result});

  Lyric.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<LyricItem>();
      json['result'].forEach((v) {
        result.add(new LyricItem.fromJson(v));
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

class LyricItem {
  int time;
  String txt;

  LyricItem({this.time, this.txt});

  LyricItem.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    txt = json['txt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['txt'] = this.txt;
    return data;
  }
}