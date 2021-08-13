import 'dart:io';

import 'package:evermos_app/home/model/photo_model.dart';
import 'package:evermos_app/home/service/homeservice.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GalleryController extends GetxController {
  var isLoading = true.obs;
  var isLoading2 = false.obs;
  var cartList = PhotoModel(
          page: 0, perPage: 0, photos: [], totalResults: 0, nextPage: "0")
      .obs;
  var totalPhoto = 0.obs;
  var page = 1.obs;
  var view = 1.obs;
  var koneksi = 0.obs;
  var halaman = 1.obs;

  @override
  void onInit() {
    isLoading(true);
    try {
      checkConnection().then((value) {
        print('mencoba connect...');
        print(value);
        if (value == 1) {
          print('connected');
          isLoading(false);
          koneksi.value = 1;
          fetchfinaltodo();
        } else {
          print('not connected');
          isLoading(false);
          koneksi.value = 0;
          Get.snackbar('Notification', 'Youre not connected');
        }
      });
    } catch (e) {
      isLoading(false);
      koneksi.value = 0;
      Get.snackbar('Warning', 'Youre not connected');
    } finally {
      isLoading(false);
    }
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await HomeService.getPhotos();
      cartList.value = todos;
      print(todos);
      print('banyaknya foto ${cartList.value.photos.length}');
      totalPhoto.value = cartList.value.photos.length;
    } finally {
      isLoading(false);
    }
  }

  void loadMore() async {
    halaman.value = halaman.value + 1;
    print("onLoadMore");
    isLoading2(true);
    try {
      checkConnection().then((value) async {
        if (value == 1) {
          var todos = await HomeService.getLoadPhotos(halaman.value);
          cartList.value.photos.addAll(todos.photos);
          cartList.refresh();
          update();
          print('Berhasil load more');
          Get.snackbar('Informaion', 'Success Load More');
        } else {
          isLoading2(false);
          Get.snackbar('Caution', 'Youre Not Connected');
        }
      });
    } catch (e) {
      isLoading2(false);
      Get.snackbar('Caution', 'Youre Not Connected');
    }
  }

  void changeList() {
    view.value = 2;
    print('change view to list');
  }

  void changeGrid() {
    view.value = 1;
    print('change view to grid');
  }

  checkConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        return 1;
      } else {
        return 0;
      }
    } on SocketException catch (_) {
      return 0;
    }
  }
}
