import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _avatar = 'assets/images/tx.jpg';
  String _gender = '男';
  int _age = 25;
  final List<String> _selectedInterests = [];
  
  final List<String> _interestOptions = [
    '摄影', '旅行', '美食', '运动', '音乐', '电影',
    '阅读', '绘画', '时尚', '宠物', '游戏', '科技'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final name = await StorageService.getUserName();
    final bio = await StorageService.getUserBio();
    final avatar = await StorageService.getUserAvatar();
    final gender = await StorageService.getUserGender();
    final age = await StorageService.getUserAge();
    final interests = await StorageService.getUserInterests();
    
    setState(() {
      _nameController.text = name;
      _bioController.text = bio;
      _avatar = avatar;
      _gender = gender;
      _age = age;
      _selectedInterests.addAll(interests);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      try {
        // 获取应用文档目录
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'user_avatar_$timestamp.jpg';
        final savedImagePath = '${directory.path}/$fileName';
        
        // 复制选中的图片到应用目录
        final File imageFile = File(image.path);
        await imageFile.copy(savedImagePath);
        
        setState(() {
          _avatar = savedImagePath;
        });
        
        // 立即保存到存储，这样其他页面可以同步
        await StorageService.saveUserAvatar(savedImagePath);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('头像已更新')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('头像更新失败: $e')),
          );
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入昵称')),
      );
      return;
    }

    await StorageService.saveUserName(_nameController.text.trim());
    await StorageService.saveUserBio(_bioController.text.trim());
    await StorageService.saveUserAvatar(_avatar);
    await StorageService.saveUserGender(_gender);
    await StorageService.saveUserAge(_age);
    await StorageService.saveUserInterests(_selectedInterests);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存成功')),
      );
      Navigator.pop(context, true); // 返回true表示数据已更新
    }
  }

  void _showGenderPicker() {
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
              const SizedBox(height: 16),
              const Text(
                '选择性别',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('男', textAlign: TextAlign.center),
                onTap: () {
                  setState(() => _gender = '男');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('女', textAlign: TextAlign.center),
                onTap: () {
                  setState(() => _gender = '女');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('保密', textAlign: TextAlign.center),
                onTap: () {
                  setState(() => _gender = '保密');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAgePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                '选择年龄',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 83, // 18-100岁
                  itemBuilder: (context, index) {
                    final age = 18 + index;
                    return ListTile(
                      title: Text('$age岁', textAlign: TextAlign.center),
                      onTap: () {
                        setState(() => _age = age);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
          '编辑资料',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              '保存',
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
        child: Column(
          children: [
            const SizedBox(height: 24),
            // 头像
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(46),
                      child: _buildAvatarImage(_avatar),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '点击更换头像',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
            const SizedBox(height: 32),
            // 表单项
            _buildFormItem(
              '昵称',
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: '请输入昵称',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFF999999)),
                ),
              ),
            ),
            _buildDivider(),
            _buildFormItem(
              '性别',
              GestureDetector(
                onTap: _showGenderPicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _gender,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Color(0xFF999999),
                    ),
                  ],
                ),
              ),
            ),
            _buildDivider(),
            _buildFormItem(
              '年龄',
              GestureDetector(
                onTap: _showAgePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$_age岁',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Color(0xFF999999),
                    ),
                  ],
                ),
              ),
            ),
            _buildDivider(),
            // 兴趣爱好
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '兴趣爱好',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interestOptions.map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedInterests.remove(interest);
                            } else {
                              _selectedInterests.add(interest);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF000000) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : const Color(0xFF666666),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            _buildDivider(),
            // 个性签名
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '个性签名',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bioController,
                    maxLines: 3,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: '写下你的个性签名...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFF999999)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFormItem(String label, Widget trailing) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: trailing),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const SizedBox(height: 0);
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
