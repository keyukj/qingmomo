import 'package:flutter/material.dart';
import 'package:qingmooo/services/data_service.dart';
import 'package:qingmooo/services/storage_service.dart';
import 'package:qingmooo/models/photo.dart';
import 'package:qingmooo/screens/photo_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Photo> _photos;
  final Map<String, bool> _likedPhotos = {};

  @override
  void initState() {
    super.initState();
    _photos = DataService.getPhotosByCategory(widget.category);
    _loadLikedStatus();
  }

  Future<void> _loadLikedStatus() async {
    final likedMap = await StorageService.getAllLikedPhotos();
    setState(() {
      _likedPhotos.addAll(likedMap);
    });
  }

  Future<void> _toggleLike(Photo photo) async {
    final newStatus = !(_likedPhotos[photo.id] ?? false);
    setState(() {
      _likedPhotos[photo.id] = newStatus;
    });
    await StorageService.toggleLike(photo.id, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          if (_photos.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  '暂无内容',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: _buildWaterfallGrid(),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterfallGrid() {
    // 将照片分成左右两列
    final leftPhotos = <Photo>[];
    final rightPhotos = <Photo>[];
    
    for (int i = 0; i < _photos.length; i++) {
      if (i % 2 == 0) {
        leftPhotos.add(_photos[i]);
      } else {
        rightPhotos.add(_photos[i]);
      }
    }

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftPhotos.map((photo) => _buildPhotoCard(photo, true)).toList(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: rightPhotos.map((photo) => _buildPhotoCard(photo, false)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(Photo photo, bool isLeft) {
    final isLiked = _likedPhotos[photo.id] ?? false;
    // 左右列使用不同的高度比例
    final height = isLeft ? 200.0 : 260.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDetailScreen(photo: photo),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.network(
                  photo.imageUrl,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3EDF3),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            image: DecorationImage(
                              image: NetworkImage(photo.authorAvatar),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            photo.authorName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleLike(photo),
                          child: Row(
                            children: [
                              Icon(
                                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                size: 14,
                                color: isLiked ? const Color(0xFF000000) : const Color(0xFF999999),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${photo.likes}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isLiked ? const Color(0xFF000000) : const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
