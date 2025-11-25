// Importa el paquete de Material Design de Flutter
import 'package:flutter/material.dart';

// Widget que representa la parte superior de un perfil estilo Instagram
class InstagramTop extends StatelessWidget {
  const InstagramTop({super.key}); // Constructor constante

  @override
  Widget build(BuildContext context) {
    // 🎨 Obtenemos el color de texto según el tema actual
    final Color textoColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

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
          Column(
            children: [
              Text(
                "1.026",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textoColor, // 👈 color dinámico
                ),
              ),
              Text("Publicaciones", style: TextStyle(color: textoColor)),
            ],
          ),

          // 📊 Estadísticas: Seguidores
          Column(
            children: [
              Text(
                "666",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textoColor,
                ),
              ),
              Text("Seguidores", style: TextStyle(color: textoColor)),
            ],
          ),

          // 📊 Estadísticas: Seguidos
          Column(
            children: [
              Text(
                "211",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textoColor,
                ),
              ),
              Text("Seguidos", style: TextStyle(color: textoColor)),
            ],
          ),
        ],
      ),
    );
  }
}
