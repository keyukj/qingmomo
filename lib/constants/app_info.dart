class AppInfo {
  static const String appName = '星陌';
  static const String mainTitle = '星陌';

  static const List<String> subtitles = [
    '发现生活中的美好瞬间',
    '分享你的精彩故事',
    '连接志同道合的人',
    '探索无限可能',
    '记录生活的点点滴滴',
    '让美好被看见',
  ];

  static const String shortDescription =
      '星陌是一个摄影社交社区，帮你发现与分享生活中的美好瞬间。';

  static const String mediumDescription =
      '星陌 - 发现生活中的美好瞬间。分享精彩照片，连接志同道合的人，'
      '探索更多摄影灵感。';

  static const String fullDescription =
      '星陌是一个摄影交流社区，帮助用户发现和分享生活中的美好瞬间。\n\n'
      '核心功能：\n'
      '• 分享作品 - 上传照片与文字，记录生活时刻\n'
      '• 发现推荐 - 浏览感兴趣的内容与创作者\n'
      '• 互动社交 - 点赞、收藏、关注，与同好交流\n'
      '• 个性浏览 - 根据兴趣浏览更相关的内容\n\n'
      '在这里，你可以自由表达，用镜头记录日常与特别的瞬间。';

  static const String tagline = '让美好被看见';
  static const String slogan = '发现生活，分享美好';

  static const String vision =
      '成为温暖、真实的摄影社交社区，让每个人都能自由表达，'
      '发现生活中的美好，连接志同道合的人。';

  static const String mission = '通过分享与连接，记录更多生活里的美好。';

  static const List<String> coreValues = [
    '真实 - 鼓励真实表达',
    '美好 - 发现与分享生活中的美好',
    '连接 - 建立有意义的交流',
    '创意 - 激发摄影与创作灵感',
    '尊重 - 维护友好、健康的社区氛围',
  ];

  static const String targetAudience =
      '热爱摄影、乐于分享、善于发现生活美好的用户。'
      '无论你是摄影爱好者、旅行达人，还是日常记录者，'
      '都可以在这里展示作品、结识同好。';

  static const List<String> features = [
    '内容推荐 - 浏览更感兴趣的作品',
    '社区互动 - 点赞、收藏、关注',
    '个人主页 - 展示作品与资料',
    '隐私设置 - 保护个人信息',
    '内容管理 - 发布、编辑与删除作品',
  ];

  static String getRandomSubtitle() {
    return subtitles[DateTime.now().millisecond % subtitles.length];
  }
}
