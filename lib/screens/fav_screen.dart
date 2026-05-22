import 'package:flutter/material.dart';
import 'package:qingmooo/services/data_service.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/screens/photo_detail_screen.dart';
import 'package:qingmooo/screens/user_profile_screen.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> with AutomaticKeepAliveClientMixin {
  List<Photo> _likedPhotos = [];
  final Map<String, bool> _likedPhotosMap = {};

  @override
  bool get wantKeepAlive => false; // 不保持状态，每次都重新构建

  @override
  void initState() {
    super.initState();
    _loadLikedPhotos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面显示时重新加载
    _loadLikedPhotos();
  }

  Future<void> _loadLikedPhotos() async {
    // 加载被拉黑的用户列表和被屏蔽的内容列表
    final blockedUsers = await StorageService.getBlockedUsers();
    final hiddenPhotos = await StorageService.getHiddenPhotos();
    final likedMap = await StorageService.getAllLikedPhotos();
    final allPhotos = DataService.getAllPhotos();
    
    // 筛选出点赞过的照片，并过滤掉被拉黑用户的内容和被屏蔽的内容
    final liked = allPhotos.where((photo) {
      final isLiked = likedMap[photo.id] == true;
      final isNotBlocked = !blockedUsers.contains(photo.authorName);
      final isNotHidden = !hiddenPhotos.contains(photo.id);
      return isLiked && isNotBlocked && isNotHidden;
    }).toList();
    
    setState(() {
      _likedPhotos = liked;
      _likedPhotosMap.clear();
      _likedPhotosMap.addAll(likedMap);
    });
  }

  Future<void> _toggleLike(Photo photo) async {
    final newStatus = !(_likedPhotosMap[photo.id] ?? false);
    setState(() {
      _likedPhotosMap[photo.id] = newStatus;
      if (!newStatus) {
        // 取消点赞，从列表中移除
        _likedPhotos.removeWhere((p) => p.id == photo.id);
      }
    });
    await StorageService.toggleLike(photo.id, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，因为使用了AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 收藏标题
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '收藏',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Text(
                      '共 ${_likedPhotos.length} 条',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 瀑布流照片墙
            if (_likedPhotos.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Color(0xFFE0E0E0),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '还没有收藏内容',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '去推荐页点赞喜欢的内容吧',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: _buildWaterfallGrid(),
              ),
            // 底部间距
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterfallGrid() {
    // 将照片分成左右两列
    final leftPhotos = <Photo>[];
    final rightPhotos = <Photo>[];
    
    for (int i = 0; i < _likedPhotos.length; i++) {
      if (i % 2 == 0) {
        leftPhotos.add(_likedPhotos[i]);
      } else {
        rightPhotos.add(_likedPhotos[i]);
      }
    }

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftPhotos.map((photo) => _buildPhotoCard(photo, true)).toList(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: rightPhotos.map((photo) => _buildPhotoCard(photo, false)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(Photo photo, bool isLeft) {
    final isLiked = _likedPhotosMap[photo.id] ?? false;
    // 左右列使用不同的高度比例
    final height = isLeft ? 200.0 : 260.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDetailScreen(photo: photo),
            ),
          );
          // 从详情页返回后重新加载数据
          _loadLikedPhotos();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.network(
                  photo.imageUrl,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3EDF3),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                  userName: photo.authorName,
                                  userAvatar: photo.authorAvatar,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              image: DecorationImage(
                                image: NetworkImage(photo.authorAvatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            photo.authorName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleLike(photo),
                          child: Row(
                            children: [
                              Icon(
                                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                size: 14,
                                color: isLiked ? const Color(0xFF000000) : const Color(0xFF999999),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${photo.likes}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isLiked ? const Color(0xFF000000) : const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}