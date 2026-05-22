import '../models/photo.dart';

class DataService {
  static final List<Photo> _allPhotos = [
    // 交替排列不同用户的照片，避免同一用户的照片连续出现
    Photo(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=400&q=80',
      title: '捕捉一束光，定格时间。',
      description: '清晨的第一缕阳光穿过云层，洒在山间的每一个角落。这一刻，时间仿佛静止，只有光影在诉说着大自然的故事。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 128,
      category: '风景',
    ),
    Photo(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=400&q=80',
      title: '极简几何空间。',
      description: '现代建筑的魅力在于线条与空间的完美结合，简约而不简单，每一个角度都是艺术的呈现。',
      authorName: 'DesignX',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&q=80',
      likes: 56,
      category: '城市',
    ),
    Photo(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=400&q=80',
      title: '雨后的东京街头，霓虹倒影迷离。',
      description: '雨水打湿的街道倒映着五光十色的霓虹灯，这是属于东京的夜晚，繁华而又孤独。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 342,
      category: '城市',
    ),
    Photo(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400&q=80',
      title: '少女与海。',
      description: '海风吹拂着长发，少女静静地望着远方的海平线，思绪随着海浪飘向远方。',
      authorName: 'Miao',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
      likes: 89,
      category: '人像',
    ),
    Photo(
      id: '5',
      imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=400&q=80',
      title: '森林深处',
      description: '走进森林深处，阳光透过树叶洒下斑驳的光影，这里是大自然最原始的模样。',
      authorName: 'Nature',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 234,
      category: '风景',
    ),
    Photo(
      id: 'p1',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
      title: '午后阳光',
      description: '温暖的午后阳光洒在脸上',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 156,
      category: '人像',
    ),
    Photo(
      id: 'afei2',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      title: '云端之上',
      description: '登上山顶，云海在脚下翻腾，这一刻感受到了大自然的壮阔与渺小。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 256,
      category: '风景',
    ),
    Photo(
      id: 'designx2',
      imageUrl: 'https://images.unsplash.com/photo-1485081669829-bacb8c7bb1f3?w=400&q=80',
      title: '光影交错',
      description: '建筑的线条在光影中展现出独特的美感，明暗对比营造出强烈的视觉冲击。',
      authorName: 'DesignX',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&q=80',
      likes: 189,
      category: '城市',
    ),
    Photo(
      id: 'yuki2',
      imageUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=400&q=80',
      title: '东京夜色',
      description: '繁华都市的夜晚灯火通明，霓虹闪烁，这是东京独有的夜晚魅力。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 278,
      category: '城市',
    ),
    Photo(
      id: 'miao2',
      imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&q=80',
      title: '午后时光',
      description: '阳光洒在脸上，温暖而美好。',
      authorName: 'Miao',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
      likes: 156,
      category: '人像',
    ),
    Photo(
      id: 'p2',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&q=80',
      title: '都市女孩',
      description: '现代都市的时尚气息',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    Photo(
      id: 'afei3',
      imageUrl: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&q=80',
      title: '湖光山色',
      description: '平静的湖面如镜，倒映着远山和天空，这是大自然最美的画作。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 189,
      category: '风景',
    ),
    Photo(
      id: 'c1',
      imageUrl: 'https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=400&q=80',
      title: '摩天大楼',
      description: '钢筋水泥构筑的城市森林，每一栋高楼都承载着无数人的梦想与希望，在蓝天白云的映衬下显得格外壮观。',
      authorName: 'Urban',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 423,
      category: '城市',
    ),
    Photo(
      id: 'urban2',
      imageUrl: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=400&q=80',
      title: '都市节奏',
      description: '车水马龙的街道，匆匆而过的行人，这就是城市的快节奏生活，每个人都在追逐着自己的梦想。',
      authorName: 'Urban',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 356,
      category: '城市',
    ),
    Photo(
      id: 'urban3',
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&q=80',
      title: '城市剪影',
      description: '夜幕降临时，城市的轮廓在天际线上勾勒出优美的剪影，灯光点点，如同繁星坠落人间。',
      authorName: 'Urban',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 289,
      category: '城市',
    ),
    Photo(
      id: 'c2',
      imageUrl: 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=400&q=80',
      title: '城市夜景',
      description: '当夜幕降临，城市换上了另一副面孔，灯火通明，车水马龙，这是都市人的不眠之夜，霓虹闪烁间诉说着繁华。',
      authorName: 'Night',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 567,
      category: '城市',
    ),
    Photo(
      id: 'night2',
      imageUrl: 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=400&q=80',
      title: '霓虹闪烁',
      description: '五光十色的霓虹灯在夜晚璀璨夺目，将城市装点得如梦似幻，这是属于夜晚的浪漫与魅力。',
      authorName: 'Night',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 478,
      category: '城市',
    ),
    Photo(
      id: 'night3',
      imageUrl: 'https://images.unsplash.com/photo-1431274172761-fca41d930114?w=400&q=80',
      title: '夜色迷离',
      description: '迷离的夜色中，城市展现出另一种魅力，灯光与夜幕交织，营造出神秘而浪漫的氛围。',
      authorName: 'Night',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 412,
      category: '城市',
    ),
    Photo(
      id: 'c3',
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400&q=80',
      title: '都市天际线',
      description: '站在高处俯瞰城市，天际线勾勒出现代都市的轮廓，这是人类文明的壮丽画卷，每一栋建筑都在诉说着城市的故事。',
      authorName: 'Skyline',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '城市',
    ),
    Photo(
      id: 'skyline2',
      imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400&q=80',
      title: '高楼耸立',
      description: '一栋栋高楼拔地而起，在夕阳的映照下格外壮观，金色的光芒为城市镀上了一层温暖的色彩。',
      authorName: 'Skyline',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 456,
      category: '城市',
    ),
    Photo(
      id: 'skyline3',
      imageUrl: 'https://images.unsplash.com/photo-1444723121867-7a241cacace9?w=400&q=80',
      title: '城市轮廓',
      description: '现代都市的建筑美学在天际线上展现得淋漓尽致，每一个轮廓都是设计师智慧的结晶。',
      authorName: 'Skyline',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 378,
      category: '城市',
    ),
    Photo(
      id: 'c4',
      imageUrl: 'https://images.unsplash.com/photo-1460472178825-e5240623afd5?w=400&q=80',
      title: '街头涂鸦',
      description: '墙面上的涂鸦是街头艺术家的宣言，色彩斑斓，充满个性与态度，每一笔都在表达着对生活的热爱。',
      authorName: 'Street',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 234,
      category: '城市',
    ),
    Photo(
      id: 'street2',
      imageUrl: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400&q=80',
      title: '街头艺术',
      description: '城市街头弥漫着浓厚的艺术气息，每一个角落都可能藏着惊喜，这是属于城市的独特魅力。',
      authorName: 'Street',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 298,
      category: '城市',
    ),
    Photo(
      id: 'street3',
      imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400&q=80',
      title: '街景记录',
      description: '用镜头记录城市街头的每一个瞬间，捕捉那些转瞬即逝的美好，这是属于街头摄影的魅力。',
      authorName: 'Street',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 267,
      category: '城市',
    ),
    Photo(
      id: 'c5',
      imageUrl: 'https://images.unsplash.com/photo-1486299267070-83823f5448dd?w=400&q=80',
      title: '现代建筑',
      description: '玻璃幕墙反射着天空的颜色，现代建筑以其独特的造型诠释着时代的美学，线条流畅，充满未来感。',
      authorName: 'Modern',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 312,
      category: '城市',
    ),
    Photo(
      id: 'modern2',
      imageUrl: 'https://images.unsplash.com/photo-1496568816309-51d7c20e3b21?w=400&q=80',
      title: '建筑线条',
      description: '现代建筑的几何美学在简洁的线条中展现，每一个角度都经过精心设计，体现着建筑师的匠心。',
      authorName: 'Modern',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 389,
      category: '城市',
    ),
    Photo(
      id: 'modern3',
      imageUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=400&q=80',
      title: '建筑之美',
      description: '现代建筑的独特魅力在于它将艺术与功能完美结合，每一个细节都彰显着设计的力量。',
      authorName: 'Modern',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 423,
      category: '城市',
    ),
    Photo(
      id: 'c6',
      imageUrl: 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=400&q=80',
      title: '地铁站台',
      description: '地铁站台上人来人往，每个人都在赶往自己的目的地，这是城市的脉搏，永不停歇地跳动着。',
      authorName: 'Metro',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 198,
      category: '城市',
    ),
    Photo(
      id: 'c7',
      imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400&q=80',
      title: '伦敦大桥',
      description: '泰晤士河上的伦敦大桥见证了这座城市的历史变迁，古典与现代在此交融，诉说着岁月的故事。',
      authorName: 'London',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 445,
      category: '城市',
    ),
    Photo(
      id: 'c8',
      imageUrl: 'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=400&q=80',
      title: '伦敦街景',
      description: '红色电话亭、双层巴士，这些经典元素构成了伦敦独特的城市风景，充满了英伦风情与历史韵味。',
      authorName: 'UK',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 356,
      category: '城市',
    ),
    Photo(
      id: 'c9',
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400&q=80',
      title: '巴黎铁塔',
      description: '埃菲尔铁塔是巴黎的象征，无论白天还是夜晚，它都散发着浪漫的气息，吸引着世界各地的游客。',
      authorName: 'Paris',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 678,
      category: '城市',
    ),
    Photo(
      id: 'c10',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80',
      title: '繁华商业街',
      description: '商业街上人潮涌动，橱窗里陈列着琳琅满目的商品，这是消费时代的缩影，也是城市活力的体现。',
      authorName: 'Shopping',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 289,
      category: '城市',
    ),
    Photo(
      id: 'c11',
      imageUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=400&q=80',
      title: '霓虹灯光',
      description: '夜晚的霓虹灯光将城市装点得如梦似幻，这是属于夜猫子的狂欢时刻，五彩斑斓的光影交织成迷人的画面。',
      authorName: 'Neon',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 412,
      category: '城市',
    ),
    Photo(
      id: 'c12',
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&q=80',
      title: '高楼林立',
      description: '一栋栋高楼拔地而起，它们是城市发展的见证，也是人类智慧的结晶，在天空的映衬下显得格外雄伟。',
      authorName: 'Tower',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 334,
      category: '城市',
    ),
    Photo(
      id: 'c13',
      imageUrl: 'https://images.unsplash.com/photo-1519331379826-f10be5486c6f?w=400&q=80',
      title: '城市公园',
      description: '钢筋水泥中的一片绿洲，城市公园为忙碌的人们提供了片刻的宁静与放松，是都市中难得的休憩之地。',
      authorName: 'Park',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 267,
      category: '城市',
    ),
    Photo(
      id: 'c14',
      imageUrl: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400&q=80',
      title: '都市黄昏',
      description: '黄昏时分，夕阳为城市镀上一层金色，这是一天中最温柔的时刻，天空与建筑交相辉映。',
      authorName: 'Dusk',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 498,
      category: '城市',
    ),
    Photo(
      id: 'c15',
      imageUrl: 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=400&q=80',
      title: '摩登都市',
      description: '现代化的都市景观展现着科技与设计的完美融合，这是21世纪的城市面貌，充满了未来感与科技感。',
      authorName: 'Metro',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 378,
      category: '城市',
    ),
    Photo(
      id: 'c16',
      imageUrl: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400&q=80',
      title: '建筑美学',
      description: '建筑不仅是居住的空间，更是艺术的载体，每一个设计都蕴含着美学的思考，展现着人类的创造力。',
      authorName: 'Architecture',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 423,
      category: '城市',
    ),
    Photo(
      id: 'c17',
      imageUrl: 'https://images.unsplash.com/photo-1485081669829-bacb8c7bb1f3?w=400&q=80',
      title: '地下通道',
      description: '地下通道连接着城市的各个角落，在这里，每个人都在匆匆赶路，这是城市交通网络的重要组成部分。',
      authorName: 'Underground',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 189,
      category: '城市',
    ),
    Photo(
      id: 'c18',
      imageUrl: 'https://images.unsplash.com/photo-1486299267070-83823f5448dd?w=400&q=80',
      title: '桥梁之美',
      description: '桥梁跨越河流，连接两岸，它不仅是交通要道，更是工程美学的杰作，展现着人类征服自然的智慧。',
      authorName: 'Bridge',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 356,
      category: '城市',
    ),
    Photo(
      id: 'designx3',
      imageUrl: 'https://images.unsplash.com/photo-1444723121867-7a241cacace9?w=400&q=80',
      title: '都市建筑',
      description: '现代都市的建筑美学在光影中展现，简洁的线条与宏伟的结构完美结合。',
      authorName: 'DesignX',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&q=80',
      likes: 234,
      category: '城市',
    ),
    Photo(
      id: 'yuki3',
      imageUrl: 'https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=400&q=80',
      title: '城市印象',
      description: '用镜头记录城市的每一个瞬间，捕捉那些独特的城市印象与美好回忆。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 312,
      category: '城市',
    ),
    Photo(
      id: 'miao3',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80',
      title: '都市女孩',
      description: '记录生活中的美好瞬间。',
      authorName: 'Miao',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    Photo(
      id: 'afei4',
      imageUrl: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400&q=80',
      title: '日落时分',
      description: '夕阳将天空染成金色，这是一天中最温柔的时刻。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 342,
      category: '风景',
    ),
    Photo(
      id: 'yuki4',
      imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400&q=80',
      title: '夜幕降临',
      description: '当夜幕降临，城市在夜色中苏醒，灯光逐渐点亮，开启了属于夜晚的精彩。',
      authorName: 'Yuki',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 198,
      category: '城市',
    ),
    Photo(
      id: 'xiaolin2',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80',
      title: '温柔时光',
      description: '记录温柔的每一刻',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    Photo(
      id: 'afei5',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80',
      title: '森林秘境',
      description: '阳光穿过树叶的缝隙，在林间洒下斑驳的光影。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 234,
      category: '风景',
    ),
    Photo(
      id: 'zhang2',
      imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&q=80',
      title: '清新风格',
      description: '清新自然的拍摄风格',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 312,
      category: '人像',
    ),
    Photo(
      id: 'afei6',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      title: '田野风光',
      description: '金黄的麦田在微风中摇曳，这是丰收的季节。',
      authorName: '阿飞',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 178,
      category: '风景',
    ),
    Photo(
      id: 'p3',
      imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&q=80',
      title: '自然光影',
      description: '光影交错的艺术',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 189,
      category: '人像',
    ),
    Photo(
      id: 'nature2',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80',
      title: '林间小路',
      description: '蜿蜒的小路通向森林深处。',
      authorName: 'Nature',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 189,
      category: '风景',
    ),
    Photo(
      id: 'xiaolin3',
      imageUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&q=80',
      title: '自然美',
      description: '自然光下的美好瞬间',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 189,
      category: '人像',
    ),
    Photo(
      id: '6',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      title: '山间晨雾',
      description: '清晨的山间云雾缭绕，如同仙境一般，让人忘却尘世的烦恼。',
      authorName: 'Mountain',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 167,
      category: '风景',
    ),
    Photo(
      id: 'emma2',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80',
      title: '光影之美',
      description: '捕捉光影的美好',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 245,
      category: '人像',
    ),
    Photo(
      id: 'nature3',
      imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=400&q=80',
      title: '绿意盎然',
      description: '大自然的绿色生机。',
      authorName: 'Nature',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 267,
      category: '风景',
    ),
    Photo(
      id: 'zhang3',
      imageUrl: 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=400&q=80',
      title: '人像摄影',
      description: '专业的人像摄影作品',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 267,
      category: '人像',
    ),
    Photo(
      id: 'mountain2',
      imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80',
      title: '山峰连绵',
      description: '连绵的山峰在云雾中若隐若现。',
      authorName: 'Mountain',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 312,
      category: '风景',
    ),
    Photo(
      id: 'emma3',
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&q=80',
      title: '优雅姿态',
      description: '优雅的姿态展现',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 298,
      category: '人像',
    ),
    Photo(
      id: 'mountain3',
      imageUrl: 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400&q=80',
      title: '登山之路',
      description: '通往山顶的蜿蜒小路。',
      authorName: 'Mountain',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 234,
      category: '风景',
    ),
    Photo(
      id: 'p4',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80',
      title: '微笑瞬间',
      description: '捕捉最美的微笑',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 298,
      category: '人像',
    ),
    Photo(
      id: '7',
      imageUrl: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=400&q=80',
      title: '秋日森林',
      description: '秋天的森林层林尽染，金黄、橙红、深绿交织成一幅绚丽的画卷。',
      authorName: 'Autumn',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 198,
      category: '风景',
    ),
    Photo(
      id: 'awen2',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80',
      title: '真实记录',
      description: '真实自然的记录',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 356,
      category: '人像',
    ),
    Photo(
      id: 'autumn2',
      imageUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
      title: '秋色满园',
      description: '秋天的色彩斑斓迷人。',
      authorName: 'Autumn',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 267,
      category: '风景',
    ),
    Photo(
      id: 'awen3',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80',
      title: '自然表情',
      description: '最自然的表情流露',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 278,
      category: '人像',
    ),
    Photo(
      id: 'autumn3',
      imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=400&q=80',
      title: '秋叶飘零',
      description: '秋天的落叶铺满大地。',
      authorName: 'Autumn',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 234,
      category: '风景',
    ),
    Photo(
      id: 'p5',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
      title: '清新少女',
      description: '清新少女的气质',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 412,
      category: '人像',
    ),
    Photo(
      id: '8',
      imageUrl: 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=400&q=80',
      title: '星空下的帐篷',
      description: '夜晚在野外扎营，抬头便是满天繁星，这是城市里永远看不到的美景。',
      authorName: 'Star',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 276,
      category: '风景',
    ),
    Photo(
      id: 'lily2',
      imageUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&q=80',
      title: '少女情怀',
      description: '少女的纯真情怀',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '人像',
    ),
    Photo(
      id: 'star2',
      imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&q=80',
      title: '银河璀璨',
      description: '夜空中的银河如梦似幻。',
      authorName: 'Star',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 512,
      category: '风景',
    ),
    Photo(
      id: 'lily3',
      imageUrl: 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400&q=80',
      title: '纯真笑容',
      description: '纯真的笑容最美',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 456,
      category: '人像',
    ),
    Photo(
      id: 'star3',
      imageUrl: 'https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=400&q=80',
      title: '星夜露营',
      description: '在星空下度过美好的夜晚，帐篷里的灯光与星光交相辉映。',
      authorName: 'Star',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 389,
      category: '风景',
    ),
    Photo(
      id: 'l1',
      imageUrl: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=400&q=80',
      title: '雪山之巅',
      description: '站在雪山之巅，脚下是云海翻腾，眼前是无尽的壮丽景色，这是征服者的荣耀。',
      authorName: 'Mountain',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 445,
      category: '风景',
    ),
    Photo(
      id: 'l2',
      imageUrl: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&q=80',
      title: '湖光山色',
      description: '平静的湖面倒映着远山的轮廓，湖光山色相映成趣，美不胜收。',
      authorName: 'Lake',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 356,
      category: '风景',
    ),
    Photo(
      id: 'lake2',
      imageUrl: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400&q=80',
      title: '湖面倒影',
      description: '湖水如镜，倒映着天空。',
      authorName: 'Lake',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 423,
      category: '风景',
    ),
    Photo(
      id: 'lake3',
      imageUrl: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400&q=80',
      title: '湖畔风光',
      description: '湖边的宁静时光。',
      authorName: 'Lake',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '风景',
    ),
    Photo(
      id: 'l3',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80',
      title: '森林小径',
      description: '蜿蜒的小径通向森林深处，不知道尽头会有怎样的风景在等待着探索者。',
      authorName: 'Forest',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 289,
      category: '风景',
    ),
    Photo(
      id: 'forest2',
      imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=400&q=80',
      title: '森林秘境',
      description: '探索森林的神秘角落。',
      authorName: 'Forest',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 345,
      category: '风景',
    ),
    Photo(
      id: 'forest3',
      imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=400&q=80',
      title: '林间光影',
      description: '阳光穿过树叶的缝隙。',
      authorName: 'Forest',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 312,
      category: '风景',
    ),
    Photo(
      id: 'l4',
      imageUrl: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400&q=80',
      title: '日落余晖',
      description: '夕阳西下，天边被染成了橙红色，这是大自然赠予我们的最美礼物。',
      authorName: 'Sunset',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 512,
      category: '风景',
    ),
    Photo(
      id: 'sunset2',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      title: '黄昏时刻',
      description: '黄昏的温柔色彩。',
      authorName: 'Sunset',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 478,
      category: '风景',
    ),
    Photo(
      id: 'sunset3',
      imageUrl: 'https://images.unsplash.com/photo-1495567720989-cebdbdd97913?w=400&q=80',
      title: '夕阳无限好',
      description: '记录最美的日落瞬间。',
      authorName: 'Sunset',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 567,
      category: '风景',
    ),
    Photo(
      id: 'l5',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      title: '田园风光',
      description: '田园风光',
      authorName: 'Rural',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 234,
      category: '风景',
    ),
    Photo(
      id: 'l6',
      imageUrl: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400&q=80',
      title: '海岸线',
      description: '海岸线',
      authorName: 'Coast',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 398,
      category: '风景',
    ),
    Photo(
      id: 'l7',
      imageUrl: 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=400&q=80',
      title: '山谷云海',
      description: '山谷云海',
      authorName: 'Valley',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 467,
      category: '风景',
    ),
    Photo(
      id: 'l8',
      imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400&q=80',
      title: '沙漠之旅',
      description: '沙漠之旅',
      authorName: 'Desert',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 312,
      category: '风景',
    ),
    Photo(
      id: 'l9',
      imageUrl: 'https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?w=400&q=80',
      title: '瀑布奇观',
      description: '瀑布奇观',
      authorName: 'Waterfall',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 423,
      category: '风景',
    ),
    Photo(
      id: 'l10',
      imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80',
      title: '高山草甸',
      description: '高山草甸',
      authorName: 'Meadow',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 278,
      category: '风景',
    ),
    Photo(
      id: 'l11',
      imageUrl: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400&q=80',
      title: '湖泊倒影',
      description: '湖泊倒影',
      authorName: 'Reflection',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 389,
      category: '风景',
    ),
    Photo(
      id: 'l12',
      imageUrl: 'https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?w=400&q=80',
      title: '冰川世界',
      description: '冰川世界',
      authorName: 'Glacier',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 501,
      category: '风景',
    ),
    Photo(
      id: 'l13',
      imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=400&q=80',
      title: '竹林幽径',
      description: '竹林幽径',
      authorName: 'Bamboo',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 267,
      category: '风景',
    ),
    Photo(
      id: 'l14',
      imageUrl: 'https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5?w=400&q=80',
      title: '峡谷风光',
      description: '峡谷风光',
      authorName: 'Canyon',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 345,
      category: '风景',
    ),
    Photo(
      id: 'l15',
      imageUrl: 'https://images.unsplash.com/photo-1495567720989-cebdbdd97913?w=400&q=80',
      title: '晨曦初露',
      description: '晨曦初露',
      authorName: 'Dawn',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 412,
      category: '风景',
    ),
    Photo(
      id: 'l16',
      imageUrl: 'https://images.unsplash.com/photo-1511884642898-4c92249e20b6?w=400&q=80',
      title: '火山地貌',
      description: '火山地貌',
      authorName: 'Volcano',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 298,
      category: '风景',
    ),
    // 人像类别 - 20张
    Photo(
      id: 'xiaolin2',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80',
      title: '温柔时光',
      description: '记录温柔的每一刻',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    Photo(
      id: 'xiaolin3',
      imageUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&q=80',
      title: '自然美',
      description: '自然光下的美好瞬间',
      authorName: '小林',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 189,
      category: '人像',
    ),
    Photo(
      id: 'p2',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&q=80',
      title: '都市女孩',
      description: '现代都市的时尚气息',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    Photo(
      id: 'zhang2',
      imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&q=80',
      title: '清新风格',
      description: '清新自然的拍摄风格',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 312,
      category: '人像',
    ),
    Photo(
      id: 'zhang3',
      imageUrl: 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=400&q=80',
      title: '人像摄影',
      description: '专业的人像摄影作品',
      authorName: '张摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 267,
      category: '人像',
    ),
    Photo(
      id: 'p3',
      imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&q=80',
      title: '自然光影',
      description: '光影交错的艺术',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 189,
      category: '人像',
    ),
    Photo(
      id: 'emma2',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80',
      title: '光影之美',
      description: '捕捉光影的美好',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 245,
      category: '人像',
    ),
    Photo(
      id: 'emma3',
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&q=80',
      title: '优雅姿态',
      description: '优雅的姿态展现',
      authorName: 'Emma',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 298,
      category: '人像',
    ),
    Photo(
      id: 'p4',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80',
      title: '微笑瞬间',
      description: '捕捉最美的微笑',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 298,
      category: '人像',
    ),
    Photo(
      id: 'awen2',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80',
      title: '真实记录',
      description: '真实自然的记录',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 356,
      category: '人像',
    ),
    Photo(
      id: 'awen3',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80',
      title: '自然表情',
      description: '最自然的表情流露',
      authorName: '阿文',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 278,
      category: '人像',
    ),
    Photo(
      id: 'p5',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
      title: '清新少女',
      description: '清新少女的气质',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 412,
      category: '人像',
    ),
    Photo(
      id: 'lily2',
      imageUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&q=80',
      title: '少女情怀',
      description: '少女的纯真情怀',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '人像',
    ),
    Photo(
      id: 'lily3',
      imageUrl: 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400&q=80',
      title: '纯真笑容',
      description: '纯真的笑容最美',
      authorName: 'Lily',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 456,
      category: '人像',
    ),
    Photo(
      id: 'p6',
      imageUrl: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400&q=80',
      title: '侧脸轮廓',
      description: '完美的侧脸轮廓',
      authorName: '王小明',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 167,
      category: '人像',
    ),
    Photo(
      id: 'p7',
      imageUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=400&q=80',
      title: '街头时尚',
      description: '街头时尚的态度',
      authorName: 'Fashion',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 345,
      category: '人像',
    ),
    Photo(
      id: 'p8',
      imageUrl: 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400&q=80',
      title: '夏日微风',
      description: '夏日微风轻拂',
      authorName: 'Summer',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 123,
      category: '人像',
    ),
    Photo(
      id: 'p9',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
      title: '温柔眼神',
      description: '温柔的眼神流转',
      authorName: '小雨',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 278,
      category: '人像',
    ),
    Photo(
      id: 'p10',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&q=80',
      title: '黑白肖像',
      description: '经典黑白肖像',
      authorName: 'BW Studio',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 456,
      category: '人像',
    ),
    Photo(
      id: 'p11',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80',
      title: '阳光男孩',
      description: '阳光般的笑容',
      authorName: '李摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 234,
      category: '人像',
    ),
    Photo(
      id: 'p12',
      imageUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&q=80',
      title: '优雅女性',
      description: '优雅女性的魅力',
      authorName: 'Grace',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 389,
      category: '人像',
    ),
    Photo(
      id: 'p13',
      imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&q=80',
      title: '复古风格',
      description: '复古风格的演绎',
      authorName: 'Vintage',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 267,
      category: '人像',
    ),
    Photo(
      id: 'p15',
      imageUrl: 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=400&q=80',
      title: '运动男孩',
      description: '运动活力的展现',
      authorName: 'Sports',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 312,
      category: '人像',
    ),
    Photo(
      id: 'p17',
      imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&q=80',
      title: '时尚先生',
      description: '时尚先生的品味',
      authorName: 'Fashion',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 178,
      category: '人像',
    ),
    Photo(
      id: 'p19',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&q=80',
      title: '专业形象',
      description: '专业形象的塑造',
      authorName: 'Pro',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 156,
      category: '人像',
    ),
    Photo(
      id: 'p21',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
      title: '都市风尚',
      description: '都市风尚的演绎',
      authorName: 'Urban Style',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 445,
      category: '人像',
    ),
  ];

  // 最新照片列表
  static final List<Photo> _latestPhotos = [
    Photo(
      id: 'new1',
      imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&q=80',
      title: '星空银河',
      description: '星空银河',
      authorName: '极地探险',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 892,
      category: '风景',
    ),
    Photo(
      id: 'new2',
      imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400&q=80',
      title: '霓虹夜景',
      description: '霓虹夜景璀璨迷人',
      authorName: '城市猎人',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 756,
      category: '城市',
    ),
    Photo(
      id: 'new3',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
      title: '优雅女士',
      description: '优雅女士',
      authorName: '时光记录者',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 634,
      category: '人像',
    ),
    Photo(
      id: 'new4',
      imageUrl: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=400&q=80',
      title: '雪山之巅',
      description: '雪山之巅',
      authorName: '登山者',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 923,
      category: '风景',
    ),
    Photo(
      id: 'new5',
      imageUrl: 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=400&q=80',
      title: '现代都市',
      description: '现代都市的繁华景象',
      authorName: '都市摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 812,
      category: '城市',
    ),
    Photo(
      id: 'new6',
      imageUrl: 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400&q=80',
      title: '街头时尚',
      description: '街头时尚',
      authorName: 'Fashion Studio',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      likes: 701,
      category: '人像',
    ),
    Photo(
      id: 'new7',
      imageUrl: 'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400&q=80',
      title: '日落余晖',
      description: '日落余晖',
      authorName: '自然之声',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      likes: 845,
      category: '风景',
    ),
    Photo(
      id: 'new8',
      imageUrl: 'https://images.unsplash.com/photo-1519331379826-f10be5486c6f?w=400&q=80',
      title: '伦敦大桥',
      description: '伦敦大桥的壮丽景观',
      authorName: 'Architecture',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 678,
      category: '城市',
    ),
    Photo(
      id: 'new9',
      imageUrl: 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=400&q=80',
      title: '微笑瞬间',
      description: '微笑瞬间',
      authorName: '青春记忆',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      likes: 789,
      category: '人像',
    ),
    Photo(
      id: 'new10',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      title: '田园风光',
      description: '田园风光',
      authorName: '森林漫步',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      likes: 856,
      category: '风景',
    ),
    Photo(
      id: 'new11',
      imageUrl: 'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=400&q=80',
      title: '伦敦街景',
      description: '伦敦街景充满英伦风情',
      authorName: 'Skyline',
      authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&q=80',
      likes: 734,
      category: '城市',
    ),
    Photo(
      id: 'new12',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80',
      title: '阳光男孩',
      description: '阳光男孩',
      authorName: 'Business',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      likes: 612,
      category: '人像',
    ),
  ];

  static final FeaturedPhoto _featuredPhoto = FeaturedPhoto(
    id: 'featured',
    imageUrl: 'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?w=800&q=80',
    title: '2026色彩配方',
    description: '2026色彩配方',
    authorName: 'Lin.Photography',
    authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
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
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
    likes: 1200,
    followers: 856,
    following: 128,
  );

  static final List<Photo> _favPhotos = [
    Photo(
      id: 'f1',
      imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
    Photo(
      id: 'f2',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
    Photo(
      id: 'f3',
      imageUrl: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=400&q=80',
      title: '',
      description: '',
      authorName: '',
      authorAvatar: '',
      likes: 0,
    ),
    Photo(
      id: 'f4',
      imageUrl: 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=400&q=80',
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
      // 热门返回随机打乱的所有照片
      final shuffled = List<Photo>.from(_allPhotos);
      shuffled.shuffle();
      return shuffled;
    }
    // 根据分类筛选
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
      content: '''
# 视听语言｜一篇看懂常用光位

光位是摄影中最重要的元素之一，不同的光位能够营造出完全不同的视觉效果和情绪氛围。

## 1. 顺光（正面光）

顺光是指光源位于摄影师身后，直接照射在被摄主体正面的光线。

**特点：**
- 画面明亮均匀
- 细节清晰可见
- 阴影较少
- 适合拍摄产品、证件照

**使用场景：** 需要展现主体全部细节时使用，如商业摄影、产品拍摄。

## 2. 侧光（90度光）

侧光是指光源位于被摄主体侧面，与相机成90度角的光线。

**特点：**
- 明暗对比强烈
- 立体感突出
- 质感表现力强
- 适合表现轮廓和纹理

**使用场景：** 人像摄影、静物摄影，能够很好地表现主体的立体感和质感。

## 3. 逆光（背光）

逆光是指光源位于被摄主体背后，朝向相机方向的光线。

**特点：**
- 轮廓光明显
- 氛围感强
- 容易产生光晕效果
- 主体可能欠曝

**使用场景：** 剪影拍摄、唯美人像、日出日落场景。

## 4. 顶光

顶光是指光源位于被摄主体正上方的光线。

**特点：**
- 阴影向下
- 容易产生不自然的阴影
- 正午阳光就是典型的顶光

**使用场景：** 一般避免使用，除非特殊创意需求。

## 5. 底光

底光是指光源位于被摄主体下方向上照射的光线。

**特点：**
- 营造神秘、恐怖氛围
- 不符合日常光线习惯
- 戏剧性强

**使用场景：** 恐怖片、悬疑题材、特殊创意拍摄。

## 实战技巧

1. **黄金时段拍摄**：日出后和日落前的1小时，光线柔和温暖
2. **使用反光板**：在逆光或侧光时补光，平衡明暗
3. **观察阴影**：阴影的方向和浓度能帮助判断光位
4. **多角度尝试**：同一场景不同光位会有完全不同的效果

掌握这些基本光位，你就能在拍摄时更有目的性地选择和运用光线，创作出更具表现力的作品。
''',
    ),
    Article(
      id: 'a2',
      title: '创作灵感｜绿色生命力调色',
      coverImage: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=800&q=80',
      authorName: '色彩大师',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      views: 3421,
      likes: 678,
      publishDate: '2026-04-28',
      content: '''
# 创作灵感｜绿色生命力调色

绿色代表生命、自然、清新，是摄影后期中最常用的色调之一。本文将分享如何调出充满生命力的绿色调。

## 色彩理论基础

绿色在色轮上位于黄色和青色之间，是一种中性偏冷的颜色。

**绿色的情感表达：**
- 浅绿：清新、活力、春天
- 深绿：沉稳、自然、森林
- 黄绿：温暖、生机、夏日
- 青绿：清冷、宁静、湖泊

## 调色步骤

### 1. 基础调整

**曝光和对比度：**
- 适当提高曝光，让画面通透
- 降低对比度，保持柔和感
- 提高阴影，保留暗部细节

### 2. HSL调整

**色相（Hue）：**
- 绿色色相向黄色偏移 +5 到 +10
- 黄色色相向绿色偏移 -5 到 -10
- 营造温暖的绿色基调

**饱和度（Saturation）：**
- 绿色饱和度 +15 到 +25
- 黄色饱和度 +10 到 +15
- 其他颜色适当降低饱和度

**明度（Luminance）：**
- 绿色明度 +5 到 +10
- 让绿色更加明亮通透

### 3. 色调分离

**高光：**
- 色相：45-60（偏黄）
- 饱和度：10-15

**阴影：**
- 色相：180-200（偏青）
- 饱和度：5-10

### 4. 相机校准

- 红原色：色相 -5，饱和度 -10
- 绿原色：色相 +5，饱和度 +10
- 蓝原色：色相 -5，饱和度 -5

## 不同场景的绿色调色

### 森林场景
- 强调深绿色
- 保留层次感
- 适当增加对比度

### 草地场景
- 突出黄绿色
- 提高整体明度
- 营造阳光感

### 植物特写
- 细腻的绿色过渡
- 保留叶脉纹理
- 适当锐化

## 常见问题

**Q: 绿色调得太假怎么办？**
A: 降低饱和度，注意色相的自然过渡，不要所有绿色都调成同一个色调。

**Q: 如何避免绿色发黄？**
A: 在HSL中将绿色色相向青色方向偏移，同时注意白平衡。

**Q: 皮肤偏绿怎么处理？**
A: 使用HSL单独调整橙色，或使用蒙版局部调整。

## 推荐预设参数

**清新绿调：**
- 曝光 +0.3
- 对比度 -10
- 高光 -20
- 阴影 +30
- 绿色饱和度 +20
- 黄色饱和度 +15

掌握这些技巧，你就能调出充满生命力的绿色照片了！
''',
    ),
    Article(
      id: 'a3',
      title: '参数思路｜通透日系风怎么调',
      coverImage: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
      authorName: '日系摄影',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80',
      views: 4567,
      likes: 892,
      publishDate: '2026-04-25',
      content: '''
# 参数思路｜通透日系风怎么调

日系风格以清新、通透、柔和著称，是最受欢迎的摄影风格之一。本文将详细讲解如何调出通透的日系色调。

## 日系风格特点

**视觉特征：**
- 高曝光、低对比
- 色彩柔和不浓烈
- 画面通透明亮
- 略微过曝的高光
- 柔和的阴影

**情感表达：**
- 清新、治愈
- 温柔、宁静
- 文艺、小清新

## 前期拍摄要点

### 1. 光线选择
- 优先选择柔和的自然光
- 避免强烈的直射光
- 阴天或室内散射光最佳
- 黄金时段的柔和光线

### 2. 曝光控制
- 适当过曝 +0.3 到 +0.7 EV
- 保留高光细节
- 避免死黑

### 3. 构图建议
- 留白充足
- 简洁干净
- 避免杂乱元素

## 后期调色步骤

### 第一步：基础调整

**曝光三角：**
```
曝光：+0.3 到 +0.5
对比度：-15 到 -25
高光：-30 到 -50
阴影：+30 到 +50
白色：-10 到 -20
黑色：+15 到 +25
```

**效果：** 降低对比度，提亮阴影，压低高光，让画面更加柔和通透。

### 第二步：曲线调整

**RGB曲线：**
- 整体曲线略微上提
- 暗部上提更多（营造灰度）
- 高光部分保持或略微下压

**红色曲线：**
- 暗部略微上提
- 高光略微下压

**蓝色曲线：**
- 暗部上提（增加青色）
- 高光下压（减少黄色）

### 第三步：HSL精细调整

**色相调整：**
```
红色：+5 到 +10（偏橙）
橙色：+5 到 +10（偏黄）
黄色：-5 到-10（偏绿）
绿色：-10 到 -15（偏青）
青色：+5 到 +10（偏蓝）
蓝色：-5 到 -10（偏青）
```

**饱和度调整：**
```
红色：-10 到 -20
橙色：-5 到 -10
黄色：+5 到 +10
绿色：-10 到 -15
青色：+5 到 +10
蓝色：-15 到 -25
紫色：-20 到 -30
洋红：-20 到 -30
```

**明度调整：**
```
橙色：+10 到 +15（提亮肤色）
黄色：+5 到 +10
蓝色：+10 到 +15
```

### 第四步：色调分离

**高光色调：**
- 色相：40-50（淡黄色）
- 饱和度：8-12

**阴影色调：**
- 色相：200-220（淡青色）
- 饱和度：5-10

**平衡：** 0 到 +10

### 第五步：细节处理

**清晰度：** -5 到 -10（柔化画面）
**纹理：** 0 到 +5（保留细节）
**去朦胧：** 0 到 -5（增加柔和感）

**锐化：**
- 数量：30-40
- 半径：0.8-1.0
- 细节：20-30

**颗粒：**
- 数量：5-10（增加胶片感）
- 大小：20-25

### 第六步：相机校准

```
红原色：色相 -5，饱和度 -10
绿原色：色相 +10，饱和度 +5
蓝原色：色相 -10，饱和度 -10
```

## 不同场景的微调

### 人像日系
- 重点提亮肤色
- 降低红色饱和度
- 保持肤色通透

### 风景日系
- 强调天空的青色
- 植物偏青绿色
- 整体明度更高

### 室内日系
- 增加暖色调
- 提高整体曝光
- 减少阴影对比

## 常见问题解答

**Q: 为什么我调的日系风格显得很灰？**
A: 对比度降得太多，或者黑色提得太高。适当保留一些对比度，不要让画面完全失去层次。

**Q: 肤色发青怎么办？**
A: 在HSL中单独调整橙色，提高橙色饱和度和明度，或者在色调分离中减少阴影的青色。

**Q: 如何保持通透感又不过曝？**
A: 关键是压低高光同时提亮阴影，而不是单纯提高曝光。使用曲线精细控制明暗过渡。

## 快速预设参数

**标准日系：**
```
曝光：+0.4
对比度：-20
高光：-40
阴影：+40
白色：-15
黑色：+20
清晰度：-8
饱和度：-5
```

**小清新日系：**
```
曝光：+0.5
对比度：-25
高光：-50
阴影：+50
白色：-20
黑色：+25
清晰度：-10
饱和度：-10
```

## 总结

日系风格的核心是"通透"和"柔和"，通过降低对比度、提亮阴影、柔化色彩来实现。记住：宁可调得清淡一些，也不要过度饱和。多练习，找到适合自己的参数范围。

希望这篇教程能帮助你调出理想的日系照片！
''',
    ),
    Article(
      id: 'a4',
      title: '构图技巧｜黄金分割与三分法则',
      coverImage: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=800&q=80',
      authorName: '构图大师',
      authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
      views: 3890,
      likes: 723,
      publishDate: '2026-04-22',
      content: '''
# 构图技巧｜黄金分割与三分法则

构图是摄影的基础，好的构图能让照片更具视觉冲击力和美感。本文将深入讲解两种最经典的构图法则。

## 什么是构图

构图是指在画面中安排和组织视觉元素的方式，目的是引导观众的视线，传达摄影师的意图。

## 三分法则

三分法则是最基础也是最实用的构图法则。将画面横竖各用两条线分成三等份，形成九宫格。

**使用方法：**
- 将主体放在四个交点之一
- 地平线沿横向三分线
- 避免将主体放在画面正中央

## 黄金分割

黄金分割是更精确的构图法则，比例约为1:1.618。

**特点：**
- 比三分法则更精确
- 画面更加和谐自然
- 符合人类审美天性

## 实战应用

**人像摄影：** 眼睛放在上方交点，视线方向留白

**风景摄影：** 地平线沿三分线，主要景物放在交点

**建筑摄影：** 利用黄金螺旋引导视线

## 打破规则

掌握规则后，要学会打破规则。居中构图适合对称场景，边缘构图营造紧张感。

## 总结

构图是摄影的基本功，掌握三分法则和黄金分割，但不要被规则束缚。多观察、多练习，形成自己的构图风格。
''',
    ),
    Article(
      id: 'a5',
      title: '器材选择｜定焦镜头vs变焦镜头',
      coverImage: 'https://images.unsplash.com/photo-1516802273409-68526ee1bdd6?w=800&q=80',
      authorName: '器材评测',
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
      views: 5234,
      likes: 967,
      publishDate: '2026-04-20',
      content: '''
# 器材选择｜定焦镜头vs变焦镜头

选择定焦还是变焦镜头，是每个摄影师都会面临的问题。本文将全面对比两种镜头的优缺点。

## 什么是定焦镜头

定焦镜头是焦距固定的镜头，不能变焦。

**常见焦段：**
- 35mm：人文、街拍
- 50mm：标准、人像
- 85mm：人像、特写

**特点：** 光圈通常较大，画质优秀，体积小巧

## 什么是变焦镜头

变焦镜头可以在一定范围内改变焦距。

**常见焦段：**
- 24-70mm：标准变焦
- 70-200mm：长焦变焦
- 16-35mm：广角变焦

**特点：** 一镜多用，便携性好，灵活多变

## 定焦镜头的优势

**画质优秀：** 光学设计简单，锐度更高

**大光圈：** f/1.4、f/1.8常见，虚化效果好

**体积小巧：** 重量轻，携带方便

**价格实惠：** 50mm f/1.8 性价比之王

## 变焦镜头的优势

**灵活多变：** 一镜多用，快速构图

**便利性：** 不需要频繁换镜，节省时间

**构图自由：** 快速调整构图，不错过瞬间

## 如何选择

**新手建议：** 首选50mm f/1.8定焦，学习构图，培养摄影眼

**进阶选择：** 根据题材选择，人像用定焦，旅行用变焦

**专业配置：** 双机双镜或定焦组合

## 推荐镜头

**定焦入门：** 50mm f/1.8、35mm f/2.8

**变焦入门：** 24-105mm f/4、18-55mm

**专业级：** 24-70mm f/2.8、70-200mm f/2.8

## 总结

定焦和变焦各有优劣，没有绝对的好坏。选择镜头要根据自己的拍摄需求、预算和使用习惯。记住：好照片不是靠昂贵的器材，而是靠摄影师的眼睛和技术。
''',
    ),
  ];

  static List<Article> getArticles() => _articles;
}