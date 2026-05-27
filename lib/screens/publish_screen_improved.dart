import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qingmooo/services/coin_service.dart';
import 'package:qingmooo/widgets/coin_icon.dart';
import 'dart:io';

/// 改进的PublishScreen - 添加生命周期监听和实时金币更新
class PublishScreenImproved extends StatefulWidget {
  const PublishScreenImproved({super.key});

  @override
  State<PublishScreenImproved> createState() => _PublishScreenImprovedState();
}

class _PublishScreenImprovedState extends State<PublishScreenImproved>
    with WidgetsBindingObserver {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isPublishing = false;
  int _currentCoins = 0;

  // 金币流订阅
  late Stream<int> _coinStream;

  @override
  void initState() {
    super.initState();
    // 添加生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    _loadCoins();
    _setupCoinListener();
  }

  /// 设置金币变化监听
  void _setupCoinListener() {
    // 注意：这里假设CoinService已经实现了coinStream
    // 如果使用原始的CoinService，需要先升级到改进版本
    _coinStream = CoinService.coinStream;
  }

  /// 应用生命周期变化处理
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 应用从后台返回时刷新金币
      _log('应用返回前台，刷新金币');
      _loadCoins();
    } else if (state == AppLifecycleState.paused) {
      _log('应用进入后台');
    }
  }

  Future<void> _loadCoins() async {
    try {
      final coins = await CoinService.getCoins();
      if (mounted) {
        setState(() {
          _currentCoins = coins;
        });
      }
    } catch (e) {
      _log('加载金币失败: $e');
    }
  }

  @override
  void dispose() {
    // 移除生命周期观察者
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          // 最多选择9张图片
          if (_selectedImages.length + images.length <= 9) {
            _selectedImages.addAll(images);
          } else {
            final remaining = 9 - _selectedImages.length;
            _selectedImages.addAll(images.take(remaining));
            _showSnackBar('最多只能选择9张图片');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('选择图片失败: $e');
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _publish() async {
    if (_selectedImages.isEmpty) {
      _showSnackBar('请至少选择一张图片');
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      _showSnackBar('请输入标题');
      return;
    }

    // 检查金币是否足够
    final canPublish = await CoinService.canPublish();
    if (!canPublish) {
      _showInsufficientCoinsDialog();
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    try {
      // 模拟上传过程
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // 消耗金币
        final success = await CoinService.publishPost();
        
        if (success) {
          setState(() {
            _isPublishing = false;
          });

          // 重新加载金币（虽然流会自动更新，但这里确保同步）
          await _loadCoins();

          _showSnackBar('发布成功！消耗10金币');

          // 返回上一页
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          setState(() {
            _isPublishing = false;
          });
          _showInsufficientCoinsDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
        _showSnackBar('发布失败: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '金币不足',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: Text(
          '发布动态需要10金币，您当前有$_currentCoins金币。请先充值。',
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
            onPressed: () {
              Navigator.pop(context);
              // 返回到个人资料页面充值
              Navigator.pop(context);
            },
            child: const Text(
              '去充值',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF1DBB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _log(String message) {
    print('[PublishScreen] $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1A1A1A), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '发布动态',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF1DBB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CoinIcon(
                      size: 16,
                      coinColor: Color(0xFFFFC107),
                      symbolColor: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    // 使用StreamBuilder实时更新金币显示
                    StreamBuilder<int>(
                      stream: _coinStream,
                      initialData: _currentCoins,
                      builder: (context, snapshot) {
                        final coins = snapshot.data ?? _currentCoins;
                        return Text(
                          '$coins',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF1DBB),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _isPublishing ? null : _publish,
            child: _isPublishing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000000)),
                    ),
                  )
                : const Text(
                    '发布',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片选择区域
              _buildImageGrid(),
              const SizedBox(height: 24),
              // 标题输入
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    hintText: '输入标题（必填）',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF999999),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    counterText: '',
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 描述输入
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 6,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: '分享你的故事...',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF999999),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 提示信息
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '发布动态需要消耗10金币，发布的内容将展示在推荐页面',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
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

  Widget _buildImageGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '添加图片',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_selectedImages.length}/9',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _selectedImages.length < 9 ? _selectedImages.length + 1 : 9,
            itemBuilder: (context, index) {
              if (index == _selectedImages.length && _selectedImages.length < 9) {
                return _buildAddImageButton();
              }
              return _buildImageItem(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              '添加',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(_selectedImages[index].path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
