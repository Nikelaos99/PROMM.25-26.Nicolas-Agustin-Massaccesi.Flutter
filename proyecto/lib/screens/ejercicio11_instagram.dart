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
  Widget build(BuildContext context) {
    // Obtenemos colores dinámicos según el tema actual
    final Color fondo = Theme.of(context).scaffoldBackgroundColor;
    final Color texto =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final Color iconos = Theme.of(context).iconTheme.color ?? Colors.black;

    return Scaffold(
      // Drawer lateral ubicado a la derecha (como en Instagram)
      endDrawer: const NavegacionDrawer(),

      // Fondo dinámico según el tema
      backgroundColor: fondo,

      // AppBar superior con estilo minimalista
      appBar: AppBar(
        backgroundColor: fondo, // Usa el mismo color que el Scaffold
        iconTheme: IconThemeData(color: iconos), // Íconos adaptados al tema
        // Título con nombre de usuario y flecha desplegable
        title: Row(
          children: [
            Text(
              'gatogatonson',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: iconos),
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
}
