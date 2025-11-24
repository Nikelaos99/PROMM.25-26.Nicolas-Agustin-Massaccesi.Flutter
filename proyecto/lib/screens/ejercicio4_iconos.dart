// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Widget que muestra una fila de íconos con distintos estilos y colores
class Iconos extends StatelessWidget {
  const Iconos({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // AppBar superior con título fijo y color azul personalizado
    appBar: AppBar(title: const Text('Iconos'), backgroundColor: Colors.blue),

    // Cuerpo centrado vertical y horizontalmente
    body: Center(
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra la fila horizontalmente
        children: [
          // Ícono de alarma en rojo
          Icon(Icons.alarm, size: 40, color: Colors.red),
          SizedBox(width: 20), // Espaciado horizontal entre íconos
          // Ícono de estrella en amarillo
          Icon(Icons.star, size: 40, color: Colors.yellow),
          SizedBox(width: 20),

          // Ícono de persona en verde
          Icon(Icons.person, size: 40, color: Colors.green),
          SizedBox(width: 20),

          // Ícono de configuración en azul
          Icon(Icons.settings, size: 40, color: Colors.blue),
          SizedBox(width: 20),

          // Ícono de mascota en púrpura
          Icon(Icons.pets, size: 40, color: Colors.purple),
        ],
      ),
    ),
  );
}
