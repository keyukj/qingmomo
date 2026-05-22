import '../models/photo.dart';

class DataService {
  static final List<Photo> _allPhotos = [
    // 确保每张图片、每个文案都是唯一的，用户交替出现
    
    // 1. 阿飞 - 风景
    Photo(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=400&q=80',
      title: '捕捉一束光，定格时间',
      description: '清晨的第一缕阳光穿过云层，洒在山间的每一个角落。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 128,
      category: '风景',
    ),
    
    // 2. DesignX - 城市
    Photo(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=400&q=80',
      title: '极简几何空间',
      description: '现代建筑的魅力在于线条与空间的完美结合。',
      authorName: 'DesignX',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&q=80',
      likes: 56,
      category: '城市',
    ),
    
    // 3. Yuki - 城市
    Photo(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=400&q=80',
      title: '雨后的东京街头',
      description: '雨水打湿的街道倒映着五光十色的霓虹灯。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 342,
      category: '城市',
    ),
    
    // 4. Miao - 人像
    Photo(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400&q=80',
      title: '少女与海',
      description: '海风吹拂着长发，少女静静地望着远方的海平线。',
      authorName: 'Miao',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
      likes: 89,
      category: '人像',
    ),
    
    // 5. Nature - 风景
    Photo(
      id: '5',
      imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=400&q=80',
      title: '森林深处',
      description: '走进森林深处，阳光透过树叶洒下斑驳的光影。',
      authorName: 'Nature',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 234,
      category: '风景',
    ),
    
    // 6. 小林 - 人像
    Photo(
      id: '6',
      imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&q=80',
      title: '午后阳光',
      description: '温暖的午后阳光洒在脸上。',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 156,
      category: '人像',
    ),
    
    // 7. 山川 - 风景
    Photo(
      id: '7',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      title: '云端之上',
      description: '登上山顶，云海在脚下翻腾。',
      authorName: '山川',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 256,
      category: '风景',
    ),
    
    // 8. 建筑师 - 城市
    Photo(
      id: '8',
      imageUrl: 'https://images.unsplash.com/photo-1485081669829-bacb8c7bb1f3?w=400&q=80',
      title: '光影交错',
      description: '建筑的线条在光影中展现出独特的美感。',
      authorName: '建筑师',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 189,
      category: '城市',
    ),
    
    // 9. Tokyo夜景 - 城市
    Photo(
      id: '9',
      imageUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=400&q=80',
      title: '东京夜色',
      description: '繁华都市的夜晚灯火通明，霓虹闪烁。',
      authorName: 'Tokyo夜景',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 278,
      category: '城市',
    ),
    
    // 10. 张摄影 - 人像
    Photo(
      id: '10',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&q=80',
      title: '都市女孩',
      description: '现代都市的时尚气息。',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    
    // 11. 湖光 - 风景
    Photo(
      id: '11',
      imageUrl: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&q=80',
      title: '湖光山色',
      description: '平静的湖面如镜，倒映着远山和天空。',
      authorName: '湖光',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 189,
      category: '风景',
    ),
    
    // 12. Urban - 城市
    Photo(
      id: '12',
      imageUrl: 'https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=400&q=80',
      title: '摩天大楼',
      description: '钢筋水泥构筑的城市森林。',
      authorName: 'Urban',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 423,
      category: '城市',
    ),
    
    // 13. Emma - 人像
    Photo(
      id: '13',
      imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&q=80',
      title: '自然光影',
      description: '光影交错的艺术。',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 189,
      category: '人像',
    ),
    
    // 14. 秋色 - 风景
    Photo(
      id: '14',
      imageUrl: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=400&q=80',
      title: '秋日森林',
      description: '秋天的森林层林尽染，金黄、橙红、深绿交织。',
      authorName: '秋色',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 198,
      category: '风景',
    ),
    
    // 15. Night - 城市
    Photo(
      id: '15',
      imageUrl: 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=400&q=80',
      title: '城市夜景',
      description: '当夜幕降临，城市换上了另一副面孔。',
      authorName: 'Night',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 567,
      category: '城市',
    ),
    
    // 16. Lily - 人像
    Photo(
      id: '16',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
      title: '清新少女',
      description: '清新少女的气质。',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 412,
      category: '人像',
    ),
    
    // 17. Star - 风景
    Photo(
      id: '17',
      imageUrl: 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=400&q=80',
      title: '星空下的帐篷',
      description: '夜晚在野外扎营，抬头便是满天繁星。',
      authorName: 'Star',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 276,
      category: '风景',
    ),
    
    // 18. Skyline - 城市
    Photo(
      id: '18',
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400&q=80',
      title: '都市天际线',
      description: '站在高处俯瞰城市，天际线勾勒出现代都市的轮廓。',
      authorName: 'Skyline',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '城市',
    ),
    
    // 19. 阿文 - 人像
    Photo(
      id: '19',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80',
      title: '微笑瞬间',
      description: '捕捉最美的微笑。',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 298,
      category: '人像',
    ),
    
    // 20. Mountain - 风景
    Photo(
      id: '20',
      imageUrl: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=400&q=80',
      title: '雪山之巅',
      description: '站在雪山之巅，脚下是云海翻腾。',
      authorName: 'Mountain',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 445,
      category: '风景',
    ),
    
    // 21. Street - 城市
    Photo(
      id: '21',
      imageUrl: 'https://images.unsplash.com/photo-1460472178825-e5240623afd5?w=400&q=80',
      title: '街头涂鸦',
      description: '墙面上的涂鸦是街头艺术家的宣言。',
      authorName: 'Street',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 234,
      category: '城市',
    ),
    
    // 22. 小雨 - 人像
    Photo(
      id: '22',
      imageUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&q=80',
      title: '温柔眼神',
      description: '温柔的眼神流转。',
      authorName: '小雨',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 278,
      category: '人像',
    ),
    
    // 23. Lake - 风景
    Photo(
      id: '23',
      imageUrl: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400&q=80',
      title: '湖面倒影',
      description: '湖水如镜，倒映着天空。',
      authorName: 'Lake',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 423,
      category: '风景',
    ),
    
    // 24. Modern - 城市
    Photo(
      id: '24',
      imageUrl: 'https://images.unsplash.com/photo-1486299267070-83823f5448dd?w=400&q=80',
      title: '现代建筑',
      description: '玻璃幕墙反射着天空的颜色。',
      authorName: 'Modern',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 312,
      category: '城市',
    ),
    
    // 25. Grace - 人像
    Photo(
      id: '25',
      imageUrl: 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=400&q=80',
      title: '优雅女性',
      description: '优雅女性的魅力。',
      authorName: 'Grace',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '人像',
    ),
    
    // 26. Forest - 风景
    Photo(
      id: '26',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80',
      title: '森林小径',
      description: '蜿蜒的小径通向森林深处。',
      authorName: 'Forest',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 289,
      category: '风景',
    ),
    
    // 27. Tower - 城市
    Photo(
      id: '27',
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&q=80',
      title: '高楼林立',
      description: '一栋栋高楼拔地而起。',
      authorName: 'Tower',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 334,
      category: '城市',
    ),
    
    // 28. Fashion - 人像
    Photo(
      id: '28',
      imageUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=400&q=80',
      title: '街头时尚',
      description: '街头时尚的态度。',
      authorName: 'Fashion',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 345,
      category: '人像',
    ),
    
    // 29. Sunset - 风景
    Photo(
      id: '29',
      imageUrl: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400&q=80',
      title: '日落余晖',
      description: '夕阳西下，天边被染成了橙红色。',
      authorName: 'Sunset',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 512,
      category: '风景',
    ),
    
    // 30. Neon - 城市
    Photo(
      id: '30',
      imageUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=400&q=80',
      title: '霓虹灯光',
      description: '夜晚的霓虹灯光将城市装点得如梦似幻。',
      authorName: 'Neon',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 412,
      category: '城市',
    ),
  ];

  // 最新照片列表
  static final List<Photo> _latestPhotos = [
    Photo(
      id: 'new1',
      imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&q=80',
      title: '星空银河',
      description: '星空银河璀璨夺目。',
      authorName: '极地探险',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 892,
      category: '风景',
    ),
    Photo(
      id: 'new2',
      imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400&q=80',
      title: '霓虹夜景',
      description: '霓虹夜景璀璨迷人。',
      authorName: '城市猎人',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 756,
      category: '城市',
    ),
    Photo(
      id: 'new3',
      imageUrl: 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400&q=80',
      title: '优雅女士',
      description: '优雅女士的气质。',
      authorName: '时光记录者',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 634,
      category: '人像',
    ),
    Photo(
      id: 'new4',
      imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80',
      title: '雪山之巅',
      description: '雪山之巅的壮丽景色。',
      authorName: '登山者',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 923,
      category: '风景',
    ),
    Photo(
      id: 'new5',
      imageUrl: 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=400&q=80',
      title: '现代都市',
      description: '现代都市的繁华景象。',
      authorName: '都市摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 812,
      category: '城市',
    ),
    Photo(
      id: 'new6',
      imageUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&q=80',
      title: '街头时尚',
      description: '街头时尚的魅力。',
      authorName: 'Fashion Studio',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 701,
      category: '人像',
    ),
  ];

  static final FeaturedPhoto _featuredPhoto = FeaturedPhoto(
    id: 'featured',
    imageUrl: 'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?w=800&q=80',
    title: '2026色彩配方',
    description: '2026色彩配方',
    authorName: 'Lin.Photography',
    authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
    likes: 512,
  );

  static final List<Topic> _topics = [
    Topic(id: '1', name: '城市折叠', isHot: true),
    Topic(id: '2', name: '胶片复兴', isHot: false),
    Topic(id: '3', name: '街头瞬间', isHot: false),
    Topic(id: '4', name: '人像摄影', isHot: true),
    Topic(id: '5', name: '风光大片', isHot: false),
    Topic(id: '6', name: '微距世界', isHot: false),
  ];

  static final User _currentUser = User(
    id: 'user1',
    name: '晚风与猫',
    bio: '「用镜头记录温柔的瞬间」',
    avatar: 'assets/images/tx.jpg',
    likes: 1200,
    followers: 856,
    following: 128,
  );

  static final List<Photo> _favPhotos = [
    Photo(
      id: 'f1',
      imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
    Photo(
      id: 'f2',
      imageUrl: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
    Photo(
      id: 'f3',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
    Photo(
      id: 'f4',
      imageUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
  ];

  static FeaturedPhoto getFeaturedPhoto() => _featuredPhoto;

  static List<Topic> getTopics() => _topics;

  static List<Photo> getAllPhotos() => _allPhotos;

  static List<Photo> getLatestPhotos() => _latestPhotos;

  static List<Photo> getPhotosByCategory(String category) {
    if (category == '热门') {
      final shuffled = List<Photo>.from(_allPhotos);
      shuffled.shuffle();
      return shuffled;
    }
    return _allPhotos.where((photo) => photo.category == category).toList();
  }

  static User getCurrentUser() => _currentUser;

  static List<Photo> getFavPhotos() => _favPhotos;

  static Photo getPhotoById(String id) {
    return _allPhotos.firstWhere((photo) => photo.id == id, orElse: () => _allPhotos[0]);
  }

  // 博文数据
  static final List<Article> _articles = [
    Article(
      id: 'a1',
      title: '视听语言｜一篇看懂常用光位',
      coverImage: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=800&q=80',
      authorName: '摄影学院',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      views: 2345,
      likes: 456,
      publishDate: '2026-05-01',
      content: '光位是摄影中最重要的元素之一...',
    ),
  ];

  static List<Article> getArticles() => _articles;
}
