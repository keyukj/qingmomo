import 'package:flutter/material.dart';
import 'package:qingmooo/services/data_service.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/screens/category_screen.dart';
import 'package:qingmooo/screens/article_list_screen.dart';
import 'package:qingmooo/screens/photo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FeaturedPhoto _featuredPhoto;
  List<Photo> _recommendPhotos = [];
  List<Photo> _latestPhotos = [];
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
    _featuredPhoto = DataService.getFeaturedPhoto();
    await _loadBlockedUsers();
    await _loadHiddenPhotos();
    await _filterPhotos();
    await _loadLikedStatus();
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

  Future<void> _filterPhotos() async {
    final allPhotos = DataService.getAllPhotos();
    final latestPhotos = DataService.getLatestPhotos();
    
    setState(() {
      // 过滤掉被拉黑用户的内容和被屏蔽的内容
      _recommendPhotos = allPhotos.where((photo) {
        final isNotBlocked = !_blockedUsers.contains(photo.authorName);
        final isNotHidden = !_hiddenPhotos.contains(photo.id);
        return isNotBlocked && isNotHidden;
      }).toList();
      
      _latestPhotos = latestPhotos.where((photo) {
        final isNotBlocked = !_blockedUsers.contains(photo.authorName);
        final isNotHidden = !_hiddenPhotos.contains(photo.id);
        return isNotBlocked && isNotHidden;
      }).toList();
    });
  }

  Future<void> _loadLikedStatus() async {
    final likedMap = await StorageService.getAllLikedPhotos();
    setState(() {
      _likedPhotos.clear();
      _likedPhotos.addAll(likedMap);
    });
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
      body: CustomScrollView(
        slivers: [
          // 顶部间距
          const SliverToBoxAdapter(
            child: SizedBox(height: 48),
          ),
          // 大图横幅
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFeaturedBanner(),
            ),
          ),
          // 横向滚动小图
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: _buildSmallPhotoRow(),
            ),
          ),
          // 推荐/最新标签
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  Widget _buildFeaturedBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据比例357:135计算高度
        final width = constraints.maxWidth;
        final height = width * 135 / 357;
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArticleListScreen(),
              ),
            );
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _featuredPhoto.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Text(
                      _featuredPhoto.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallPhotoRow() {
    final labels = ['热门', '人像', '风景', '城市'];
    // 使用新的图片URL
    final smallPhotoUrls = [
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80', // 自然风光
      'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=400&q=80', // 人物背影
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80', // 风景（雪山）
      'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400&q=80', // 城市建筑
    ];
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 计算每个图片的宽度：(总宽度 - 3个间隔) / 4
        final totalWidth = constraints.maxWidth;
        final spacing = 8.0;
        final itemWidth = (totalWidth - spacing * 3) / 4;
        // 根据比例76:56计算高度
        final itemHeight = itemWidth * 56 / 76;
        
        return SizedBox(
          height: itemHeight,
          child: Row(
            children: List.generate(4, (index) {
              return SizedBox(
                width: itemWidth,
                child: Padding(
                  padding: EdgeInsets.only(right: index < 3 ? spacing : 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(category: labels[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              smallPhotoUrls[index],
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.4),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 6,
                              child: Text(
                                labels[index],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
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
    // 根据选中的标签选择照片列表
    final photos = _selectedTab == 0 ? _recommendPhotos : _latestPhotos;
    
    // 将照片分成左右两列
    final leftPhotos = <Photo>[];
    final rightPhotos = <Photo>[];
    
    for (int i = 0; i < photos.length; i++) {
      if (i % 2 == 0) {
        leftPhotos.add(photos[i]);
      } else {
        rightPhotos.add(photos[i]);
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
          // 从详情页返回后重新加载数据
          _loadData();
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
                        Container(
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