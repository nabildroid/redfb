import 'package:flutter/material.dart';
import 'package:redfb/repository/localsotre.dart';
import 'package:redfb/repository/server.dart';

import 'models/post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Post? post;
  bool showPost = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _controller.addListener(() {
      setState(() => showPost = _controller.value.text.length > 30);
    });
    this.chooseRandomPost();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void publish() {
    Server()..move(post!.id, _controller.text).then((value) => {});

    setState(() {
      post = null;
    });
  }

  void chooseRandomPost() async {
    final localStore = LocalStore();
    var randomPost = await localStore.random();
    if (randomPost == null) {
      final server = Server();
      final posts = await server.getQueue();
      await localStore.save(posts);
      randomPost = await localStore.random();
    }

    setState(() {
      post = randomPost!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: post == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(
                    top: 24,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            post!.source,
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              post!.content.origin,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                              height: 26,
                            ),
                            Text(
                              post!.content.generatedTranslation,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _controller,
                          minLines: 6,
                          textDirection: TextDirection.rtl,
                          maxLines: 10,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    height: 2,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              FloatingActionButton(
                child: Icon(Icons.delete),
                backgroundColor: Colors.redAccent,
                onPressed: () {},
              ),
              SizedBox(height: 8),
              if (showPost)
                FloatingActionButton(
                  child: Icon(Icons.send),
                  onPressed: publish,
                ),
            ],
          )
        ],
      ),
    );
  }
}
