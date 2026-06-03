import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qingmooo/services/data_service.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/services/coin_service.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/screens/splash_screen.dart';
import 'package:qingmooo/screens/edit_profile_screen.dart';
import 'package:qingmooo/screens/help_feedback_screen.dart';
import 'package:qingmooo/screens/about_screen.dart';
import 'package:qingmooo/screens/complaint_screen.dart';
import 'package:qingmooo/screens/my_posts_screen.dart';
import 'package:qingmooo/screens/iap_screen.dart';
import 'package:qingmooo/constants/legal_documents.dart';
import 'package:qingmooo/screens/legal_document_screen.dart';
import 'package:qingmooo/widgets/coin_icon.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  String _userName = '星陌用户';
  String _userBio = '这个人很懒，什么都没留下';
  String _userAvatar = 'assets/images/tx.jpg';
  int _currentCoins = 0;

  @override
  void initState() {
    super.initState();
    _user = DataService.getCurrentUser();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await StorageService.getUserName();
    final bio = await StorageService.getUserBio();
    final avatar = await StorageService.getUserAvatar();
    final coins = await CoinService.getCoins();
    
    setState(() {
      _userName = name;
      _userBio = bio;
      _userAvatar = avatar;
      _currentCoins = coins;
    });
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
    
    if (result == true) {
      _loadUserData();
    }
  }

  Future<void> _navigateToRecharge() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IAPScreen()),
    );
    
    if (mounted) {
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildUserCard(),
                const SizedBox(height: 20),
                _buildCoinCard(),
                const SizedBox(height: 20),
                _buildMenuList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return GestureDetector(
      onTap: _navigateToEditProfile,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white.withValues(alpha: 0.55),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF1DBB).withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(36),
                                child: _buildAvatarImage(_userAvatar),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF000000),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userBio,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF757575),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(_user.likes.toString(), '获赞'),
                        _buildDivider(),
                        _buildStatItem(_user.followers.toString(), '粉丝'),
                        _buildDivider(),
                        _buildStatItem(_user.following.toString(), '关注'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoinCard() {
    return GestureDetector(
      onTap: _navigateToRecharge,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF1DBB),
              Color(0xFFFFB099),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF1DBB).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '我的金币',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CoinIcon(
                        size: 28,
                        coinColor: Colors.white,
                        symbolColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_currentCoins',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '充值',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _buildMenuList() {
    final menuItems = [
      {'icon': Icons.star_border_outlined, 'color': const Color(0xFF000000), 'title': '我的推荐', 'hasArrow': true},
      {'icon': Icons.help_outline, 'color': const Color(0xFF000000), 'title': '帮助反馈', 'hasArrow': true},
      {'icon': Icons.warning_amber_outlined, 'color': const Color(0xFF000000), 'title': '我要投诉', 'hasArrow': true},
      {'icon': Icons.description_outlined, 'color': const Color(0xFF000000), 'title': '用户须知', 'hasArrow': true},
      {'icon': Icons.shield_outlined, 'color': const Color(0xFF000000), 'title': '隐私协议', 'hasArrow': true},
      {'icon': Icons.info_outline, 'color': const Color(0xFF000000), 'title': '关于我们', 'hasArrow': true},
      {'icon': Icons.logout_outlined, 'color': const Color(0xFFE53935), 'title': '退出账号', 'hasArrow': false},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.55),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF1DBB).withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: Column(
              children: menuItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == menuItems.length - 1;
                return _buildMenuItem(
                  item['icon'] as IconData,
                  item['color'] as Color,
                  item['title'] as String,
                  item['hasArrow'] as bool,
                  isLast: isLast,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    Color color,
    String title,
    bool hasArrow, {
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == '退出账号') {
          _showLogoutDialog();
        } else if (title == '我的推荐') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyPostsScreen()),
          );
        } else if (title == '帮助反馈') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpFeedbackScreen()),
          );
        } else if (title == '我要投诉') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComplaintScreen()),
          );
        } else if (title == '隐私协议') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LegalDocumentScreen(
                title: LegalDocuments.privacyPolicyTitle,
                content: LegalDocuments.privacyPolicyContent,
              ),
            ),
          );
        } else if (title == '用户须知') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LegalDocumentScreen(
                title: LegalDocuments.userTermsTitle,
                content: LegalDocuments.userTermsContent,
              ),
            ),
          );
        } else if (title == '关于我们') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast ? BorderSide.none : BorderSide(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: title == '我的钱包'
                      ? const Color(0xFFFF1DBB)
                      : (isLast ? const Color(0xFFE53935) : const Color(0xFF424242)),
                ),
              ),
            ),
            if (hasArrow)
              Icon(
                Icons.chevron_right,
                size: 18,
                color: const Color(0xFFBDBDBD),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarImage(String avatar) {
    if (avatar.startsWith('http')) {
      return Image.network(avatar, fit: BoxFit.cover);
    } else if (avatar.startsWith('/')) {
      final file = File(avatar);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
      return Image.asset('assets/images/tx.jpg', fit: BoxFit.cover);
    } else {
      return Image.asset(avatar, fit: BoxFit.cover);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '是否退出当前账号',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: const Text(
          '退出登录后需要重新登录',
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
            onPressed: () async {
              Navigator.pop(context);
              await StorageService.clearUserData();
              await CoinService.clearCoinData();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
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
}
