import 'package:manage_state/domain/home/entities/story.dart';

class StoryModel extends Story {
  StoryModel({
    required super.name,
    required super.avatarUrl,
    required super.imageUrl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'imageUrl': imageUrl,
    };
  }
}
