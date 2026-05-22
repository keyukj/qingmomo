import 'package:flutter/material.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/services/data_service.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/screens/photo_detail_screen.dart';
import 'package:qingmooo/main.dart';

class UserProfileScreen extends StatefulWidget {
  final String userName;
  final String userAvatar;

  const UserProfileScreen({
    super.key,
    required this.userName,
    required this.userAvatar,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;
  late List<Photo> _userPhotos;
  late int _followers;
  late int _following;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _loadUserPhotos();
    _generateUserStats();
  }

  void _loadUserPhotos() {
    // 获取该用户的所有照片
    final allPhotos = DataService.getAllPhotos();
    _userPhotos = allPhotos.where((photo) => photo.authorName == widget.userName).toList();
  }

  void _generateUserStats() {
    // 根据用户名生成固定但不同的统计数据
    final nameHash = widget.userName.hashCode.abs();
    
    // 粉丝数：10-99
    _followers = 10 + (nameHash % 90);
    
    // 关注数：5-99
    _following = 5 + ((nameHash * 7) % 95);
    
    // 获赞数：根据动态数量和用户名生成，范围更大一些
    final baseHash = (nameHash * 13) % 500;
    _likes = (_userPhotos.length * 15) + baseHash;
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.block, color: Color(0xFFE53935)),
                  title: const Text(
                    '拉黑',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // 关闭底部菜单
                    _showBlockConfirmDialog();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBlockConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '拉黑用户',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: Text(
          '确定要拉黑 ${widget.userName} 吗？\n拉黑后将不再看到该用户的动态。',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // 拉黑用户
              await StorageService.blockUser(widget.userName);
              
              if (mounted) {
                Navigator.pop(context); // 关闭对话框
                
                // 显示提示
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('已拉黑 ${widget.userName}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // 跳转到推荐页（MainScreen的第二个tab）
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            child: const Text(
              '确定',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF1A1A1A), size: 24),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // 头部信息
          _buildHeader(),
          const SizedBox(height: 16),
          // 内容区域
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // 头像
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(widget.userAvatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 用户名
          Text(
            widget.userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          // 统计数据
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem('$_likes', '获赞'),
              const SizedBox(width: 32),
              _buildStatItem('$_followers', '粉丝'),
              const SizedBox(width: 32),
              _buildStatItem('$_following', '关注'),
            ],
          ),
          const SizedBox(height: 16),
          // 关注按钮
          GestureDetector(
            onTap: () {
              setState(() {
                _isFollowing = !_isFollowing;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              decoration: BoxDecoration(
                color: _isFollowing ? Colors.white : const Color(0xFF000000),
                border: Border.all(
                  color: const Color(0xFF000000),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _isFollowing ? '已关注' : '关注',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isFollowing ? const Color(0xFF000000) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    // 动态列表
    if (_userPhotos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '还没有发布动态',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: _userPhotos.length,
      itemBuilder: (context, index) {
        final photo = _userPhotos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoDetailScreen(photo: photo),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(photo.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
