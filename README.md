# そのまま画像をアップロードするとデータの容量が大きい
最近画像の解像度を下げるパッケージはないか調べていたのですが、検索してたら画像を圧縮するパッケージを見つけました。

こちらですね。面白そうだから使ってみた。

https://pub.dev/packages/flutter_image_compress

画像を扱うので、image_pickerも追加。

https://pub.dev/packages/image_picker

## 📱iOSの設定をする
iOSは、設定が必要なのでinfo.plistに設定を追加します。
```xml:ios/Runner/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>Image</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>image</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
	<!-- ここから -->
	<key>NSPhotoLibraryUsageDescription</key>
	<string>このアプリは写真ライブラリにアクセスする必要があります</string>
	<key>NSCameraUsageDescription</key>
	<string>このアプリはカメラにファイルを追加する必要があります</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>このアプリでは、マイクを使って写真ライブラリにファイルを追加する必要があります</string>
	<!-- ここまで -->
</dict>
</plist>
```

## 🪬画像の圧縮をするコード
公式のメソッドをそのまま使わせていただきます。
```dart
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
```

## 🔭画像を圧縮するコード
image_pickerを使用してアップロードした画像を圧縮してログに出力するだけの機能しかないですが、今回やりたい目的を満たしていると思われます。
```dart
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
```

**importして実行する**
```dart
import 'package:flutter/material.dart';
import 'package:image/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
```

![](https://storage.googleapis.com/zenn-user-upload/3f26c2a67bd2-20230830.png)

## まとめ
Uint8Listというワードについて調べて見たのですが、Flutterの公式に解説があり翻訳して見ました。

:::Uint8List class
8ビット符号なし整数の固定長リスト。

長いリストの場合、この実装はデフォルトの List 実装よりもかなりスペースと時間の効率が良くなります。

リストに格納された整数は下位8ビットまで切り詰められ、0から255の範囲の値を持つ符号なし8ビット整数として解釈されます。

クラスがUint8Listを拡張または実装しようとすると、コンパイル時にエラーになります。
:::

**8ビットのサイズは何バイトですか？**
>単位のbit（ビット）やByte（バイト）を理解する
8bitが1Byte（バイト）なので、bitで表記された場合は8で割ればByteの単位に置き換えることができます。 1Byteは半角英数字1字のデータ量であり、8bit=1Byte(バイト)ががコンピュータの最小単位です。

今回ログに出力した画像の容量は、`1624950`MBだそうです。
