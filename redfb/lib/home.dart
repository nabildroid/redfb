import 'package:flutter/material.dart';
import 'package:redfb/repository/localsotre.dart';
import 'package:redfb/repository/server.dart';

import 'models/post.dart';

class Home extends StatefulWidget {
  final Post? post;
  const Home(this.post, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Post? post;
  bool showPost = false;
  late Server server;

  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _controller.addListener(() {
      setState(() => showPost = _controller.value.text.length > 30);
    });
    post = widget.post;
    server = Server();

    if (post == null) {
      ensurePostExist();
    }
  }

  void ensurePostExist() async {
    final posts = await server.getQueue();
    await LocalStore().save(posts);

    post = await LocalStore().random();
    setState(() {});
  }

  void publish() async {
    final id = post!.id;

    setState(() {
      post = null;
    });
    await server.move(id, _controller.text).then((value) => {});
    await LocalStore().remove(id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.height);
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: post == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(
                    top: 24,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.label,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              post!.id,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const Spacer(),
                            if (size.height < 500) ...[
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 8),
                              if (showPost)
                                IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: publish,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ]
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                              const Divider(
                                color: Colors.black54,
                                height: 26,
                              ),
                              Text(
                                post!.content.generatedTranslation,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  height: 1,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: size.width - 100,
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                if (size.height >= 500 && post != null) ...[
                  FloatingActionButton(
                    child: const Icon(Icons.delete),
                    backgroundColor: Colors.redAccent,
                    onPressed: () async {
                      await LocalStore().remove(post!.id);
                    },
                  ),
                  const SizedBox(height: 8),
                  if (showPost)
                    FloatingActionButton(
                      child: const Icon(Icons.send),
                      onPressed: publish,
                    ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
