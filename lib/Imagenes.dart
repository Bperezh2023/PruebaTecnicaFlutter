import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '';

class ImageCarouselPage extends StatelessWidget {

  List<String> randomImageUrls() {
    Random random = Random();
    List<String> imageUrls = [];

    for (int i = 0; i < 4; i++) {
      int randomNumber = random.nextInt(100);
      String imageUrl = 'https://placeimg.com/200/300/$randomNumber';
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = randomImageUrls();
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrusel de imágenes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400,
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Gracias por ver, espero ser el elegido :D',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}