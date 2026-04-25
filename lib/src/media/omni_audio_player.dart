import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  
  /// Whether to use a background Isolate to validate the media (e.g., DNS lookup or file check)
  /// before initializing the player. This prevents main-thread jank for slow connections.
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
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _initAudio();
  }

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
      final isValid = await _runBackgroundValidation(widget.url);
      if (!isValid) {
        debugPrint("OmniAudioPlayer: Validation failed for ${widget.url}");
      }
    }

    try {
      await _audioPlayer.setSource(UrlSource(widget.url));
      
      // Fetch duration after source is set
      Future.delayed(const Duration(milliseconds: 1200), () async {
        final d = await _audioPlayer.getDuration();
        if (d != null && mounted) {
          setState(() => _duration = d);
        }
      });

      if (widget.autoPlay) {
        await _audioPlayer.resume();
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
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            ),
            iconSize: widget.iconSize,
            color: activeColor,
            onPressed: () async {
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.resume();
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
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
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: widget.timeTextStyle ?? const TextStyle(fontSize: 12),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: widget.timeTextStyle ?? const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
