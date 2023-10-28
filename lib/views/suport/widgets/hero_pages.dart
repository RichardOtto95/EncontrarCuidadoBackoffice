import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final String imgLink;

  const HeroImage({Key key, this.imgLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _transformationController = TransformationController();
    TapDownDetails _doubleTapDetails;

    void _handleDoubleTap() {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      } else {
        final position = _doubleTapDetails.localPosition;
        // For a 3x zoom
        _transformationController.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
        // Fox a 2x zoom
        // ..translate(-position.dx, -position.dy)
        // ..scale(2.0);
      }
    }

    void _handleDoubleTapDown(TapDownDetails details) {
      _doubleTapDetails = details;
    }

    return Scaffold(
        body: Center(
      child: Hero(
          tag: "image",
          child: GestureDetector(
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: .1,
              maxScale: 6,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          imgLink,
                        ),
                        fit: BoxFit.cover)),
              ),
            ),
          )),
    ));
  }
}

class HeroFile extends StatelessWidget {
  final String imgLink;

  const HeroFile({Key key, this.imgLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Hero(
      tag: "file",
      child: Container(
        width: double.infinity,
        height: 400.0,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  imgLink,
                ),
                fit: BoxFit.cover)),
      ),
    ));
  }
}
