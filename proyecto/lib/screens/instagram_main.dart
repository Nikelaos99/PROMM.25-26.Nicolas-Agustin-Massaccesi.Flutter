// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Importa los tres componentes que conforman la interfaz estilo Instagram
import 'package:proyecto/screens/instagram/instagram_top.dart'; // Encabezado (foto, nombre, etc.)
import 'package:proyecto/screens/instagram/instagram_middle.dart'; // Contenido principal (imagen, texto)
import 'package:proyecto/screens/instagram/instagram_bottom.dart'; // Botones de interacción (like, comment, etc.)

// Widget principal que representa una pantalla con diseño inspirado en Instagram
class Instagram extends StatelessWidget {
  const Instagram({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // Drawer lateral ubicado a la derecha (como en Instagram)
    endDrawer: const NavegacionDrawer(),

    // Fondo blanco para mantener el estilo visual de Instagram
    backgroundColor: Colors.white,

    // AppBar superior con estilo minimalista
    appBar: AppBar(
      backgroundColor: Colors.white, // Fondo blanco como en Instagram
      iconTheme: IconThemeData(color: Colors.black), // Íconos en negro
      // Título con nombre de usuario y flecha desplegable
      title: const Row(
        children: [
          Text('gatogatonson', style: TextStyle(color: Colors.black)),
          Icon(Icons.keyboard_arrow_down_rounded),
        ],
      ),
    ),

    // Cuerpo dividido en tres secciones verticales
    body: const Column(
      children: [
        InstagramTop(), // Parte superior: perfil, historia, etc.
        InstagramMiddle(), // Parte media: imagen o contenido principal
        InstagramBottom(), // Parte inferior: botones de interacción
      ],
    ),
  );
}
