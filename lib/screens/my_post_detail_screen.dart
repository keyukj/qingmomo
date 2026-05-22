import 'package:flutter/material.dart';

class MyPostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onDelete;

  const MyPostDetailScreen({
    super.key,
    required this.post,
    required this.onDelete,
  });

  @override
  State<MyPostDetailScreen> createState() => _MyPostDetailScreenState();
}

class _MyPostDetailScreenState extends State<MyPostDetailScreen> {
  late bool _isLiked;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post['isLiked'] ?? false;
    _likes = widget.post['likes'] ?? 0;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likes++;
      } else {
        _likes--;
      }
    });
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
                  leading: const Icon(Icons.delete_outline, color: Color(0xFFE53935)),
                  title: const Text(
                    '删除',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // 关闭底部菜单
                    _showDeleteConfirmDialog();
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

  void _showDeleteConfirmDialog() {
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
          '确定要删除这条动态吗？\n删除后将无法恢复。',
          style: TextStyle(
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
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              widget.onDelete(); // 执行删除回调
              Navigator.pop(context); // 返回到我的推荐页面
              
              // 显示提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已删除'),
                  duration: Duration(seconds: 2),
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white, size: 24),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // 图片区域
          Expanded(
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  widget.post['image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 底部信息区域
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  widget.post['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // 描述
                Text(
                  widget.post['description'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFCCCCCC),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // 点赞按钮
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isLiked ? Colors.white : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                              size: 18,
                              color: _isLiked ? Colors.black : Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_likes',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _isLiked ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
