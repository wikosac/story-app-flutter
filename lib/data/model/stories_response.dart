import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stories_response.g.dart';

StoriesResponse storiesResponseFromJson(String str) =>
    StoriesResponse.fromJson(json.decode(str));

@JsonSerializable()
class StoriesResponse {
  final bool error;
  final String message;
  @JsonKey(name: "listStory")
  final List<Story>? listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) => _$StoriesResponseFromJson(json);
}

@JsonSerializable()
class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

DetailResponse detailResponseFromJson(String str) => DetailResponse.fromJson(json.decode(str));

@JsonSerializable()
class DetailResponse {
  final bool error;
  final String message;
  @JsonKey(name: "story")
  final Story? story;

  DetailResponse({
    required this.error,
    required this.message,
    this.story,
  });

  factory DetailResponse.fromJson(Map<String, dynamic> json) => _$DetailResponseFromJson(json);
}
