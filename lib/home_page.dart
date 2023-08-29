import 'dart:io';// dart:ioは、ファイルやディレクトリ、ソケットなどの入出力を扱うためのライブラリ

import 'package:flutter/foundation.dart';// foundation.dartは、Flutterの基本的なクラスや関数を含むライブラリ
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. compress file and get Uint8List
  Future<Uint8List?> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 90,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery);
              // 画像を圧縮する処理を追加
              // nullを返す可能性があるので、nullチェックを追加
              if (file != null) {
                // uploadした画像を圧縮する処理を追加
                final Uint8List? result = await compressFile(File(file.path));

                // nullでない場合は、画像のサイズを表示
                if (result != null) {
                  print(result.length); // Print image size
                } else {
                  print("Failed to compress the image.");
                }
              }
            },
            icon: const Icon(Icons.photo)),
      ),
    );
  }
}
