import 'package:evermos_app/home/model/photo_model.dart';
import 'package:http/http.dart' as http;

class HomeService {
  static String apikey =
      '563492ad6f917000010000017300f96c65b345758a96259d4b74affa';
  String baseurl = 'https://api.pexels.com/v1/';

  static Future<PhotoModel> getPhotos() async {
    var headers = {
      'Authorization': apikey,
    };
    var request = http.Request('GET',
        Uri.parse('https://api.pexels.com/v1/curated?page=1&per_page=20'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var respons = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print(respons);
      return photoModelFromJson(respons);
    } else {
      print(response.reasonPhrase);
      return photoModelFromJson(respons);
    }
  }

  static Future<PhotoModel> getLoadPhotos(int page) async {
    String paging = page.toString();
    var headers = {
      'Authorization': apikey,
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.pexels.com/v1/curated?page=$paging&per_page=20'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var respons = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print(respons);
      return photoModelFromJson(respons);
    } else {
      print(response.reasonPhrase);
      return photoModelFromJson(respons);
    }
  }

  static Future<int> checkConnection() async {
    http.Response response = await http
        .get(Uri.parse('https://www.google.com'))
        .timeout(Duration(seconds: 5));
    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }
}
