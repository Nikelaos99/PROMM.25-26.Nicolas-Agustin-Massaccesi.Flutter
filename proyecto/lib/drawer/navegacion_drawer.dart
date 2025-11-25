// Importa Material y los exports centrales del proyecto (widgets compartidos, rutas, etc.)
import 'package:flutter/material.dart';
import 'package:proyecto/screens/screens.dart';

// Drawer reutilizable para navegación lateral
class NavegacionDrawer extends StatelessWidget {
  const NavegacionDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    // Column principal: header fijo arriba y lista de opciones que ocupa el resto
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Cabecera con avatar, nombre y email
        buildHeader(context),
        // El ListView de opciones queda dentro de un Expanded para ocupar el espacio restante
        Expanded(child: buildMenuItems(context)),
      ],
    ),
  );
}

// Cabecera del Drawer
Widget buildHeader(BuildContext context) => Container(
  // Usa el color de la AppBar según el tema activo
  color:
      Theme.of(context).appBarTheme.backgroundColor ??
      Theme.of(context).colorScheme.primary,

  // Padding superior igual al inset del sistema (status bar) para evitar solapamiento
  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
  child: const Column(
    children: [
      // Avatar circular con imagen remota
      CircleAvatar(
        radius: 52,
        backgroundImage: NetworkImage('https://picsum.photos/250?image=22'),
      ),
      SizedBox(height: 12),
      // Nombre del usuario en grande y en blanco
      Text('Nicolás Massaccesi', style: TextStyle(fontSize: 28)),
      // Email en tamaño menor
      Text('nicomassaccesi@outlook.com', style: TextStyle(fontSize: 16)),
    ],
  ),
);

// Lista de ítems del menú del Drawer
Widget buildMenuItems(BuildContext context) => ListView(
  children: [
    // Cada ListTile muestra un ícono, un texto y navega a la ruta correspondiente
    ListTile(
      leading: const Icon(Icons.home_outlined),
      title: const Text('Nombre y Repositorio'),
      onTap: () {
        // Reemplaza la ruta actual por la de splash que luego cambiara a la de home
        Navigator.pushReplacementNamed(context, AppRoutes.splash);
      },
    ),
    ListTile(
      leading: const Icon(Icons.contact_emergency),
      title: const Text('Imagen Representativa'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.imagenRepresentativa);
      },
    ),
    ListTile(
      leading: const Icon(Icons.view_column_outlined),
      title: const Text('Fotos en Columna'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.fotosColumna);
      },
    ),
    ListTile(
      leading: const Icon(Icons.workspaces_outline),
      title: const Text('Iconos'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.iconos);
      },
    ),
    ListTile(
      leading: const Icon(Icons.view_column),
      title: const Text('Fotos en Columna 2'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.fotosColumna2);
      },
    ),

    ListTile(
      leading: const Icon(Icons.text_snippet_outlined),
      title: const Text('Textos'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.textos);
      },
    ),
    ListTile(
      leading: const Icon(Icons.photo_library_outlined),
      title: const Text('Imágenes Repetidas'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.repetidas);
      },
    ),
    ListTile(
      leading: const Icon(Icons.keyboard_arrow_up_outlined),
      title: const Text('Pirámide'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.piramide);
      },
    ),
    ListTile(
      leading: const Icon(Icons.star),
      title: const Text('Reto'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.reto);
      },
    ),
    ListTile(
      leading: const Icon(Icons.numbers),
      title: const Text('Contador'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.contador);
      },
    ),
    ListTile(
      leading: const Icon(Icons.camera_alt),
      title: const Text('Instagram'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.instagram);
      },
    ),

    ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Colores Aleatorios'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.colores);
      },
    ),
    ListTile(
      leading: const Icon(Icons.gamepad),
      title: const Text('Juego'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.juego);
      },
    ),
    ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Tema Oscuro'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.temaOscuro);
      },
    ),
    ListTile(
      leading: const Icon(Icons.insert_drive_file),
      title: const Text('Formulario'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.formulario);
      },
    ),
    ListTile(
      leading: const Icon(Icons.insert_drive_file_outlined),
      title: const Text('Formulario 2'),
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.formulario2);
      },
    ),
  ],
);
