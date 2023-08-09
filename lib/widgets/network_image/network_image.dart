import 'package:flutter/material.dart';
import 'package:mh_core/services/api_service.dart';
import 'package:mh_core/utils/color/custom_color.dart';
import 'package:mh_core/utils/image_utils.dart';

/// [isFromAPI] is define your image from api or internet
/// [apiUrl] if [isFromAPI] then apiUrl is required
/// [apiUrl] if [isFromAPI] then [apiExtraSlag] is optional
/// [errorImagePath] is your local assets path (optional)/[errorIconData] is iconData (optional) if your image is not exists or internet connection is failed then this image show to user
/// Define [CustomNetworkImage] when is from api url
/// CustomNetworkImage(
///  isFromAPI: true,
///  isPreviewPageNeed: false,
///  networkImagePathFromAPI: UserController.to.getUserInfo.profilePhotoUrl ?? '',
///  apiUrl: ServiceAPI.apiUrl,
///  width: 70,
///  height: 70,
///  errorImagePath: 'images/image/user-default.png',
///  fit: BoxFit.cover,
///)
class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    Key? key,
    this.errorImagePath,
    this.borderRadius,
    this.imageColor,
    this.height,
    this.width,
    required this.networkImagePath,
    this.border = NetworkImageBorder.Circle,
    this.isPreviewPageNeed = false,
    this.isPreviewPageAppBarNeed = true,
    this.previewPageTitle,
    this.previewPageTitleColor,
    this.previewPageAppBarColor,
    this.errorIconData,
    this.fit,
  }) : super(key: key);
  final bool isPreviewPageNeed;
  final bool isPreviewPageAppBarNeed;
  final String? previewPageTitle;
  final Color? previewPageTitleColor;
  final Color? previewPageAppBarColor;
  final String networkImagePath;
  final String? errorImagePath;
  final IconData? errorIconData;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Color? imageColor;
  final BoxFit? fit;
  final NetworkImageBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPreviewPageNeed
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImagePreview(
                    imageList: [
                      networkImagePath.contains('http') ||
                              networkImagePath.contains(
                                  ServiceAPI.url!.replaceAll(ServiceAPI.apiUrl!.replaceAll(ServiceAPI.url!, ""), ''))
                          ? networkImagePath
                          : ServiceAPI.url! + networkImagePath,
                    ],
                    index: 0,
                    title: previewPageTitle,
                    titleColor: previewPageTitleColor,
                    isAppBarShow: isPreviewPageAppBarNeed,
                    appBarColor: previewPageAppBarColor,
                  ),
                ),
              )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            border == NetworkImageBorder.Circle ? borderRadius ?? MediaQuery.of(context).size.height : 0),
        child: Image.network(
          networkImagePath.contains('http') ||
                  networkImagePath
                      .contains(ServiceAPI.url!.replaceAll(ServiceAPI.apiUrl!.replaceAll(ServiceAPI.url!, ""), ''))
              ? networkImagePath
              : ServiceAPI.url! + networkImagePath,
          fit: fit ?? BoxFit.cover,
          color: imageColor,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, exception, stackTrack) => FutureBuilder(
              future: ImageUtils.getImageFileFromAssets(errorImagePath ?? 'assets/images/error.png'),
              builder: (context, a) {
                return a.data != null
                    ? Image.file(
                        a.data!,
                        color: imageColor,
                        height: height ?? MediaQuery.of(context).size.width * .3,
                        width: width ?? MediaQuery.of(context).size.width * .3,
                        fit: fit ?? BoxFit.cover,
                      )
                    : Icon(
                        errorIconData ?? Icons.error,
                        color: imageColor ?? Colors.red,
                        size: width ?? MediaQuery.of(context).size.width * .3,
                      );
              }),
          height: height ?? MediaQuery.of(context).size.width * .3,
          width: width ?? MediaQuery.of(context).size.width * .3,
        ),
      ),
    );
  }
}

class ImagePreview extends StatefulWidget {
  List<String> imageList;
  int index;
  String? title;
  Color? titleColor;
  bool isAppBarShow;
  Color? appBarColor;

  ImagePreview(
      {Key? key,
      required this.imageList,
      required this.index,
      this.title,
      this.titleColor = Colors.black,
      this.isAppBarShow = true,
      this.appBarColor})
      : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isAppBarShow
          ? AppBar(
              // iconTheme: IconThemeData(
              //   color: Colors.black, //change your color here
              // ),
              // automaticallyImplyLeading: false,
              backgroundColor: widget.appBarColor ?? CustomColor.kPrimaryColor,
              title: Text(
                widget.title ?? "Untitled Image",
                style: TextStyle(
                  color: widget.titleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
            )
          : null,
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xff626365),
                  Color(0xffCAC6C3),
                ],
              ),
            ),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: NetworkImageWidget(
                height: size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                width: size.width,
                image: widget.imageList[widget.index],
                boxFit: BoxFit.contain,
              ),
            ),
          ),
          Visibility(
            visible: widget.index > 0,
            child: Positioned(
                top: (size.height / 2) - 22.5,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    if (widget.index > 0) {
                      setState(() {
                        widget.index--;
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                )),
          ),
          Visibility(
            visible: widget.index < widget.imageList.length - 1,
            child: Positioned(
                top: (size.height / 2) - 22.5,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    if (widget.index < widget.imageList.length - 1) {
                      setState(() {
                        widget.index++;
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

enum NetworkImageBorder {
  Circle,
  Rectangle,
}

class NetworkImageWidget extends StatefulWidget {
  const NetworkImageWidget({
    Key? key,
    required this.image,
    this.border = NetworkImageBorder.Rectangle,
    this.height = 48,
    this.width = 48,
    this.boxFit = BoxFit.cover,
    // this.color = const Color(0xFF000000),
  }) : super(key: key);

  final String image;
  final double height;
  final double width;
  final BoxFit boxFit;
  final NetworkImageBorder border;

  @override
  _NetworkImageWidgetState createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  dynamic _imageWidget() {
    // TODO in future add a cachedNetworkimage
    // otherwise the network toll will be much higher
    // CachedNetworkImage(
    //   imageUrl: "http://via.placeholder.com/200x150",
    //   imageBuilder: (context, imageProvider) => Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //           image: imageProvider,
    //           fit: BoxFit.cover,
    //           colorFilter:
    //           ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
    //     ),
    //   ),
    //   placeholder: (context, url) => CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => Icon(Icons.error),
    // ),

    return FadeInImage(
      fadeInDuration: const Duration(milliseconds: 500),
      fadeInCurve: Curves.decelerate,
      placeholder: const AssetImage("assets/images/loading.gif"),
      image: NetworkImage(
        widget.image,
      ),
      imageErrorBuilder: (context, error, stackTrace) {
        // _authenticateAndRefresh();
        return Image.asset("assets/images/error.png");
      },
      width: widget.width,
      height: widget.height,
      fit: widget.boxFit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.border == NetworkImageBorder.Rectangle
        ? _imageWidget()
        : ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height), child: _imageWidget());
  }
}
