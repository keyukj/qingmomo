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
      authorAvatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&q=80',
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
      description: '海风吹拂着长发,少女静静地望着远方的海平线。',
      authorName: 'Miao',
      authorAvatar: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?w=100&q=80',
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
      authorAvatar: 'https://images.unsplash.com/photo-1477346611705-65d1883cee1e?w=100&q=80',
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
    
    // 为主要用户添加更多照片
    // 阿飞的第2张
    Photo(
      id: '31',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      title: '田野风光',
      description: '金黄的麦田在微风中摇曳。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&q=80',
      likes: 178,
      category: '风景',
    ),
    // 阿飞的第3张
    Photo(
      id: '32',
      imageUrl: 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=400&q=80',
      title: '山谷云海',
      description: '山谷中的云海翻腾。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&q=80',
      likes: 467,
      category: '风景',
    ),
    
    // DesignX的第2张
    Photo(
      id: '33',
      imageUrl: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400&q=80',
      title: '建筑美学',
      description: '建筑不仅是居住的空间，更是艺术的载体。',
      authorName: 'DesignX',
      authorAvatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&q=80',
      likes: 423,
      category: '城市',
    ),
    // DesignX的第3张
    Photo(
      id: '34',
      imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400&q=80',
      title: '高楼耸立',
      description: '一栋栋高楼拔地而起，在夕阳的映照下格外壮观。',
      authorName: 'DesignX',
      authorAvatar: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&q=80',
      likes: 456,
      category: '城市',
    ),
    
    // Yuki的第2张
    Photo(
      id: '35',
      imageUrl: 'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=400&q=80',
      title: '伦敦街景',
      description: '红色电话亭、双层巴士，这些经典元素构成了伦敦独特的城市风景。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 356,
      category: '城市',
    ),
    // Yuki的第3张
    Photo(
      id: '36',
      imageUrl: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400&q=80',
      title: '街头艺术',
      description: '城市街头弥漫着浓厚的艺术气息。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 298,
      category: '城市',
    ),
    
    // Miao的第2张
    Photo(
      id: '37',
      imageUrl: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400&q=80',
      title: '夏日微风',
      description: '夏日微风轻拂。',
      authorName: 'Miao',
      authorAvatar: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=100&q=80',
      likes: 123,
      category: '人像',
    ),
    
    // Nature的第2张
    Photo(
      id: '38',
      imageUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
      title: '秋色满园',
      description: '秋天的色彩斑斓迷人。',
      authorName: 'Nature',
      authorAvatar: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=100&q=80',
      likes: 267,
      category: '风景',
    ),
    
    // 小林的第2张
    Photo(
      id: '39',
      imageUrl: 'https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=400&q=80',
      title: '温柔时光',
      description: '记录温柔的每一刻。',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    
    // 张摄影的第2张
    Photo(
      id: '40',
      imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&q=80',
      title: '清新风格',
      description: '清新自然的拍摄风格。',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&q=80',
      likes: 312,
      category: '人像',
    ),
    
    // Emma的第2张
    Photo(
      id: '41',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80',
      title: '光影之美',
      description: '捕捉光影的美好。',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=100&q=80',
      likes: 245,
      category: '人像',
    ),
  ];

  // 最新照片列表 - 使用完全不同且不重复的图片
  static final List<Photo> _latestPhotos = [
    Photo(
      id: 'new1',
      imageUrl: 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400&q=80',
      title: '晨雾弥漫',
      description: '清晨的雾气笼罩着整个山谷，如梦似幻。',
      authorName: '雾里看花',
      authorAvatar: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=100&q=80',
      likes: 892,
      category: '风景',
    ),
    Photo(
      id: 'new2',
      imageUrl: 'https://images.unsplash.com/photo-1477346611705-65d1883cee1e?w=400&q=80',
      title: '日出时分',
      description: '清晨的第一缕阳光穿透云层。',
      authorName: '晨光摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=100&q=80',
      likes: 756,
      category: '风景',
    ),
    Photo(
      id: 'new3',
      imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=400&q=80',
      title: '冰川奇观',
      description: '冰川的壮丽景色令人震撼。',
      authorName: '冰雪世界',
      authorAvatar: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=100&q=80',
      likes: 634,
      category: '风景',
    ),
    Photo(
      id: 'new4',
      imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400&q=80',
      title: '海岸线',
      description: '蜿蜒的海岸线风光无限。',
      authorName: '海洋之心',
      authorAvatar: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=100&q=80',
      likes: 923,
      category: '风景',
    ),
    Photo(
      id: 'new5',
      imageUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&q=80',
      title: '极光之夜',
      description: '北极光的绚丽色彩舞动天际。',
      authorName: '极光追寻者',
      authorAvatar: 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=100&q=80',
      likes: 812,
      category: '风景',
    ),
    Photo(
      id: 'new6',
      imageUrl: 'https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=400&q=80',
      title: '湖光山色',
      description: '宁静的湖泊倒映着远山和蓝天。',
      authorName: '湖畔诗人',
      authorAvatar: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=100&q=80',
      likes: 701,
      category: '风景',
    ),
    Photo(
      id: 'new7',
      imageUrl: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400&q=80',
      title: '秋日森林',
      description: '金黄色的秋天森林层林尽染。',
      authorName: '秋意浓',
      authorAvatar: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=100&q=80',
      likes: 678,
      category: '风景',
    ),
    Photo(
      id: 'new8',
      imageUrl: 'https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=400&q=80',
      title: '沙漠之旅',
      description: '沙漠中的日落美景如画。',
      authorName: '沙漠行者',
      authorAvatar: 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=100&q=80',
      likes: 845,
      category: '风景',
    ),
    Photo(
      id: 'new9',
      imageUrl: 'https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?w=400&q=80',
      title: '瀑布飞流',
      description: '壮观的瀑布从高处倾泻而下。',
      authorName: '水之韵',
      authorAvatar: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=100&q=80',
      likes: 567,
      category: '风景',
    ),
    Photo(
      id: 'new10',
      imageUrl: 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=400&q=80',
      title: '星轨之美',
      description: '夜空中的星轨划过天际。',
      authorName: '星空摄手',
      authorAvatar: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=100&q=80',
      likes: 789,
      category: '风景',
    ),
    Photo(
      id: 'new11',
      imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=400&q=80',
      title: '田园风光',
      description: '宁静的田园景色让人心旷神怡。',
      authorName: '田园牧歌',
      authorAvatar: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=100&q=80',
      likes: 934,
      category: '风景',
    ),
    Photo(
      id: 'new12',
      imageUrl: 'https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5?w=400&q=80',
      title: '雪山之巅',
      description: '白雪皑皑的山峰直插云霄。',
      authorName: '雪域高原',
      authorAvatar: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&q=80',
      likes: 823,
      category: '风景',
    ),
    Photo(
      id: 'new13',
      imageUrl: 'https://images.unsplash.com/photo-1506260408121-e353d10b87c7?w=400&q=80',
      title: '峡谷风光',
      description: '深邃的峡谷景色令人叹为观止。',
      authorName: '峡谷探险',
      authorAvatar: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=100&q=80',
      likes: 712,
      category: '风景',
    ),
    Photo(
      id: 'new14',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      title: '山峦叠嶂',
      description: '层层叠叠的山峦绵延不绝。',
      authorName: '山野行者',
      authorAvatar: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=100&q=80',
      likes: 645,
      category: '风景',
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
    likes: 89,
    followers: 7,
    following: 5,
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
      content: '''光位是摄影中最重要的元素之一，它决定了画面的明暗、层次和氛围。

一、顺光
顺光是指光源在摄影师身后，直接照射在被摄主体上。这种光位下，主体受光均匀，色彩饱和度高，但缺乏立体感和层次感。适合拍摄色彩鲜艳的场景。

顺光的优点是曝光容易控制，画面明亮清晰，色彩还原准确。但缺点是画面较为平淡，缺少明暗对比，不利于表现主体的质感和立体感。在拍摄风景时，顺光可以很好地展现天空的蓝色和植物的绿色。

二、侧光
侧光从主体的侧面照射，能够产生明显的明暗对比，增强画面的立体感和质感。侧光是人像摄影中最常用的光位之一，能够很好地表现人物的轮廓和面部结构。

45度侧光被认为是最理想的人像光位，它既能保证面部有足够的亮度，又能产生适度的阴影，使五官更加立体。在拍摄静物时，侧光能够很好地表现物体的质感和纹理。

三、逆光
逆光是指光源在被摄主体的后方，这种光位能够产生剪影效果或者美丽的轮廓光。逆光拍摄需要注意曝光控制，可以营造出梦幻、温暖的氛围。

逆光拍摄时，可以选择对主体进行补光，保留面部细节；也可以完全剪影，突出主体的轮廓。在日出日落时分，逆光能够为人物镀上一层金色的光晕，非常适合拍摄情绪化的人像作品。

四、顶光
顶光从主体的正上方照射，会在人物面部产生较重的阴影，一般不适合人像摄影。但在某些创意拍摄中，顶光可以营造出特殊的戏剧效果。

正午时分的阳光就是典型的顶光，这个时候拍摄人像会在眼窝、鼻子下方产生很重的阴影。但如果利用得当，顶光可以营造出神秘、戏剧化的效果，适合拍摄时尚大片。

五、底光
底光从下方照射主体，会产生不自然的效果，常用于恐怖片或特殊创意拍摄。

在日常摄影中很少使用底光，因为它违背了自然光的规律。但在舞台摄影、创意人像中，底光可以营造出独特的视觉效果。

六、实战技巧
在实际拍摄中，我们往往需要根据拍摄主题和想要表达的情绪来选择合适的光位。人像摄影多用侧光和逆光，风景摄影可以尝试顺光和侧光，静物摄影则侧光最为常用。

掌握这些基本光位，能够帮助你在不同场景下做出正确的拍摄选择，拍出更有层次感和表现力的作品。''',
    ),
    Article(
      id: 'a2',
      title: '风光摄影｜如何拍出震撼的山景',
      coverImage: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
      authorName: '山野摄影师',
      authorAvatar: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=100&q=80',
      views: 3456,
      likes: 678,
      publishDate: '2026-05-03',
      content: '''山景摄影需要掌握构图、光线和时机，才能拍出震撼人心的作品。

一、选择合适的时间
清晨和傍晚是拍摄山景的黄金时间，此时的光线柔和，色温偏暖，能够营造出梦幻的氛围。日出日落时分，天空的色彩变化丰富，是拍摄大片的最佳时机。

清晨4-6点，当第一缕阳光照射在山峰上时，会产生美丽的"日照金山"效果。这个时候的光线角度低，能够很好地表现山体的层次和纹理。傍晚时分，夕阳的余晖会将整个山峦染成金黄色或橙红色，非常壮观。

二、构图技巧
使用前景增强画面的纵深感，可以选择岩石、树木或者花草作为前景元素。利用引导线将观众的视线引向远山，增强画面的空间感。

三分法构图是最常用的方法，将地平线放在画面的三分之一处，可以让画面更加平衡。如果天空很精彩，可以让天空占据画面的三分之二；如果前景很有趣，则让前景占据更多空间。

三、使用滤镜
偏振镜可以消除反光，增强天空和云层的对比度。中灰渐变镜能够平衡天空和地面的曝光差异，保留更多的细节。

偏振镜在拍摄山景时非常重要，它可以让天空更蓝，云层更白，消除水面和树叶的反光。中灰渐变镜则可以压暗过亮的天空，让地面和天空的曝光更加均衡，避免天空过曝或地面欠曝。

四、注意天气
云雾缭绕的山景别有一番韵味，可以营造出仙境般的效果。雨后初晴时，空气通透，能见度高，是拍摄远山的好时机。

云海是山景摄影中最受欢迎的题材之一，通常出现在清晨或雨后。云海翻腾的景象非常壮观，配合日出的光线，能够拍出令人震撼的作品。

五、后期处理
适当提高对比度和饱和度，增强画面的视觉冲击力。注意不要过度处理，保持画面的自然感。

在后期处理时，可以使用曲线工具调整明暗层次，使用HSL工具调整色彩。适当锐化可以增强山体的细节，但要注意不要过度锐化导致画面不自然。

六、器材建议
广角镜头是拍摄山景的首选，可以拍摄更广阔的场景。长焦镜头则可以压缩空间，突出远山的层次感。三脚架是必备工具，可以保证画面的清晰度。''',
    ),
    Article(
      id: 'a3',
      title: '人像摄影｜自然光的运用技巧',
      coverImage: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800&q=80',
      authorName: '人像大师',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      views: 4567,
      likes: 892,
      publishDate: '2026-05-04',
      content: '''自然光是人像摄影中最美的光源，掌握自然光的运用技巧，能够拍出自然生动的人像作品。

一、窗户光
窗户光是室内人像摄影的最佳光源，柔和而有方向性。让模特靠近窗户，光线从侧面照射，能够营造出柔美的效果。可以使用白色反光板补光，减少阴影。

窗户光的特点是柔和、有方向性，非常适合拍摄情绪化的人像。可以让模特坐在窗边，利用窗帘调节光线的强度。如果光线太强，可以使用白色纱帘柔化光线；如果光线太弱，可以完全拉开窗帘。

二、黄金时刻
日出后和日落前的一小时被称为黄金时刻，此时的光线温暖柔和，非常适合拍摄人像。光线从低角度照射，能够为人物镀上一层金色的光晕。

黄金时刻的光线色温在3000-4000K之间，呈现出温暖的金黄色。这个时候拍摄人像，肤色会显得特别好看，整个画面充满温暖的氛围。逆光拍摄时，头发会被镀上一层金边，非常梦幻。

三、阴天拍摄
阴天的光线均匀柔和，没有强烈的阴影，非常适合拍摄人像。这种光线下，人物的肤色自然，细节丰富。

阴天时，整个天空就像一个巨大的柔光箱，光线从四面八方照射过来，非常柔和。这种光线下拍摄人像，不会有强烈的阴影，肤色自然，非常适合拍摄清新自然的人像作品。

四、逆光人像
逆光能够为人物勾勒出美丽的轮廓光，营造出梦幻的氛围。拍摄时注意对人物面部进行补光，或者使用点测光对面部测光。

逆光人像是最受欢迎的拍摄手法之一，可以营造出温暖、梦幻的氛围。拍摄时可以让模特背对太阳，光线会在头发边缘形成美丽的光晕。为了避免面部过暗，可以使用反光板补光，或者适当增加曝光补偿。

五、树荫下
在强烈的阳光下，可以选择在树荫下拍摄。树叶过滤后的光线柔和，能够在人物身上形成斑驳的光影效果。

树荫下的光线经过树叶的过滤，变得柔和而有趣。阳光透过树叶的缝隙，会在人物身上形成斑驳的光影，非常有艺术感。这种光线下拍摄，要注意避免脸上的光斑过于杂乱。

六、注意事项
拍摄人像时，要注意观察光线的方向和质感。柔和的光线适合表现女性的柔美，硬朗的光线适合表现男性的阳刚。根据拍摄主题选择合适的光线，能够让作品更有表现力。''',
    ),
    Article(
      id: 'a4',
      title: '城市夜景｜长曝光拍摄指南',
      coverImage: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=800&q=80',
      authorName: '夜景猎人',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      views: 2890,
      likes: 534,
      publishDate: '2026-05-05',
      content: '''城市夜景拍摄需要使用三脚架和长曝光技术，才能拍出璀璨迷人的夜景照片。

一、必备器材
稳固的三脚架是夜景拍摄的必备工具，能够保证长时间曝光时相机的稳定。快门线或遥控器可以避免按快门时产生的震动。

二、曝光设置
使用M档手动模式，ISO设置为100-400，光圈F8-F11，快门速度根据现场光线调整，通常在10-30秒之间。拍摄车流轨迹时，可以使用更长的曝光时间。

三、对焦技巧
夜景拍摄时，自动对焦可能会失效。建议使用手动对焦，在实时取景模式下放大画面进行精确对焦。

四、拍摄时机
蓝调时刻是拍摄夜景的最佳时间，此时天空呈现深蓝色，与城市灯光形成美丽的对比。完全天黑后，天空会变成纯黑色，画面会失去层次感。

五、构图建议
寻找有趣的前景元素，如桥梁、建筑或水面倒影。利用城市的线条和光影，营造出富有节奏感的画面。''',
    ),
    Article(
      id: 'a5',
      title: '构图法则｜黄金分割与三分法',
      coverImage: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=800&q=80',
      authorName: '构图专家',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      views: 5678,
      likes: 1023,
      publishDate: '2026-05-06',
      content: '''好的构图是摄影作品成功的关键，掌握基本的构图法则能够大幅提升作品的视觉效果。

一、三分法
将画面横竖各分成三等分，形成九宫格。将主体放置在交叉点上，能够使画面更加平衡和谐。这是最基础也是最实用的构图法则。

二、黄金分割
黄金分割比例约为1:1.618，这个比例在自然界中广泛存在，符合人类的审美习惯。将主体放置在黄金分割点上，画面会显得更加优雅。

三、对称构图
对称构图能够营造出稳定、庄重的感觉，适合拍摄建筑、倒影等题材。完美的对称能够给人以视觉上的愉悦感。

四、引导线
利用道路、河流、栏杆等线条元素，将观众的视线引向主体。引导线能够增强画面的纵深感和空间感。

五、留白
适当的留白能够给画面留出呼吸的空间，使主体更加突出。留白也能够营造出意境和想象空间。''',
    ),
    Article(
      id: 'a6',
      title: '后期处理｜Lightroom调色技巧',
      coverImage: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=800&q=80',
      authorName: '后期大神',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      views: 6789,
      likes: 1234,
      publishDate: '2026-05-07',
      content: '''Lightroom是摄影师必备的后期工具，掌握基本的调色技巧能够让你的照片更上一层楼。

一、基本调整
首先调整曝光、对比度、高光和阴影，确保画面的明暗层次合理。白色和黑色滑块可以进一步调整画面的亮部和暗部细节。

二、色彩调整
通过色温和色调滑块调整画面的整体色调。饱和度和自然饱和度可以增强色彩的鲜艳程度，但要注意不要过度调整。

三、HSL面板
HSL面板可以单独调整每种颜色的色相、饱和度和明度。这是调色的核心工具，能够实现精确的色彩控制。

四、曲线调整
曲线是最强大的调色工具，可以精确控制画面的明暗和色彩。通过调整RGB曲线，可以营造出各种风格的色调。

五、局部调整
使用渐变滤镜和径向滤镜可以对画面的特定区域进行调整。画笔工具可以对更精确的区域进行局部处理。''',
    ),
    Article(
      id: 'a7',
      title: '星空摄影｜拍摄银河的完整教程',
      coverImage: 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=800&q=80',
      authorName: '星空追梦人',
      authorAvatar: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=100&q=80',
      views: 4321,
      likes: 876,
      publishDate: '2026-05-08',
      content: '''拍摄星空需要远离光污染，选择晴朗无月的夜晚，才能拍出璀璨的银河。

一、选择地点和时间
远离城市的光污染，选择海拔较高、空气通透的地方。新月前后是拍摄银河的最佳时间，此时月光不会影响星空的拍摄。

二、器材准备
使用大光圈镜头（F2.8或更大），广角镜头能够拍摄更多的星空。稳固的三脚架和快门线是必备工具。

三、相机设置
使用M档手动模式，光圈开到最大，ISO设置为3200-6400，快门速度根据500法则计算（500除以焦距）。使用手动对焦，对准远处的亮星进行对焦。

四、构图技巧
寻找有趣的前景元素，如山峰、树木或建筑，与星空形成呼应。银河的位置和角度会随季节变化，提前使用星图软件规划拍摄。

五、后期处理
适当提高对比度和清晰度，增强银河的细节。降噪处理可以减少高ISO带来的噪点。''',
    ),
    Article(
      id: 'a8',
      title: '街头摄影｜捕捉城市的瞬间',
      coverImage: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800&q=80',
      authorName: '街头观察者',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      views: 3210,
      likes: 654,
      publishDate: '2026-05-09',
      content: '''街头摄影是记录城市生活的最佳方式，需要敏锐的观察力和快速的反应能力。

一、器材选择
使用轻便的相机和定焦镜头，35mm或50mm焦距最适合街头摄影。轻便的器材能够让你更加灵活，不会引起被摄者的注意。

二、观察与等待
好的街头摄影作品往往来自于耐心的等待。找到一个有趣的场景，等待决定性瞬间的出现。

三、光影的运用
注意观察光线的变化，寻找有趣的光影效果。侧光和逆光能够营造出戏剧性的效果。

四、捕捉情绪
街头摄影不仅是记录场景，更重要的是捕捉人物的情绪和故事。关注人物的表情、动作和互动。

五、尊重与礼貌
街头摄影要尊重被摄者的隐私和感受。如果被发现，可以微笑示意或主动交流。''',
    ),
    Article(
      id: 'a9',
      title: '微距摄影｜探索微观世界',
      coverImage: 'https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=800&q=80',
      authorName: '微观探索者',
      authorAvatar: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=100&q=80',
      views: 2765,
      likes: 543,
      publishDate: '2026-05-10',
      content: '''微距摄影让我们看到肉眼无法察觉的细节，打开了一个全新的视觉世界。

一、器材选择
专业的微距镜头能够提供1:1的放大倍率，100mm焦距的微距镜头最为常用。也可以使用近摄接圈或近摄镜来实现微距拍摄。

二、光线控制
微距摄影对光线要求很高，可以使用环形闪光灯或LED补光灯。自然光拍摄时，选择柔和的散射光。

三、景深控制
微距摄影的景深极浅，需要精确控制对焦点。使用较小的光圈（F11-F16）可以增加景深，但要注意衍射现象。

四、稳定性
使用三脚架和快门线确保相机的稳定。微距拍摄时，轻微的震动都会导致画面模糊。

五、拍摄题材
花卉、昆虫、水滴、纹理等都是很好的微距拍摄题材。注意观察细节，寻找独特的视角。''',
    ),
    Article(
      id: 'a10',
      title: '旅行摄影｜记录旅途中的美好',
      coverImage: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&q=80',
      authorName: '旅行记录者',
      authorAvatar: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=100&q=80',
      views: 5432,
      likes: 987,
      publishDate: '2026-05-11',
      content: '''旅行摄影不仅是记录风景，更是记录心情和故事，留下珍贵的回忆。

一、轻装上阵
旅行摄影要注重器材的便携性，一机两镜（广角+中长焦）的组合最为实用。不要带太多器材，以免影响旅行的体验。

二、讲述故事
好的旅行照片应该能够讲述故事，传达情感。不要只拍摄风景，也要记录旅途中的人物、美食和细节。

三、当地特色
关注当地的文化特色和生活方式，拍摄具有地域特色的场景。市集、街道、建筑都是很好的拍摄题材。

四、光线的选择
清晨和傍晚的光线最美，这个时间段拍摄的照片往往最出彩。中午的强光不适合拍摄，可以寻找阴影处或室内场景。

五、人文关怀
拍摄当地人物时要尊重对方，最好先征得同意。真诚的交流往往能够拍出更自然的照片。''',
    ),
    Article(
      id: 'a11',
      title: '黑白摄影｜光影的艺术',
      coverImage: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800&q=80',
      authorName: '黑白大师',
      authorAvatar: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=100&q=80',
      views: 3987,
      likes: 765,
      publishDate: '2026-05-12',
      content: '''黑白摄影去除了色彩的干扰，让光影成为主角，更能表现画面的情绪和氛围。

一、适合的题材
高对比度的场景、纹理丰富的主体、情绪化的人像都很适合黑白表现。建筑、街头、人文题材在黑白处理后往往更有韵味。

二、光影的运用
黑白摄影更加依赖光影的表现，要特别注意光线的方向和质感。侧光和逆光能够营造出强烈的明暗对比。

三、对比度控制
适当提高对比度能够增强画面的视觉冲击力，但要注意保留高光和阴影的细节。

四、质感表现
黑白照片更能表现物体的质感和纹理。注意观察和捕捉不同材质的表面特征。

五、后期转换
拍摄时使用RAW格式，后期转换为黑白时有更大的调整空间。可以通过调整不同颜色通道来控制黑白的层次。''',
    ),
    Article(
      id: 'a12',
      title: '运动摄影｜定格精彩瞬间',
      coverImage: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800&q=80',
      authorName: '运动摄影师',
      authorAvatar: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&q=80',
      views: 4123,
      likes: 823,
      publishDate: '2026-05-13',
      content: '''运动摄影需要快速的反应和精准的对焦，才能捕捉到精彩的瞬间。

一、快门速度
拍摄运动主体需要使用高速快门，通常在1/500秒以上。对于快速运动的主体，可能需要1/1000秒甚至更快的快门速度。

二、连拍模式
使用连拍模式可以增加捕捉到精彩瞬间的概率。现代相机的高速连拍功能非常强大，可以达到每秒10张以上。

三、对焦技巧
使用连续自动对焦（AF-C）模式，相机会持续追踪运动的主体。选择合适的对焦点或对焦区域，确保主体始终清晰。

四、预判与构图
运动摄影需要预判主体的运动轨迹，提前构图。留出主体运动方向的空间，使画面更加舒展。

五、追随拍摄
使用较慢的快门速度（1/60-1/125秒），相机随主体移动，可以拍出动感的效果。背景会形成运动模糊，而主体保持清晰。''',
    ),
  ];

  static List<Article> getArticles() => _articles;
}
