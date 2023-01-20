import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  final List<dynamic> images;
  final FormFieldState? state;
  const CustomCarousel({
    Key? key,
    required this.images,
    this.state,
  }) : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.images.map((image) {
            if (image is String) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  image as File,
                  fit: BoxFit.cover,
                ),
              );
            }
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
              viewportFraction: 1,
              enlargeCenterPage: false,
              aspectRatio: 1,
              enableInfiniteScroll: false,
              initialPage: 0,
              autoPlay: false,
              onPageChanged: (index, reason) =>
                  setState(() => _current = index)),
        ),
        Positioned(
          bottom: 5,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map(
              (entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(_current == entry.key ? .8 : .3),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
        if (widget.state != null)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                widget.state!.value.remove(widget.images[_current]);
                widget.state!.didChange(widget.state!.value);
              },
              color: Colors.red,
              icon: const Icon(
                Icons.remove,
              ),
            ),
          )
      ],
    );
  }
}
