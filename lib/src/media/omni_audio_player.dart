import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class OmniAudioPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;
  
  /// Customization options
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double iconSize;
  final TextStyle? timeTextStyle;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  
  final bool useBackgroundValidation;

  const OmniAudioPlayer({
    super.key,
    required this.url,
    this.autoPlay = false,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.iconSize = 48.0,
    this.timeTextStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.borderRadius,
    this.useBackgroundValidation = false,
  });

  @override
  State<OmniAudioPlayer> createState() => _OmniAudioPlayerState();
}

class _OmniAudioPlayerState extends State<OmniAudioPlayer> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  /// Combine position, buffered position, and duration into a single stream
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, bufferedPosition, duration ?? Duration.zero));

  static Future<bool> _validateMediaInBackground(Map<String, dynamic> args) async {
    final url = args['url'] as String?;
    try {
      if (url != null) {
        if (url.startsWith('http')) {
          final client = HttpClient();
          final request = await client.getUrl(Uri.parse(url));
          final response = await request.close();
          return response.statusCode < 400;
        } else {
          return File(url).existsSync();
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> _runBackgroundValidation(String url) async {
    return await Isolate.run(() => _validateMediaInBackground({
          'url': url,
        }));
  }

  Future<void> _initAudio() async {
    if (widget.useBackgroundValidation) {
      await _runBackgroundValidation(widget.url);
    }

    try {
      await _audioPlayer.setUrl(widget.url);
      if (widget.autoPlay) {
        _audioPlayer.play();
      }
    } catch (e) {
      debugPrint("OmniAudioPlayer Error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.primaryColor;
    final inactiveColor = widget.inactiveColor ?? activeColor.withAlpha(76);

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey.shade100,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing ?? false;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: widget.iconSize - 16,
                  height: widget.iconSize - 16,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  iconSize: widget.iconSize,
                  color: activeColor,
                  onPressed: _audioPlayer.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause_circle_filled),
                  iconSize: widget.iconSize,
                  color: activeColor,
                  onPressed: _audioPlayer.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay_circle_filled),
                  iconSize: widget.iconSize,
                  color: activeColor,
                  onPressed: () => _audioPlayer.seek(Duration.zero),
                );
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position ?? Duration.zero;
                final duration = positionData?.duration ?? Duration.zero;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.0,
                        activeTrackColor: activeColor,
                        inactiveTrackColor: inactiveColor,
                        thumbColor: activeColor,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                        overlayColor: activeColor.withAlpha(51),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: widget.timeTextStyle ?? const TextStyle(fontSize: 12),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: widget.timeTextStyle ?? const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
