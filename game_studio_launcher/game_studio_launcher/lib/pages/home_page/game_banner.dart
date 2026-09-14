import 'dart:io';

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// Banner art for a game.
///
/// The catalog mixes two kinds of source: games that shipped with the launcher
/// point at an http(s) URL, while games added through the in-app form point at
/// a file the user picked off this machine. Both are handled here, and anything
/// that fails to load (no network, file since deleted, blank field) falls back
/// to a placeholder instead of Flutter's red error box.
class GameBanner extends StatelessWidget {
  const GameBanner({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
  });

  final String imagePath;
  final double? width;
  final double? height;

  bool get _isRemote =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _placeholder(context);
    }

    if (_isRemote) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) => _placeholder(context),
      );
    }

    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, _, __) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        width: width,
        height: height,
        color: FlutterFlowTheme.of(context).accent4,
        child: Icon(
          Icons.videogame_asset_outlined,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 48.0,
        ),
      );
}
