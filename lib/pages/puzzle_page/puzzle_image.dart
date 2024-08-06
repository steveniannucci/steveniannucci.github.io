// puzzle_image.dart

import 'package:flutter/material.dart';

class PuzzleImage extends StatefulWidget {
  final int taskNum;
  final int completedTasks;

  const PuzzleImage({
    Key? key,
    required this.taskNum,
    required this.completedTasks,
  }) : super(key: key);

  @override
  _PuzzleImageState createState() => _PuzzleImageState();
}

class _PuzzleImageState extends State<PuzzleImage> {
  late Image _image;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant PuzzleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.taskNum != widget.taskNum || oldWidget.completedTasks != widget.completedTasks) {
      _loadImage();
    }
  }

  void _loadImage() {
    setState(() {
      _isLoaded = false;
    });

    _image = Image.asset(
      'assets/puzzles/${widget.taskNum}/${widget.completedTasks}.png',
      width: 280,
      height: 280,
      fit: BoxFit.cover,
    );

    final ImageStreamListener listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });

    _image.image.resolve(ImageConfiguration()).addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? _image
        : Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}