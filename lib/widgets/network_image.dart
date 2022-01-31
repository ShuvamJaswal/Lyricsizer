import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageFromUrl extends StatelessWidget {
  final String imageUrl;
  final bool isIcon;
  const NetworkImageFromUrl(
      {Key? key, required this.imageUrl, this.isIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        //height: isIcon ? null : MediaQuery.of(context).size.width * 0.50,
        // width: isIcon ? null : MediaQuery.of(context).size.width * 0.50,
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade100,
            highlightColor: Colors.grey.shade400,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          return Center(
            child: Icon(
              MdiIcons.musicNoteOutline,
              size: isIcon ? null : MediaQuery.of(context).size.width * 0.50,
            ),
          );
        },
      ),
    );
  }
}
