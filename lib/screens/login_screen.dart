import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:qingmooo/constants/app_info.dart';
import 'package:qingmooo/constants/legal_documents.dart';
import 'package:qingmooo/main.dart';
import 'package:qingmooo/screens/legal_document_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_agreedToTerms) {
      _showTermsDialog();
      return;
    }
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '温馨提示',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: const Text(
          '请先阅读《用户协议》和《隐私协议》',
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
              '不同意',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _agreedToTerms = true;
              });
              _handleLogin();
            },
            child: const Text(
              '同意',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLegalDocument(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocumentScreen(
          title: title,
          content: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFE8E4F3), // 低饱和度浅灰紫色
              const Color(0xFFF5F3F8),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // Logo
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFB8B0D0).withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // App名称
                      Text(
                        AppInfo.appName,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D2D2D),
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 宣传语
                      const Text(
                        '用照片，说出你的故事',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 80),
                      // 登录按钮
                      GestureDetector(
                        onTap: _handleLogin,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '开始探索',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // 协议文本
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToTerms = !_agreedToTerms;
                              });
                            },
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: _agreedToTerms ? const Color(0xFF000000) : Colors.white,
                                border: Border.all(
                                  color: _agreedToTerms ? const Color(0xFF000000) : const Color(0xFFCCCCCC),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: _agreedToTerms
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF999999),
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: '登录即表示同意'),
                                  TextSpan(
                                    text: '《用户协议》',
                                    style: const TextStyle(
                                      color: Color(0xFF8B7AB8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _openLegalDocument(
                                          LegalDocuments.userTermsTitle,
                                          LegalDocuments.userTermsContent,
                                        );
                                      },
                                  ),
                                  const TextSpan(text: '和'),
                                  TextSpan(
                                    text: '《隐私协议》',
                                    style: const TextStyle(
                                      color: Color(0xFF8B7AB8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _openLegalDocument(
                                          LegalDocuments.privacyPolicyTitle,
                                          LegalDocuments.privacyPolicyContent,
                                        );
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
