import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: 0.3,
          image: AssetImage('images/digital-transfer.jpeg'),
        )
      ),
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
        items: [
          //1st Image of Slider
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('images/home/image-0.png'),
              const SizedBox(height: 10,),
              const Center(
                child: Text(
                  'Welcome to BankIO\nYour trusted app for a safe transfer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF00214E),
                  ),
                ),
              )
            ],
          ),

          //2nd Image of Slider
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('images/home/image-1.png'),
              const SizedBox(height: 10,),
              const Center(
                child: Text(
                  'Automate your transfers safely and easily with our app!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF00214E),
                  ),
                ),
              )
            ],
          ),
        ],

        //Slider Container properties
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(seconds: 2),
          viewportFraction: 1,
        ),
      ),
    );
  }
}


