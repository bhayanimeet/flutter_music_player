import 'package:flutter/material.dart';
import 'package:flutter_music_player/views/res/global.dart';
import 'package:flutter_music_player/views/screens/detail.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'detail': (context) => const Detail(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RAINBOW MUSIC"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            children: Global.myList
                .map(
                  (e) => GestureDetector(
                onTap: () {
                  Map<String, dynamic> myData = {
                    'image': e['image'],
                    'name': e['name'],
                    'song': e['song'],
                    'singer': e['singer'],
                    'color': e['color'],
                  };
                  Navigator.pushNamed(context, 'detail', arguments: myData);
                },
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: e['color'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              e['image'],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${e['name']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${e['singer']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Icon(Icons.play_arrow,
                            color: Colors.white, size: 25),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}
