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
  // Fondo azul oscuro para contraste
  color: Colors.blue.shade700,
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
      Text(
        'Nicolás Massaccesi',
        style: TextStyle(fontSize: 28, color: Colors.white),
      ),
      // Email en tamaño menor
      Text(
        'nicomassaccesi@outlook.com',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
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
        // Reemplaza la ruta actual por la de inicio
        Navigator.pushReplacementNamed(context, '/');
      },
    ),
    ListTile(
      leading: const Icon(Icons.table_rows),
      title: const Text('Fotos en Fila'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/fotos_fila');
      },
    ),
    ListTile(
      leading: const Icon(Icons.view_column),
      title: const Text('Fotos en Columna'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/fotos_columna');
      },
    ),
    ListTile(
      leading: const Icon(Icons.workspaces_outline),
      title: const Text('Iconos'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/iconos');
      },
    ),
    ListTile(
      leading: const Icon(Icons.keyboard_arrow_up_outlined),
      title: const Text('Pirámide'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/piramide');
      },
    ),
    ListTile(
      leading: const Icon(Icons.text_snippet_outlined),
      title: const Text('Textos'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/textos');
      },
    ),
    ListTile(
      leading: const Icon(Icons.star),
      title: const Text('Reto'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/reto');
      },
    ),
    ListTile(
      leading: const Icon(Icons.camera_alt),
      title: const Text('Instagram'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/instagram');
      },
    ),
    ListTile(
      leading: const Icon(Icons.numbers),
      title: const Text('Contador'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/contador');
      },
    ),
    ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Colores Aleatorios'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/colores_aleatorios');
      },
    ),
    ListTile(
      leading: const Icon(Icons.gamepad),
      title: const Text('Juego'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/juego');
      },
    ),
  ],
);
