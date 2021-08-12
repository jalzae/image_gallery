import 'package:cached_network_image/cached_network_image.dart';
import 'package:evermos_app/detail/detail.dart';
import 'package:evermos_app/home/controller/gallery_controller.dart';
import 'package:evermos_app/home/view/home_flexible.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

final GalleryController controller = Get.put(GalleryController());
final scrollController = ScrollController();

class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.green,
            expandedHeight: 200,
            floating: false,
            pinned: true,
            title: Obx(() {
              if (controller.view.value == 1) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.dashboard),
                      onPressed: () {
                        controller.changeGrid();
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        controller.changeList();
                      },
                      icon: Icon(Icons.view_list),
                      color: Colors.black87,
                    )
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.dashboard),
                    color: Colors.black87,
                    onPressed: () {
                      controller.changeGrid();
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      controller.changeList();
                    },
                    icon: Icon(Icons.view_list),
                  )
                ],
              );
            }),
            actionsIconTheme: IconThemeData(opacity: 0.0),
            flexibleSpace: MyAppSpace(),
          ),
          galleryImage()
        ],
      ),
    );
  }

  Widget galleryImage() => SliverToBoxAdapter(child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (controller.koneksi.value == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: ElevatedButton(
                child: Text('Refresh'),
                onPressed: () {
                  controller.onInit();
                },
              ),
            ),
          );
        } else {
          return SafeArea(
              child: (() {
            if (controller.view.value == 1) {
              return HomeList();
            } else {
              return HomeGrid();
            }
          }()));
        }
      }));
}

class HomeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: controller.cartList.value.photos.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == controller.cartList.value.photos.length) {
            if (controller.isLoading2.value) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        controller.loadMore();
                      },
                      child: Text('Load More')),
                ),
              );
            }
          }
          return Container(
            height: 150,
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Container(
                    width: 130,
                    child: CachedNetworkImage(
                      imageUrl:
                          controller.cartList.value.photos[index].src.small,
                      height: 140,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                          child: Center(child: Text('Loading')),
                          baseColor: Colors.red,
                          highlightColor: Colors.yellow),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                  onTap: () {
                    Get.to(DetailPic(
                        pic: controller
                            .cartList.value.photos[index].src.original,
                        photo: controller
                            .cartList.value.photos[index].photographer));
                  },
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(controller.cartList.value.photos[index].photographer)
              ],
            ),
          );
        }));
  }
}

class HomeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                ),
                itemCount: controller.cartList.value.photos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 300,
                    margin: EdgeInsets.all(10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 130,
                            child: CachedNetworkImage(
                              imageUrl: controller
                                  .cartList.value.photos[index].src.small,
                              height: 140,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                  child: Center(child: Text('Loading')),
                                  baseColor: Colors.red,
                                  highlightColor: Colors.yellow),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                          ),
                          onTap: () {
                            Get.to(DetailPic(
                                pic: controller
                                    .cartList.value.photos[index].src.original,
                                photo: controller.cartList.value.photos[index]
                                    .photographer));
                          },
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Center(
                            child: Text(controller
                                .cartList.value.photos[index].photographer))
                      ],
                    ),
                  );
                }),
            Obx(() {
              if (controller.isLoading2.value == true)
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              else
                return Container(
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          controller.loadMore();
                        },
                        child: Text('Load More')),
                  ),
                );
            })
          ],
        ));
  }
}
