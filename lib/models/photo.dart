class Photo {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final bool isLiked;
  final String category; // 新增分类字段：人像、风景、城市

  Photo({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    this.isLiked = false,
    this.category = '',
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      authorName: json['authorName'] ?? '',
      authorAvatar: json['authorAvatar'] ?? '',
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'likes': likes,
      'isLiked': isLiked,
      'category': category,
    };
  }

  Photo copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? description,
    String? authorName,
    String? authorAvatar,
    int? likes,
    bool? isLiked,
    String? category,
  }) {
    return Photo(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      category: category ?? this.category,
    );
  }
}

class FeaturedPhoto extends Photo {
  FeaturedPhoto({
    required super.id,
    required super.imageUrl,
    required super.title,
    required super.description,
    required super.authorName,
    required super.authorAvatar,
    required super.likes,
  }) : super(isLiked: false);
}

class Topic {
  final String id;
  final String name;
  final bool isHot;

  Topic({
    required this.id,
    required this.name,
    this.isHot = false,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isHot: json['isHot'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isHot': isHot,
    };
  }
}

class User {
  final String id;
  final String name;
  final String bio;
  final String avatar;
  final int likes;
  final int followers;
  final int following;

  User({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatar,
    required this.likes,
    required this.followers,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      avatar: json['avatar'] ?? '',
      likes: json['likes'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'likes': likes,
      'followers': followers,
      'following': following,
    };
  }
}

class Article {
  final String id;
  final String title;
  final String coverImage;
  final String authorName;
  final String authorAvatar;
  final int views;
  final int likes;
  final String content;
  final String publishDate;

  Article({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.authorName,
    required this.authorAvatar,
    required this.views,
    required this.likes,
    required this.content,
    required this.publishDate,
  });
}