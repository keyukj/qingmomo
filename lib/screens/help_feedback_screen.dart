import 'package:flutter/material.dart';

class HelpFeedbackScreen extends StatelessWidget {
  const HelpFeedbackScreen({super.key});

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
          '帮助反馈',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQItem(
            '如何上传照片？',
            '点击首页底部的"+"按钮，选择相册中的照片，添加标题和描述后即可发布。',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '如何关注其他用户？',
            '进入用户主页或查看作品详情时，点击"关注"按钮即可关注该用户。',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '如何收藏喜欢的照片？',
            '在照片详情页或列表页，点击点赞按钮即可收藏，收藏的内容会显示在"我的"页面。',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '如何修改个人资料？',
            '进入"我的"页面，点击头像或昵称区域，即可进入编辑资料页面进行修改。',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '如何举报不良内容？',
            '在内容详情页点击右上角"..."按钮，选择"举报"选项，填写举报原因后提交。',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '如何屏蔽用户？',
            '在用户主页或内容详情页点击"..."按钮，选择"拉黑"或"屏蔽"选项。',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
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
}
