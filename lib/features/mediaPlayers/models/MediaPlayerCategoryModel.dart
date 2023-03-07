class MediaPlayerCategoryModel {
  
   final String? id,
        title, 
        mediaCount;
   final String? thumbnailUrl;

   MediaPlayerCategoryModel({
           this.id,
           this.title,
           this.thumbnailUrl,
           this.mediaCount 
        });
 
   factory MediaPlayerCategoryModel.fromJson(Map<String, dynamic> jsonData){
   return MediaPlayerCategoryModel(
    id: jsonData['id'],
    title: jsonData['name'],
    thumbnailUrl: jsonData['thumbnail'],
    mediaCount: jsonData['media_count']
   );
   }
} 
