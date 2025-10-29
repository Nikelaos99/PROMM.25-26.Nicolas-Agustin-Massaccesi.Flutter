// Importa el paquete de Material Design de Flutter
import 'package:flutter/material.dart';

// Widget que representa la parte superior de un perfil estilo Instagram
class InstagramTop extends StatelessWidget {
  const InstagramTop({super.key}); // Constructor constante

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Espaciado alrededor del contenido
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceEvenly, // Distribuye los elementos equitativamente
        children: [
          // 📸 Foto de perfil circular
          Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    45,
                  ), // Hace la imagen perfectamente circular
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/instagram/retrato.jpg',
                    ), // Imagen local
                    fit:
                        BoxFit.cover, // Cubre todo el contenedor sin deformarse
                  ),
                ),
              ),
            ],
          ),

          // 📊 Estadísticas: Publicaciones
          const Column(
            children: [
              Text(
                "1.026",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text("Publicaciones"),
            ],
          ),

          // 📊 Estadísticas: Seguidores
          const Column(
            children: [
              Text(
                "666",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text("Seguidores"),
            ],
          ),

          // 📊 Estadísticas: Seguidos
          const Column(
            children: [
              Text(
                "211",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text("Seguidos"),
            ],
          ),
        ],
      ),
    );
  }
}
