class CastModel {
  final String name;
  final String? profilePath;

  CastModel({required this.name, this.profilePath});

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'],
      profilePath: json['profile_path'],
    );
  }
}
