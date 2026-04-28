import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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

  bool _hasError = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration _bufferedPosition = Duration.zero;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Explicitly update position state on each tick
    _audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
          // Poll duration on every position tick because some servers 
          // (without Accept-Ranges) cause the native player to quietly update 
          // the duration as it downloads, without firing a duration event.
          final currentDuration = _audioPlayer.duration;
          if (currentDuration != null && currentDuration > _duration) {
            _duration = currentDuration;
          }
        });
      }
    });

    _audioPlayer.bufferedPositionStream.listen((b) {
      if (mounted) {
        setState(() => _bufferedPosition = b);
      }
    });

    // Explicitly update duration state when it changes
    _audioPlayer.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          if (d != null && d > _duration) {
            _duration = d;
          }
        });
      }
    });

    _initAudio();
  }

  static Future<bool> _validateMediaInBackground(Map<String, dynamic> args) async {
    final url = args['url'] as String?;
    try {
      if (url != null) {
        if (!url.startsWith('http')) {
          return File(url).existsSync();
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> _runBackgroundValidation(String url) async {
    if (url.startsWith('http')) return true; // just_audio handles network async safely
    return await Isolate.run(() => _validateMediaInBackground({
          'url': url,
        }));
  }

  Future<void> _initAudio() async {
    if (widget.useBackgroundValidation) {
      final isValid = await _runBackgroundValidation(widget.url);
      if (!isValid && mounted) {
        setState(() => _hasError = true);
        return;
      }
    }

    try {
      if (widget.url.startsWith('http')) {
        await _audioPlayer.setAudioSource(LockCachingAudioSource(Uri.parse(widget.url)));
      } else {
        await _audioPlayer.setUrl(widget.url);
      }
      
      if (widget.autoPlay) {
        _audioPlayer.play();
      }
    } catch (e) {
      debugPrint("OmniAudioPlayer Error: $e");
      if (mounted) setState(() => _hasError = true);
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

              if (_hasError) {
                return IconButton(
                  icon: const Icon(Icons.error_outline),
                  iconSize: widget.iconSize,
                  color: Colors.red,
                  onPressed: () {
                    setState(() => _hasError = false);
                    _initAudio(); // Retry
                  },
                );
              } else if (processingState == ProcessingState.loading ||
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    final double effectiveMax = _duration > _bufferedPosition 
                        ? _duration.inSeconds.toDouble() 
                        : (_bufferedPosition > _position ? _bufferedPosition.inSeconds.toDouble() : _position.inSeconds.toDouble());
                    final double safeMax = effectiveMax > 0 ? effectiveMax : 1.0;
                    
                    // Display either the active drag value or the actual position
                    final currentDisplaySeconds = _dragValue ?? _position.inSeconds.toDouble();
                    final double safePosition = currentDisplaySeconds.clamp(0.0, safeMax);

                    return SliderTheme(
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
                        max: safeMax,
                        value: safePosition,
                        onChangeStart: effectiveMax > 0
                            ? (value) {
                                setState(() {
                                  _dragValue = value;
                                });
                              }
                            : null,
                        onChanged: effectiveMax > 0
                            ? (value) {
                                setState(() {
                                  _dragValue = value;
                                });
                              }
                            : null,
                        onChangeEnd: effectiveMax > 0
                            ? (value) {
                                _audioPlayer.seek(Duration(seconds: value.toInt()));
                                setState(() {
                                  _dragValue = null;
                                });
                              }
                            : null,
                      ),
                    );
                  }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_dragValue != null ? Duration(seconds: _dragValue!.toInt()) : _position),
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
