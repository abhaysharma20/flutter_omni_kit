import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../ui/omni_glass_card.dart';

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
  final bool useGlassEffect;

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
    this.useGlassEffect = false,
  });

  @override
  State<OmniAudioPlayer> createState() => _OmniAudioPlayerState();
}

class _OmniAudioPlayerState extends State<OmniAudioPlayer> {
  late AudioPlayer _audioPlayer;

  bool _hasError = false;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  static Future<bool> _validateMediaInBackground(
      Map<String, dynamic> args) async {
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
    if (url.startsWith('http')) {
      return true; // just_audio handles network async safely
    }
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
        await _audioPlayer
            .setAudioSource(AudioSource.uri(Uri.parse(widget.url)));
      } else {
        await _audioPlayer.setUrl(widget.url);
      }

      // Wait for the duration to be available before proceeding (up to 10 seconds)
      // This ensures the seek bar is populated and interaction is stable.
      if (_audioPlayer.duration == null ||
          _audioPlayer.duration == Duration.zero) {
        try {
          await _audioPlayer.durationStream
              .firstWhere((d) => d != null && d > Duration.zero)
              .timeout(const Duration(seconds: 10));
        } catch (_) {
          // Fallback if duration is never provided (e.g. some live streams)
        }
      }

      // Sync the state once more after waiting
      if (mounted) {
        setState(() {});
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

    final playerRow = Padding(
      padding: widget.padding,
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
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data ??
                    PositionData(Duration.zero, Duration.zero, Duration.zero);
                final duration = positionData.duration;
                final position = positionData.position;
                final bufferedPosition = positionData.bufferedPosition;

                final double durationSeconds = duration.inSeconds.toDouble();
                final double positionSeconds = position.inSeconds.toDouble();
                final double bufferedSeconds =
                    bufferedPosition.inSeconds.toDouble();

                // The max value is the duration, or the furthermost known point (buffered or current position)
                final double effectiveMax = durationSeconds > 0
                    ? durationSeconds
                    : (bufferedSeconds > positionSeconds
                        ? bufferedSeconds
                        : positionSeconds);

                final double safeMax = effectiveMax > 0 ? effectiveMax : 1.0;

                // Display either the active drag value or the actual position
                final currentDisplaySeconds = _dragValue ?? positionSeconds;
                final double safePosition =
                    currentDisplaySeconds.clamp(0.0, safeMax);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.0,
                        activeTrackColor: activeColor,
                        inactiveTrackColor: inactiveColor,
                        thumbColor: activeColor,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6.0),
                        overlayColor: activeColor.withAlpha(51),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: safeMax,
                        value: safePosition,
                        onChangeStart: (value) {
                          setState(() {
                            _dragValue = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _dragValue = value;
                          });
                        },
                        onChangeEnd: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                          setState(() {
                            _dragValue = null;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_dragValue != null
                                ? Duration(seconds: _dragValue!.toInt())
                                : position),
                            style: widget.timeTextStyle ??
                                const TextStyle(fontSize: 12),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: widget.timeTextStyle ??
                                const TextStyle(fontSize: 12),
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

    if (widget.useGlassEffect) {
      return OmniGlassCard(
        borderRadius:
            (widget.borderRadius as BorderRadius?) ?? BorderRadius.circular(12),
        padding: EdgeInsets.zero,
        color: widget.backgroundColor ?? Colors.white,
        opacity: 0.15,
        child: playerRow,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey.shade100,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      ),
      child: playerRow,
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
