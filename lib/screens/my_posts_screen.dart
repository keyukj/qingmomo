import 'package:flutter/material.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/screens/my_post_detail_screen.dart';
import 'dart:io';
import 'dart:convert';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final List<Map<String, dynamic>> _myPosts = [
    {
      'id': 'my1',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      'title': '山间云海',
      'description': '清晨的云海在山间翻腾，如梦似幻。',
      'likes': 156,
      'isLiked': false,
    },
    {
      'id': 'my2',
      'image': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&q=80',
      'title': '湖光山色',
      'description': '平静的湖面倒映着远山，美不胜收。',
      'likes': 234,
      'isLiked': false,
    },
  ];

  String? _userAvatar;
  String _userName = '晚风与猫';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadDeletedPosts();
  }

  Future<void> _loadUserProfile() async {
    final avatar = await StorageService.getUserAvatar();
    final name = await StorageService.getUserName();
    setState(() {
      _userAvatar = avatar;
      if (name.isNotEmpty) {
        _userName = name;
      }
    });
  }

  Future<void> _loadDeletedPosts() async {
    // 从本地存储加载已删除的动态ID列表
    final deletedIds = await StorageService.getDeletedMyPosts();
    setState(() {
      // 过滤掉已删除的动态
      _myPosts.removeWhere((post) => deletedIds.contains(post['id']));
    });
  }

  Future<void> _deletePost(String postId) async {
    // 保存到已删除列表
    await StorageService.deleteMyPost(postId);
    
    setState(() {
      _myPosts.removeWhere((post) => post['id'] == postId);
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已删除')),
      );
    }
  }

  void _toggleLike(int index) {
    setState(() {
      _myPosts[index]['isLiked'] = !(_myPosts[index]['isLiked'] ?? false);
      if (_myPosts[index]['isLiked']) {
        _myPosts[index]['likes']++;
      } else {
        _myPosts[index]['likes']--;
      }
    });
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
        title: const Text(
          '我的推荐',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: _myPosts.isEmpty ? _buildEmptyState() : _buildWaterfallList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 56,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '还没有发布动态',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '去推荐页发布你的第一条动态吧',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // 返回并切换到推荐页
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF000000),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: const Text(
              '去发布',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterfallList() {
    // 将照片分成左右两列
    final leftPosts = <Map<String, dynamic>>[];
    final rightPosts = <Map<String, dynamic>>[];
    
    for (int i = 0; i < _myPosts.length; i++) {
      if (i % 2 == 0) {
        leftPosts.add(_myPosts[i]);
      } else {
        rightPosts.add(_myPosts[i]);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftPosts.asMap().entries.map((entry) {
                final index = entry.key * 2;
                return _buildPhotoCard(entry.value, index, true);
              }).toList(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: rightPosts.asMap().entries.map((entry) {
                final index = entry.key * 2 + 1;
                return _buildPhotoCard(entry.value, index, false);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(Map<String, dynamic> post, int index, bool isLeft) {
    final isLiked = post['isLiked'] ?? false;
    // 左右列使用不同的高度比例
    final height = isLeft ? 200.0 : 260.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          // 跳转到详情页
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyPostDetailScreen(
                post: post,
                onDelete: () => _deletePost(post['id']),
              ),
            ),
          );
        },
        onLongPress: () {
          _showPostOptions(post['id']);
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
                  post['image'],
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
                      post['title'],
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
                            color: Colors.grey[200],
                          ),
                          child: _userAvatar != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.file(
                                    File(_userAvatar!),
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/tx.jpg',
                                        width: 18,
                                        height: 18,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.asset(
                                    'assets/images/tx.jpg',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleLike(index),
                          child: Row(
                            children: [
                              Icon(
                                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                size: 14,
                                color: isLiked ? const Color(0xFF000000) : const Color(0xFF999999),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post['likes']}',
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

  void _showPostOptions(String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Color(0xFF666666)),
                title: const Text('编辑', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('编辑功能开发中')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFE53935)),
                title: const Text(
                  '删除',
                  style: TextStyle(fontSize: 16, color: Color(0xFFE53935)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(postId);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '删除动态',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: const Text(
          '确定要删除这条动态吗？',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
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
            onPressed: () {
              Navigator.pop(context);
              _deletePost(postId);
            },
            child: const Text(
              '删除',
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
}
