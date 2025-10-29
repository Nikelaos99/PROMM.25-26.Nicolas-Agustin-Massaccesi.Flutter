// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Widget principal de la pantalla "Reto"
class Reto extends StatelessWidget {
  const Reto({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // AppBar superior con título fijo
    appBar: AppBar(title: const Text('Reto')),

    // Cuerpo que ocupa toda la pantalla y centra su contenido
    body: Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      height: double.infinity, // Ocupa toda la altura disponible
      alignment: Alignment.center, // Centra el contenido hijo
      child: MyCardContainer(), // Tarjeta personalizada
    ),
  );
}

// Widget que representa una tarjeta decorativa con texto
class MyCardContainer extends StatelessWidget {
  const MyCardContainer({super.key}); // Constructor constante

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30), // Margen externo alrededor de la tarjeta
      height: 160, // Altura fija de la tarjeta
      // Decoración visual de la tarjeta
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        gradient: LinearGradient(
          // Fondo con degradado horizontal
          colors: [Colors.lightGreen, Colors.brown],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.25, 0.90], // Controla la transición del degradado
        ),
        boxShadow: [
          // Sombra para dar profundidad
          BoxShadow(
            color: Color(0xFF101012), // Color oscuro para sombra
            offset: Offset(-12, 12), // Desplazamiento de la sombra
            blurRadius: 8, // Difuminado
          ),
        ],
      ),

      alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
      padding: EdgeInsets.all(20), // Espaciado interno
      // Texto principal de la tarjeta
      child: Text(
        'Challenge',
        style: TextStyle(
          fontSize: 46,
          color: Colors.white,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
