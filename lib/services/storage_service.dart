import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static late SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';
  static const String _likedPhotosKey = 'liked_photos';
  static const String _blockedUsersKey = 'blocked_users';
  static const String _hiddenPhotosKey = 'hidden_photos';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<String>> getFavorites() async {
    final jsonString = _prefs.getString(_favoritesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => e.toString()).toList();
  }

  static Future<void> addFavorite(String photoId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(photoId)) {
      favorites.add(photoId);
      await _prefs.setString(_favoritesKey, json.encode(favorites));
    }
  }

  static Future<void> removeFavorite(String photoId) async {
    final favorites = await getFavorites();
    favorites.remove(photoId);
    await _prefs.setString(_favoritesKey, json.encode(favorites));
  }

  static Future<bool> isFavorite(String photoId) async {
    final favorites = await getFavorites();
    return favorites.contains(photoId);
  }

  static Future<void> toggleLike(String photoId, bool isLiked) async {
    final likedJson = _prefs.getString(_likedPhotosKey);
    Map<String, bool> likedMap = {};
    if (likedJson != null) {
      final jsonMap = json.decode(likedJson);
      likedMap = Map<String, bool>.from(jsonMap);
    }
    likedMap[photoId] = isLiked;
    await _prefs.setString(_likedPhotosKey, json.encode(likedMap));
  }

  static Future<bool> isPhotoLiked(String photoId) async {
    final likedJson = _prefs.getString(_likedPhotosKey);
    if (likedJson == null) return false;
    final jsonMap = json.decode(likedJson);
    final likedMap = Map<String, bool>.from(jsonMap);
    return likedMap[photoId] ?? false;
  }

  static Future<Map<String, bool>> getAllLikedPhotos() async {
    final likedJson = _prefs.getString(_likedPhotosKey);
    if (likedJson == null) return {};
    final jsonMap = json.decode(likedJson);
    return Map<String, bool>.from(jsonMap);
  }

  // 拉黑用户相关
  static Future<List<String>> getBlockedUsers() async {
    final jsonString = _prefs.getString(_blockedUsersKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => e.toString()).toList();
  }

  static Future<void> blockUser(String authorName) async {
    final blockedUsers = await getBlockedUsers();
    if (!blockedUsers.contains(authorName)) {
      blockedUsers.add(authorName);
      await _prefs.setString(_blockedUsersKey, json.encode(blockedUsers));
    }
  }

  static Future<bool> isUserBlocked(String authorName) async {
    final blockedUsers = await getBlockedUsers();
    return blockedUsers.contains(authorName);
  }

  // 屏蔽内容相关
  static Future<List<String>> getHiddenPhotos() async {
    final jsonString = _prefs.getString(_hiddenPhotosKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => e.toString()).toList();
  }

  static Future<void> hidePhoto(String photoId) async {
    final hiddenPhotos = await getHiddenPhotos();
    if (!hiddenPhotos.contains(photoId)) {
      hiddenPhotos.add(photoId);
      await _prefs.setString(_hiddenPhotosKey, json.encode(hiddenPhotos));
    }
  }

  static Future<bool> isPhotoHidden(String photoId) async {
    final hiddenPhotos = await getHiddenPhotos();
    return hiddenPhotos.contains(photoId);
  }

  // 用户资料相关
  static Future<String> getUserName() async {
    return _prefs.getString('user_name') ?? '轻陌用户';
  }

  static Future<void> saveUserName(String name) async {
    await _prefs.setString('user_name', name);
  }

  static Future<String> getUserBio() async {
    return _prefs.getString('user_bio') ?? '这个人很懒，什么都没留下';
  }

  static Future<void> saveUserBio(String bio) async {
    await _prefs.setString('user_bio', bio);
  }

  static Future<String> getUserAvatar() async {
    return _prefs.getString('user_avatar') ?? 'assets/images/tx.jpg';
  }

  static Future<void> saveUserAvatar(String avatar) async {
    await _prefs.setString('user_avatar', avatar);
  }

  static Future<String> getUserGender() async {
    return _prefs.getString('user_gender') ?? '保密';
  }

  static Future<void> saveUserGender(String gender) async {
    await _prefs.setString('user_gender', gender);
  }

  static Future<int> getUserAge() async {
    return _prefs.getInt('user_age') ?? 25;
  }

  static Future<void> saveUserAge(int age) async {
    await _prefs.setInt('user_age', age);
  }

  static Future<List<String>> getUserInterests() async {
    final jsonString = _prefs.getString('user_interests');
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => e.toString()).toList();
  }

  static Future<void> saveUserInterests(List<String> interests) async {
    await _prefs.setString('user_interests', json.encode(interests));
  }

  // 我的推荐 - 已删除的动态
  static Future<List<String>> getDeletedMyPosts() async {
    final jsonString = _prefs.getString('deleted_my_posts');
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => e.toString()).toList();
  }

  static Future<void> deleteMyPost(String postId) async {
    final deletedPosts = await getDeletedMyPosts();
    if (!deletedPosts.contains(postId)) {
      deletedPosts.add(postId);
      await _prefs.setString('deleted_my_posts', json.encode(deletedPosts));
    }
  }

  // 引导页相关
  static Future<bool> hasSeenOnboarding() async {
    return _prefs.getBool('has_seen_onboarding') ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    await _prefs.setBool('has_seen_onboarding', true);
  }

  // 清除所有用户数据（注销登录）
  static Future<void> clearUserData() async {
    await _prefs.remove('user_name');
    await _prefs.remove('user_bio');
    await _prefs.remove('user_avatar');
    await _prefs.remove('user_gender');
    await _prefs.remove('user_age');
    await _prefs.remove('user_interests');
    await _prefs.remove('favorites');
    await _prefs.remove('liked_photos');
    await _prefs.remove('blocked_users');
    await _prefs.remove('hidden_photos');
    await _prefs.remove('deleted_my_posts');
  }
}