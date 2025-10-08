import 'package:proyecto/screens/screens.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Textos extends StatelessWidget {
  const Textos({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Textos')),
    drawer: const NavegacionDrawer(),
    body: Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber[100],
            child: Text(
              'Este es el primer recuadro con texto justificado.\nLa fuente utilizada es Georgia, clásica y elegante.\nCuenta con la opcion ellipsis de TextOverflow, que agrega puntos suspensivos (...) al final para indicar que el texto fue truncado.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18, fontFamily: 'Georgia'),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[100],
            child: AutoSizeText(
              'Este es el segundo recuadro. Utiliza una fuente sans-serif moderna para dar un estilo más limpio y profesional; ideal para interfaces claras y legibles. Ademas de contar con la dependencia AutoSizeText para un tamaño de fuente responsive al tamaño del recuadro.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 50, fontFamily: 'Roboto'),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green[100],
            child: Text(
              'Este es el tercer recuadro. Aquí usamos una fuente importada desde Google Fonts llamada Lobster, que aporta personalidad y estilo al texto. Perfecta para títulos o bloques destacados. Cuenta con la opcion fade de TextOveflow, que hace que el texto "desaparezca" al llegar al limite del recuadro.',
              textAlign: TextAlign.justify,
              style: GoogleFonts.lobster(fontSize: 18),
              overflow: TextOverflow.fade,
              softWrap: true,
            ),
          ),
        ),
      ],
    ),
  );
}
