class CompositionModel {
  List<TrackModel>? tracks;
  List<String>? likes;
  int? commentCount;
  String? id;
  String? originOwnerUserId;
  String? ownerUserId;
  String? username;
  String? title;
  String? info;
  String? midi;
  String? csv;
  String? audio;
  String? sheetMusic;
  String? createdAt;
  String? updatedAt;

  bool? isLiked;
  List<String>? userPhotos;
  String? photo;

  String? audioPath;

  CompositionModel(
      {this.tracks,
      this.likes,
      this.commentCount,
      this.id,
      this.originOwnerUserId,
      this.ownerUserId,
      this.username,
      this.title,
      this.info,
      this.midi,
      this.csv,
      this.audio,
      this.sheetMusic,
      this.userPhotos,
      this.photo,
      this.createdAt,
      this.updatedAt,
      this.audioPath});

  CompositionModel.fromJson(Map<String, dynamic> json) {
    if (json['tracks'] != null) {
      tracks = new List<TrackModel>.empty(growable: true);
      json['tracks'].forEach((v) {
        tracks!.add(new TrackModel.fromJson(v));
      });
    }
    if (json['likes'] != null) {
      likes = new List<String>.empty(growable: true);
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    if (json['userPhotos'] != null) {
      userPhotos = new List<String>.empty(growable: true);
      json['userPhotos'].forEach((v) {
        userPhotos!.add(v);
      });
    }
    id = json['_id'];
    originOwnerUserId = json['originOwnerUserId'];
    ownerUserId = json['ownerUserId'];

    commentCount = json['commentCount'];
    username = json['username'];
    title = json['title'];
    info = json['info'];
    midi = json['midi'];
    csv = json['csv'];
    audio = json['audio'];
    sheetMusic = json['sheetMusic'];
    photo = json['photo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tracks != null) {
      data['tracks'] = this.tracks!.map((v) => v.toJson()).toList();
    }
    data['commentCount'] = this.commentCount;
    data['_id'] = this.id;
    data['originOwnerUserId'] = this.originOwnerUserId;
    data['ownerUserId'] = this.ownerUserId;
    data['username'] = this.username;
    data['title'] = this.title;
    data['info'] = this.info;
    data['midi'] = this.midi;
    data['csv'] = this.csv;
    data['audio'] = this.audio;
    data['sheetMusic'] = this.sheetMusic;
    data['photo'] = this.photo;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}

class TrackModel {
  String? sId;
  String? ownerUserId;
  String? username;
  String? midi;
  String? csv;
  String? audio;
  String? sheetMusic;
  String? createdAt;
  String? updatedAt;

  String? title;
  String? info;

  TrackModel(
      {this.sId,
      this.ownerUserId,
      this.username,
      this.midi,
      this.csv,
      this.audio,
      this.sheetMusic,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.info});

  TrackModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ownerUserId = json['ownerUserId'];
    username = json['username'];
    midi = json['midi'];
    csv = json['csv'];
    audio = json['audio'];
    sheetMusic = json['sheetMusic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ownerUserId'] = this.ownerUserId;
    data['username'] = this.username;
    data['midi'] = this.midi;
    data['csv'] = this.csv;
    data['audio'] = this.audio;
    data['sheetMusic'] = this.sheetMusic;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    data['title'] = this.title;
    data['info'] = this.info;

    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}

class CompositionsResponse {
  List<CompositionModel>? compositions;
  CompositionsResponse();
  CompositionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['compositions'] != null) {
      compositions = new List<CompositionModel>.empty(growable: true);
      json['compositions'].forEach((v) {
        compositions!.add(new CompositionModel.fromJson(v));
      });
    }
  }
}

class TracksResponse {
  List<TrackModel>? tracks;

  TracksResponse.fromJson(Map<String, dynamic> json) {
    if (json['compositions'] != null) {
      tracks = new List<TrackModel>.empty(growable: true);
      json['compositions'].forEach((v) {
        tracks!.add(new TrackModel.fromJson(v));
      });
    }
  }
}
