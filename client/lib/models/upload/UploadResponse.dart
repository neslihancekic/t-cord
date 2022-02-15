class UploadResponse {
  String? originOwnerUserId;
  String? ownerUserId;
  String? url;
  String? midi;
  String? csv;
  String? sheetMusic;

  UploadResponse({this.url, this.midi});

  UploadResponse.fromJson(Map<String, dynamic> json) {
    originOwnerUserId = json['originOwnerUserId'];
    ownerUserId = json['ownerUserId'];
    url = json['url'];
    midi = json['midi'];
    csv = json['csv'];
    sheetMusic = json['sheetMusic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['originOwnerUserId'] = this.originOwnerUserId;
    data['ownerUserId'] = this.ownerUserId;
    data['url'] = this.url;
    data['midi'] = this.midi;
    data['csv'] = this.csv;
    data['sheetMusic'] = this.sheetMusic;

    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}
