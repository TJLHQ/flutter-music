class SearchList {
  int code;
  List<SearchListItem> result;

  SearchList({this.code, this.result});

  SearchList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<SearchListItem>();
      json['result'].forEach((v) {
        result.add(new SearchListItem.fromJson(v));
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

class SearchListItem {
  int albumnum;
  int singerid;
  String singermid;
  String singername;
  int songnum;
  String type;
  int id;
  String mid;
  String singer;
  String name;
  String album;
  int duration;
  String image;
  String url;

  SearchListItem(
      {this.albumnum,
        this.singerid,
        this.singermid,
        this.singername,
        this.songnum,
        this.type,
        this.id,
        this.mid,
        this.singer,
        this.name,
        this.album,
        this.duration,
        this.image,
        this.url});

  SearchListItem.fromJson(Map<String, dynamic> json) {
    albumnum = json['albumnum'];
    singerid = json['singerid'];
    singermid = json['singermid'];
    singername = json['singername'];
    songnum = json['songnum'];
    type = json['type'];
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
    data['albumnum'] = this.albumnum;
    data['singerid'] = this.singerid;
    data['singermid'] = this.singermid;
    data['singername'] = this.singername;
    data['songnum'] = this.songnum;
    data['type'] = this.type;
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