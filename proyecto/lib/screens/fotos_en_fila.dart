// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Widget que muestra una fila de imágenes horizontales
class FotosEnFila extends StatelessWidget {
  const FotosEnFila({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // AppBar superior con título fijo
    appBar: AppBar(title: const Text('Fotos en Fila')),

    // Cuerpo centrado vertical y horizontalmente
    body: Center(
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra la fila horizontalmente
        children: [
          // Imagen 1 desde Picsum con tamaño fijo
          Image.network(
            'https://picsum.photos/100?image=10',
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 10), // Espaciado horizontal entre imágenes
          // Imagen 2
          Image.network(
            'https://picsum.photos/100?image=20',
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 10),

          // Imagen 3
          Image.network(
            'https://picsum.photos/100?image=30',
            width: 100,
            height: 100,
          ),
        ],
      ),
    ),
  );
}
