import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:open_filex/open_filex.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OmniFilePreviewer extends StatelessWidget {
  final String pathOrUrl;
  final bool isNetwork;

  /// Customization options
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final Widget Function(BuildContext context, VoidCallback onOpenExternally)?
      unsupportedBuilder;

  const OmniFilePreviewer({
    super.key,
    required this.pathOrUrl,
    required this.isNetwork,
    this.placeholderWidget,
    this.errorWidget,
    this.unsupportedBuilder,
  });

  String get _extension {
    try {
      if (isNetwork) {
        final uri = Uri.parse(pathOrUrl);
        return uri.pathSegments.last.split('.').last.toLowerCase();
      } else {
        return pathOrUrl.split('.').last.toLowerCase();
      }
    } catch (e) {
      return '';
    }
  }

  bool get _isPdf => _extension == 'pdf';
  bool get _isImage =>
      ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(_extension);

  Future<void> _openExternally() async {
    if (isNetwork) {
      debugPrint(
          "External opening for network URLs is limited. Consider downloading first.");
    } else {
      final result = await OpenFilex.open(pathOrUrl);
      if (result.type != ResultType.done) {
        debugPrint("Could not open file: \${result.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPdf) {
      return isNetwork
          ? SfPdfViewer.network(pathOrUrl)
          : SfPdfViewer.file(File(pathOrUrl));
    }

    if (_isImage) {
      return isNetwork
          ? CachedNetworkImage(
              imageUrl: pathOrUrl,
              placeholder: (context, url) =>
                  placeholderWidget ??
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  errorWidget ?? const Icon(Icons.error),
              fit: BoxFit.contain,
            )
          : Image.file(
              File(pathOrUrl),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  errorWidget ?? const Icon(Icons.error),
            );
    }

    // For docx, xlsx, pptx, etc. provide a button to open externally
    if (unsupportedBuilder != null) {
      return unsupportedBuilder!(context, _openExternally);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'This file format cannot be previewed directly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isNetwork ? null : _openExternally,
              icon: const Icon(Icons.open_in_new),
              label: Text(isNetwork
                  ? 'Download required to open'
                  : 'Open in External App'),
            ),
          ],
        ),
      ),
    );
  }
}
