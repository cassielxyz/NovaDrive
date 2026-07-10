import 'package:flutter_riverpod/flutter_riverpod.dart';

final mediaCacheProvider = Provider<MediaCacheService>((ref) {
  return MediaCacheService();
});

class MediaCacheService {
  // Scaffolding for Media Cache
  // Will manage cached thumbnails and temporary downloads
}
