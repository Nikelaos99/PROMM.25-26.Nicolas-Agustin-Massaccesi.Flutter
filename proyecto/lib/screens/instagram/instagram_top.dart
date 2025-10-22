import 'package:flutter/material.dart';

class InstagramTop extends StatelessWidget {
  const InstagramTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45), // Redondea la imagen
                  image: const DecorationImage(
                    image: AssetImage('assets/images/instagram/retrato.jpg'),
                    fit: BoxFit.cover, // Para que la imagen cubra todo el área
                  ),
                ),
              ),
            ],
          ),
          const Column(
            children: [
              Text("1.026",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Publicaciones"),
            ],
          ),
          const Column(
            children: [
              Text("666",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Seguidores"),
            ],
          ),
          const Column(
            children: [
              Text("211",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Seguidos"),
            ],
          ),
        ],
      ),
    );
  }
}
