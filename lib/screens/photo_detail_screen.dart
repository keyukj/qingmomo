import 'package:flutter/material.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/screens/user_profile_screen.dart';
import 'dart:io';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  bool _isLiked = false;
  bool _isFollowing = false;
  int _likeCount = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [];

  @override
  void initState() {
    super.initState();
    _likeCount = widget.photo.likes;
    _loadLikedStatus();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadLikedStatus() async {
    final likedMap = await StorageService.getAllLikedPhotos();
    setState(() {
      _isLiked = likedMap[widget.photo.id] ?? false;
    });
  }

  Future<void> _loadComments() async {
    // 初始状态为空评论列表，用户可以自己添加评论
    setState(() {
      _comments.clear();
    });
  }

  Future<void> _toggleLike() async {
    final newStatus = !_isLiked;
    setState(() {
      _isLiked = newStatus;
      _likeCount = newStatus ? _likeCount + 1 : _likeCount - 1;
    });
    await StorageService.toggleLike(widget.photo.id, newStatus);
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    
    // 获取用户头像
    final userAvatar = await StorageService.getUserAvatar();
    
    setState(() {
      _comments.insert(0, {
        'user': '我',
        'avatar': userAvatar,
        'comment': _commentController.text.trim(),
      });
    });
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _showMoreOptions() {
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
                leading: const Icon(Icons.report_outlined, color: Color(0xFF666666)),
                title: const Text('举报', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block_outlined, color: Color(0xFF666666)),
                title: const Text('拉黑', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_off_outlined, color: Color(0xFF666666)),
                title: const Text('屏蔽', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  _showHideDialog();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('举报'),
        content: const Text('确定要举报这条内容吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Color(0xFF666666))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('举报成功')),
              );
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFF000000))),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('拉黑用户'),
        content: Text('确定要拉黑 ${widget.photo.authorName} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Color(0xFF666666))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 关闭对话框
              await StorageService.blockUser(widget.photo.authorName);
              if (mounted) {
                Navigator.pop(context); // 返回推荐页
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已拉黑该用户')),
                );
              }
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFF000000))),
          ),
        ],
      ),
    );
  }

  void _showHideDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('屏蔽内容'),
        content: const Text('确定要屏蔽这条内容吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Color(0xFF666666))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 关闭对话框
              await StorageService.hidePhoto(widget.photo.id);
              if (mounted) {
                Navigator.pop(context); // 返回推荐页
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已屏蔽该内容')),
                );
              }
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFF000000))),
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
        title: const Text(
          '详情',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF1A1A1A)),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 作者信息
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                  userName: widget.photo.authorName,
                                  userAvatar: widget.photo.authorAvatar,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(widget.photo.authorAvatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.photo.authorName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '2小时前',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFollowing = !_isFollowing;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isFollowing ? const Color(0xFF000000) : Colors.white,
                              border: Border.all(color: const Color(0xFF000000)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _isFollowing ? '已关注' : '关注',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _isFollowing ? Colors.white : const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 图片
                  Image.network(
                    widget.photo.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // 标题和描述
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.photo.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                            height: 1.4,
                          ),
                        ),
                        if (widget.photo.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.photo.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF333333),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 点赞和评论统计
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleLike,
                          child: Row(
                            children: [
                              Icon(
                                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                size: 20,
                                color: _isLiked ? const Color(0xFF000000) : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_likeCount',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _isLiked ? FontWeight.w600 : FontWeight.normal,
                                  color: _isLiked ? const Color(0xFF000000) : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_comments.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  // 评论列表
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '评论',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._comments.map((comment) => _buildCommentItem(comment)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 底部操作栏
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBFB),
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: '说点什么...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onSubmitted: (_) => _addComment(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _addComment,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, String> comment) {
    final avatar = comment['avatar']!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildAvatarImage(avatar),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['user']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment['comment']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(String avatar) {
    // 如果是网络图片
    if (avatar.startsWith('http')) {
      return Image.network(avatar, fit: BoxFit.cover);
    }
    // 如果是本地文件路径（用户上传的头像）
    else if (avatar.startsWith('/')) {
      final file = File(avatar);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
      // 如果文件不存在，使用默认头像
      return Image.asset('assets/images/tx.jpg', fit: BoxFit.cover);
    }
    // 默认资源图片
    else {
      return Image.asset(avatar, fit: BoxFit.cover);
    }
  }
}
