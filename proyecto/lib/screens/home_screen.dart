// Importa todas las pantallas y utilidades desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Importa Google Fonts para aplicar tipografías personalizadas
import 'package:google_fonts/google_fonts.dart';

// Widget principal de la pantalla de inicio
class HomePage extends StatelessWidget {
  const HomePage({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // AppBar superior con título fijo
    appBar: AppBar(title: const Text('Home')),

    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // Cuerpo centrado vertical y horizontalmente
    body: Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra los elementos verticalmente
        children: [
          // Nombre estilizado con fuente Lobster
          Text(
            'Nicolás Massaccesi',
            style: GoogleFonts.lobster(fontSize: 32, color: Colors.black),
          ),
          // Enlace al repositorio de GitHub con fuente Roboto
          Text(
            'https://github.com/Nikelaos99/PROMM.25-26.Nicolas-Agustin-Massaccesi.Flutter',
            style: GoogleFonts.roboto(fontSize: 24, color: Colors.black),
            textAlign: TextAlign.center, // Centra el texto horizontalmente
          ),
        ],
      ),
    ),
  );
}
