class PreKeyDto {
  final int id;
  final String key;

  PreKeyDto(this.id, this.key);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["key"] = key;
    return json;
  }

  PreKeyDto.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        key = json["key"];
}

class SignedPreKeyDto extends PreKeyDto {
  final String signature;

  SignedPreKeyDto(int id, String key, this.signature) : super(id, key);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json["signature"] = signature;
    return json;
  }

  SignedPreKeyDto.fromJson(Map<String, dynamic> json)
      : signature = json["signature"],
        super.fromJson(json);
}
