import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void onShareXFileFromAssets(BuildContext context, ByteData? data) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  // final data = await rootBundle.load('assets/flutter_logo.png');
  final buffer = data!.buffer;
  final shareResult = await Share.shareXFiles(
    [
      XFile.fromData(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        name: 'screen_shot.png',
        mimeType: 'image/png',
      ),
    ],
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );

  scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
}

SnackBar getResultSnackBar(ShareResult result) {
  return SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Share result: ${result.status}"),
        if (result.status == ShareResultStatus.success)
          Text("Shared to: ${result.raw}")
      ],
    ),
  );
}
