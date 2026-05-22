import 'package:flutter/material.dart';
import 'package:qingmooo/services/data_service.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/screens/photo_detail_screen.dart';
import 'package:qingmooo/screens/user_profile_screen.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  List<Photo> _photos = [];
  int _selectedTab = 0; // 0: 推荐, 1: 最新
  final Map<String, bool> _likedPhotos = {};
  List<String> _blockedUsers = [];
  List<String> _hiddenPhotos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadLikedStatus();
    await _loadBlockedUsers();
    await _loadHiddenPhotos();
    _filterPhotos();
  }

  Future<void> _loadLikedStatus() async {
    final likedMap = await StorageService.getAllLikedPhotos();
    setState(() {
      _likedPhotos.clear();
      _likedPhotos.addAll(likedMap);
    });
  }

  Future<void> _loadBlockedUsers() async {
    final blockedUsers = await StorageService.getBlockedUsers();
    setState(() {
      _blockedUsers = blockedUsers;
    });
  }

  Future<void> _loadHiddenPhotos() async {
    final hiddenPhotos = await StorageService.getHiddenPhotos();
    setState(() {
      _hiddenPhotos = hiddenPhotos;
    });
  }

  void _filterPhotos() {
    // 根据选中的标签选择数据源
    final sourcePhotos = _selectedTab == 0 
        ? DataService.getAllPhotos()  // 推荐
        : DataService.getLatestPhotos();  // 最新
    
    setState(() {
      _photos = sourcePhotos.where((photo) {
        // 过滤掉被拉黑用户的内容
        if (_blockedUsers.contains(photo.authorName)) {
          return false;
        }
        // 过滤掉被屏蔽的内容
        if (_hiddenPhotos.contains(photo.id)) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  Future<void> _toggleLike(Photo photo) async {
    final newStatus = !(_likedPhotos[photo.id] ?? false);
    setState(() {
      _likedPhotos[photo.id] = newStatus;
    });
    await StorageService.toggleLike(photo.id, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 推荐/最新标签
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: _buildTabBar(),
              ),
            ),
            // 瀑布流照片墙
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

  Widget _buildTabBar() {
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          Row(
            children: [
              _buildTab('推荐', 0),
              const SizedBox(width: 24),
              _buildTab('最新', 1),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 0,
            left: _selectedTab == 0 ? 10.5 : 70.5,
            child: Container(
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
          _filterPhotos();  // 切换标签时重新过滤照片
        });
      },
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: isSelected ? 21 : 18,
          fontWeight: FontWeight.w700,
          color: isSelected ? const Color(0xFF000000) : const Color(0xFFA0A0A0),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildWaterfallGrid() {
    // 将照片分成左右两列
    final leftPhotos = <Photo>[];
    final rightPhotos = <Photo>[];
    
    for (int i = 0; i < _photos.length; i++) {
      if (i % 2 == 0) {
        leftPhotos.add(_photos[i]);
      } else {
        rightPhotos.add(_photos[i]);
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
    final isLiked = _likedPhotos[photo.id] ?? false;
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
          // 从详情页返回后刷新数据
          _refreshData();
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