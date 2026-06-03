import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qingmooo/constants/app_info.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '关于${AppInfo.appName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF1DBB).withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                AppInfo.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'v1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppInfo.tagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF1DBB),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCard(title: '应用介绍', content: AppInfo.fullDescription),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCard(title: '我们的使命', content: AppInfo.mission),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCard(title: '我们的愿景', content: AppInfo.vision),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildListCard(title: '核心价值观', items: AppInfo.coreValues),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildListCard(title: '应用特色', items: AppInfo.features),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCard(title: '我们的用户', content: AppInfo.targetAudience),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String content}) {
    return _glassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard({required String title, required List<String> items}) {
    return _glassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF1DBB),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
        borderRadius: BorderRadius.circular(24),
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
            child: Padding(padding: const EdgeInsets.all(20), child: child),
          ),
        ),
      ),
    );
  }
}
