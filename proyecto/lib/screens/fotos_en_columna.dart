// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Widget que muestra una serie de imágenes organizadas verticalmente en una columna
class FotosEnColumna extends StatelessWidget {
  const FotosEnColumna({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // AppBar superior con título fijo
    appBar: AppBar(title: const Text('Fotos en Columna')),

    // Cuerpo centrado vertical y horizontalmente
    body: Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra los elementos verticalmente
        children: [
          // Imagen 1 desde Picsum con tamaño fijo
          Image.network(
            'https://picsum.photos/100?image=5',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10), // Espaciado entre imágenes
          // Imagen 2
          Image.network(
            'https://picsum.photos/100?image=15',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),

          // Imagen 3
          Image.network(
            'https://picsum.photos/100?image=25',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),

          // Imagen 4
          Image.network(
            'https://picsum.photos/100?image=30',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),

          // Imagen 5
          Image.network(
            'https://picsum.photos/100?image=35',
            width: 100,
            height: 100,
          ),
        ],
      ),
    ),
  );
}
