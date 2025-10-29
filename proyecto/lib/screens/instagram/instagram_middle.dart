// Importa el paquete de Material Design de Flutter
import 'package:flutter/material.dart';

// Widget que representa la sección media de un perfil estilo Instagram
class InstagramMiddle extends StatelessWidget {
  const InstagramMiddle({super.key}); // Constructor constante

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 📝 Información del perfil: nombre, biografía y enlace
        const Padding(
          padding: EdgeInsets.only(left: 12.0), // Espaciado izquierdo
          child: Row(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinea el texto a la izquierda
                children: [
                  // Nombre del perfil en negrita
                  Text(
                    "Gato Gatonson",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4), // Espaciado entre líneas
                  // Biografía o frase personal
                  Text("\"¡Miau, miau, ronroneo!.\""),
                  SizedBox(height: 4),

                  // Enlace externo estilizado en azul
                  Text(
                    "faqsandroid.com/",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8), // Espaciado entre secciones
        // 🔧 Botón para editar el perfil
        ElevatedButton(
          onPressed: () {}, // Acción al presionar (vacía por ahora)
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 80,
              vertical: 12,
            ), // Tamaño del botón
          ),
          child: const Text("Editar perfil"),
        ),

        const SizedBox(height: 12), // Espaciado final
      ],
    );
  }
}
