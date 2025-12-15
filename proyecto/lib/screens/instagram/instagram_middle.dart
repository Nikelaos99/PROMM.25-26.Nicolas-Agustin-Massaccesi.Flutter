// Importa el paquete de Material Design de Flutter
import 'package:flutter/material.dart';
// Importa url_launcher para abrir enlaces externos
import 'package:url_launcher/url_launcher.dart';

// Widget que representa la sección media de un perfil estilo Instagram
class InstagramMiddle extends StatelessWidget {
  const InstagramMiddle({super.key}); // Constructor constante

  // Función para abrir el enlace en el navegador
  Future<void> _abrirEnlace(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos color dinámico para texto según el tema actual
    final Color textoColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Column(
      children: [
        // Información del perfil: nombre, biografía y enlace
        Padding(
          padding: const EdgeInsets.only(left: 12.0), // Espaciado izquierdo
          child: Row(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinea el texto a la izquierda
                children: [
                  // Nombre del perfil en negrita
                  Text(
                    "Gato Gatonson",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textoColor, // color dinámico
                    ),
                  ),
                  const SizedBox(height: 4), // Espaciado entre líneas
                  // Biografía o frase personal
                  Text(
                    "¡Miau, miau, ronroneo! 🐾",
                    style: TextStyle(color: textoColor),
                  ),

                  const SizedBox(height: 4),

                  // Enlace externo estilizado en azul y subrayado
                  InkWell(
                    onTap: () => _abrirEnlace(
                      'https://github.com/Nikelaos99/PROMM.25-26.Nicolas-Agustin-Massaccesi.Flutter',
                    ),
                    child: const Text(
                      "Mi Repositorio",
                      style: TextStyle(
                        color: Colors
                            .blue, // 👈 se mantiene azul como hipervínculo
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Followed by ", // texto normal
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text:
                              "sara, padiya, nicomassaccesi ", // 👈 solo esta palabra en negrita
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "and ",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text:
                              "\n22 others", // 👈 solo esta palabra en negrita
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8), // Espaciado entre secciones
        // Fila de botones de acción estilo Instagram
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botón Following con flecha
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Following"),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),

            // Botón Message
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text("Message"),
            ),

            // Botón Email
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text("Email"),
            ),

            // Botón solo con flecha hacia abajo
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12), // Espaciado final
      ],
    );
  }
}
