import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class OmniVideoPlayer extends StatefulWidget {
  final String? url;
  final File? file;
  
  /// Player configuration
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final double? aspectRatio;
  
  /// Custom UI Elements
  final Widget? placeholder;
  final Widget Function(BuildContext, String)? errorBuilder;
  final ChewieProgressColors? materialProgressColors;
  final Color backgroundColor;
  
  /// Whether to use a background Isolate to validate the media (e.g., DNS lookup or file check)
  /// before initializing the player. This prevents main-thread jank for slow connections.
  final bool useBackgroundValidation;

  const OmniVideoPlayer({
    super.key,
    this.url,
    this.file,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.aspectRatio,
    this.placeholder,
    this.errorBuilder,
    this.materialProgressColors,
    this.backgroundColor = Colors.black,
    this.useBackgroundValidation = false,
  }) : assert(url != null || file != null, 'Provide either a url or a file');

  @override
  State<OmniVideoPlayer> createState() => _OmniVideoPlayerState();
}

class _OmniVideoPlayerState extends State<OmniVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  static Future<bool> _validateMediaInBackground(Map<String, dynamic> args) async {
    final url = args['url'] as String?;
    final filePath = args['file'] as String?;
    
    try {
      if (filePath != null) {
        return File(filePath).existsSync();
      } else if (url != null) {
        final client = HttpClient();
        final request = await client.getUrl(Uri.parse(url));
        final response = await request.close();
        return response.statusCode < 400;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> _runBackgroundValidation(String? url, String? filePath) async {
    return await Isolate.run(() => _validateMediaInBackground({
          'url': url,
          'file': filePath,
        }));
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.useBackgroundValidation) {
        final isValid = await _runBackgroundValidation(widget.url, widget.file?.path);
        if (!isValid) {
          debugPrint("OmniVideoPlayer: Validation failed");
          // We don't throw anymore to let the native player try its own logic
        }
      }

      if (widget.file != null) {
        _videoPlayerController = VideoPlayerController.file(widget.file!);
      } else if (widget.url != null) {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
      }

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        aspectRatio: widget.aspectRatio ?? _videoPlayerController.value.aspectRatio,
        placeholder: widget.placeholder,
        materialProgressColors: widget.materialProgressColors,
        errorBuilder: widget.errorBuilder ?? (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      setState(() {});
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _errorMessage);
      }
      return Container(
        color: widget.backgroundColor,
        child: const Center(
          child: Text(
            'Failed to load video.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return Container(
        color: widget.backgroundColor,
        child: AspectRatio(
          aspectRatio: widget.aspectRatio ?? _videoPlayerController.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
      );
    } else {
      return Container(
        color: widget.backgroundColor,
        child: widget.placeholder ?? const Center(child: CircularProgressIndicator()),
      );
    }
  }
}
