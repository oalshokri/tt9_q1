import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tt9_q1/services/capture_image.dart';
import 'package:tt9_q1/services/image_service.dart';
import 'package:tt9_q1/services/quotes_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  GlobalKey globalKey = GlobalKey();
  bool isLoading = false;

  String? imageUrl;
  String? quote;
  String? author;
  String? tag;

  void fetchQuote() async {
    setState(() {
      isLoading = true;
      imageUrl = null;
    });
    getRandomQuote().then((value) {
      // print(value);
      quote = value['content'];
      author = value['author'];
      tag = value['tags'][0];
      fetchImage();
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void fetchImage() {
    getRandomImage('$tag').then((value) {
      // print(value);
      imageUrl = value['url'];
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetchQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: fetchQuote,
            icon: const Icon(
              Icons.refresh,
              color: Colors.lightGreen,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await capturePng(context, globalKey);
        },
        label: const Text('Take screenshot'),
        icon: const Icon(Icons.share_rounded),
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Stack(
          children: [
            imageUrl == null
                ? const SizedBox()
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    opacity: const AlwaysStoppedAnimation(.5),
                  ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Transform.flip(
                              flipX: true,
                              child: Opacity(
                                opacity: 0.2,
                                child: Image.asset(
                                  'images/quote.png',
                                  width: 70,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                left: 8,
                              ),
                              child: Text(
                                quote ?? 'Loading ..',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 28,
                                  letterSpacing: -1,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                  // backgroundColor: Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          author ?? '',
                          style: TextStyle(
                            letterSpacing: 2,
                            backgroundColor: Colors.lightGreen[400],
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
