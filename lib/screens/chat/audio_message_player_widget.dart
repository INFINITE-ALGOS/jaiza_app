import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

String prettyDuration(Duration d) {
  var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
  var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
  return "$min:$sec";
}

class AudioBubble extends StatefulWidget {
  const AudioBubble(
      {Key? key,
      required this.filepath,
      required this.timeStamp,
      required this.peerSide})
      : super(key: key);

  final String filepath;
  final String timeStamp;
  final bool peerSide;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    player.setUrl(widget.filepath).then((value) {
      setState(() {
        duration = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 4),
          Row(
            children: [
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return GestureDetector(
                      onTap: player.play,
                      child: widget.peerSide
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.play_arrow,
                            ),
                    );
                  } else if (playing != true) {
                    return GestureDetector(
                      onTap: player.play,
                      child: widget.peerSide
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            )
                          : Icon(Icons.play_arrow),
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return GestureDetector(
                      onTap: player.pause,
                      child: widget.peerSide
                          ? Icon(
                              Icons.pause,
                              color: Colors.white,
                            )
                          : Icon(Icons.pause),
                    );
                  } else {
                    return GestureDetector(
                      child: widget.peerSide
                          ? const Icon(
                              Icons.replay,
                              color: Colors.white,
                            )
                          : const Icon(Icons.replay),
                      onTap: () {
                        player.seek(Duration.zero);
                      },
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: snapshot.data!.inMilliseconds /
                                (duration?.inMilliseconds ?? 1),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prettyDuration(snapshot.data! == Duration.zero
                                    ? duration ?? Duration.zero
                                    : snapshot.data!),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM kk:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.timeStamp))),
                                style: TextStyle(
                                    color: widget.peerSide
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 10.0,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
