// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Importa Google Fonts para usar fuentes personalizadas
import 'package:google_fonts/google_fonts.dart';

// Importa AutoSizeText para ajustar el tamaño del texto automáticamente según el espacio disponible
import 'package:auto_size_text/auto_size_text.dart';

// Widget principal que muestra tres recuadros de texto con diferentes estilos y comportamientos
class Textos extends StatelessWidget {
  const Textos({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // AppBar superior con título fijo
    appBar: AppBar(title: const Text('Textos')),

    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // Cuerpo principal con tres bloques verticales
    body: Column(
      children: [
        // 🟨 Primer recuadro: texto con fuente Georgia y overflow ellipsis
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16), // Espaciado interno
            color: Colors.amber[100], // Fondo amarillo claro
            child: Text(
              'Este es el primer recuadro con texto justificado.\nLa fuente utilizada es Georgia, clásica y elegante.\nCuenta con la opcion ellipsis de TextOverflow, que agrega puntos suspensivos (...) al final para indicar que el texto fue truncado.',
              textAlign: TextAlign.justify, // Justifica el texto
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Georgia',
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis, // Trunca con puntos suspensivos
              softWrap: true, // Permite que el texto se divida en varias líneas
            ),
          ),
        ),

        // 🟦 Segundo recuadro: texto con fuente Roboto y AutoSizeText
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[100],
            child: AutoSizeText(
              'Este es el segundo recuadro. Utiliza una fuente sans-serif moderna para dar un estilo más limpio y profesional; ideal para interfaces claras y legibles. Ademas de contar con la dependencia AutoSizeText para un tamaño de fuente responsive al tamaño del recuadro.',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 50,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
              overflow: TextOverflow.visible, // No trunca el texto
              softWrap: true,
            ),
          ),
        ),

        // 🟩 Tercer recuadro: texto con fuente Lobster desde Google Fonts y overflow fade
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green[100],
            child: Text(
              'Este es el tercer recuadro. Aquí usamos una fuente importada desde Google Fonts llamada Lobster, que aporta personalidad y estilo al texto. Perfecta para títulos o bloques destacados. Cuenta con la opcion fade de TextOveflow, que hace que el texto "desaparezca" al llegar al limite del recuadro.',
              textAlign: TextAlign.justify,
              style: GoogleFonts.lobster(fontSize: 18, color: Colors.black),
              overflow: TextOverflow.fade, // El texto se desvanece al final
              softWrap: true,
            ),
          ),
        ),
      ],
    ),
  );
}
