import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qingmooo/screens/splash_screen.dart';
import 'package:qingmooo/screens/home_screen.dart';
import 'package:qingmooo/screens/recommend_screen.dart';
import 'package:qingmooo/screens/fav_screen.dart';
import 'package:qingmooo/screens/profile_screen.dart';
import 'package:qingmooo/screens/publish_screen.dart';
import 'package:qingmooo/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const QingmoooApp());
}

class QingmoooApp extends StatelessWidget {
  const QingmoooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '轻陌',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF1DBB),
        scaffoldBackgroundColor: const Color(0xFFFDFBFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF1DBB),
          primary: const Color(0xFFFF1DBB),
          secondary: const Color(0xFFFFB099),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const HomeScreen(),
    const RecommendScreen(),
    const FavScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.grid_view_outlined,
    Icons.bookmark_border_outlined,
    Icons.person_outline,
  ];

  final List<IconData> _activeIcons = [
    Icons.home,
    Icons.grid_view,
    Icons.bookmark,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          // 悬浮发布按钮 - 只在推荐页显示
          if (_currentIndex == 1)
            Positioned(
              right: 16,
              bottom: 150,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PublishScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          // 注销按钮 - 右上角
          Positioned(
            top: 48,
            right: 24,
            child: GestureDetector(
              onTap: _showLogoutDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout,
                      size: 16,
                      color: Color(0xFFE53935),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '注销',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
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
          borderRadius: BorderRadius.circular(40),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    bool isActive = _currentIndex == index;
                    return _buildNavItem(index, isActive);
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Icon(
          isActive ? _activeIcons[index] : _icons[index],
          color: isActive ? const Color(0xFF000000) : Colors.grey[400],
          size: 24,
        ),
      ),
    );
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
          '是否注销登录',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: const Text(
          '注销登录后需要重新登录',
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
              Navigator.pop(context); // 关闭对话框
              // 清除所有用户数据
              await StorageService.clearUserData();
              // 跳转到启动页，并清除所有路由栈
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