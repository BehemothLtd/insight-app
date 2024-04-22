import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/utils/api.dart';

class FileUpload {
  String url;
  String key;

  FileUpload({
    required this.url,
    required this.key,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) {
    return FileUpload(
      url: json['url'],
      key: json['key'],
    );
  }

  static Future<List<FileUpload>?> upload(XFile xfile) async {
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    List<XFile> files = [];
    files.add(xfile);

    var result = await apiProvider.upload(files: files);

    if (result != null) {
      var fileUploads =
          result.map<FileUpload>((json) => FileUpload.fromJson(json)).toList();

      return fileUploads;
    }

    return null;
  }
}
