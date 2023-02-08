import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  bool isStart = true;
  IconData myIcon = Icons.play_arrow;
  Duration totalDuration = const Duration(seconds: 0);

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    playAudio() {
      assetsAudioPlayer
          .open(
        showNotification: true,
        Audio(
          data['song'],
          metas: Metas(
            title: "${data['name']}",
          ),
        ),
      )
          .then((value) {
        assetsAudioPlayer.current.listen((playingAudio) {
          setState(() {
            totalDuration = assetsAudioPlayer.current.value!.audio.duration;
          });
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Image.asset(
              data['image'],
              fit: BoxFit.fill,
              filterQuality: FilterQuality.low,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Container(
                height: 230,
                width: 150,
                color: Colors.white,
                child: Image.asset(
                  data['image'],
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "${data['name']}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              Text(
                "${data['singer']}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.white, size: 40),
                    onPressed: () async {
                      await assetsAudioPlayer.stop();
                    },
                  ),
                  (assetsAudioPlayer.current.hasValue)
                      ? IconButton(
                    onPressed: () {
                      setState(() {
                        isStart = !isStart;
                        assetsAudioPlayer.playOrPause();
                      });
                      (isStart)?myIcon = Icons.play_arrow:myIcon = Icons.pause;
                    },
                    icon: (isStart)
                        ? Icon(myIcon, color: Colors.white,size: 50)
                        : Icon(myIcon, color: Colors.white,size: 50),
                  )
                      : IconButton(
                    onPressed: () {
                      playAudio();
                      setState(() {
                        myIcon = Icons.play_arrow;
                      });
                    },
                    icon: Icon(myIcon, color: Colors.white, size: 50),
                  ),
                  IconButton(
                    icon: const Icon(Icons.headphones,
                        color: Colors.white, size: 40),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              StreamBuilder(
                stream: assetsAudioPlayer.currentPosition,
                builder: (context, asyncSnapshot) {
                  Duration? currentPosition = asyncSnapshot.data;
                  return Column(
                    children: [
                      Theme(
                        data: ThemeData(
                          sliderTheme: const SliderThemeData(
                            trackHeight: 1,
                            thumbColor: Colors.indigo,
                            activeTrackColor: Colors.indigo,
                            inactiveTrackColor: Colors.white,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: totalDuration.inSeconds.toDouble(),
                          value: currentPosition!.inSeconds.toDouble(),
                          onChanged: (val) {
                            setState(() {
                              assetsAudioPlayer
                                  .seek(Duration(seconds: val.toInt()));
                              currentPosition = Duration(seconds: val.toInt());
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentPosition.toString().split(".")[0],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            (assetsAudioPlayer.current.hasValue)
                                ? Text(
                              "${assetsAudioPlayer.current.valueOrNull?.audio.duration.toString().split(".")[0]}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            )
                                : const Text(
                              "0.00:00",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
