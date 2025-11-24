// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Widget que representa una pirámide de animales con imágenes y etiquetas
class Piramide extends StatelessWidget {
  const Piramide({super.key}); // Constructor constante con clave opcional

  @override
  Widget build(BuildContext context) => Scaffold(
    // Drawer lateral para navegación entre pantallas
    drawer: const NavegacionDrawer(),

    // AppBar superior con título fijo
    appBar: AppBar(title: const Text('Pirámide')),

    // Cuerpo centrado vertical y horizontalmente
    body: Center(
      child: Builder(
        builder: (context) {
          // Obtiene el ancho de pantalla para adaptar el diseño
          final screenWidth = MediaQuery.of(context).size.width;

          double imageSize;
          double fontSize;

          // Define tamaños de imagen y texto según el ancho de pantalla
          if (screenWidth < 600) {
            imageSize = 80;
            fontSize = 14;
          } else if (screenWidth < 1200) {
            imageSize = 100;
            fontSize = 16;
          } else {
            imageSize = 120;
            fontSize = 18;
          }

          // Construye la pirámide con filas de imágenes y etiquetas
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 🟦 Nivel superior: 1 imagen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/capybara.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Capybara', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                ],
              ),

              // 🟨 Segundo nivel: 2 imágenes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/conejo.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Conejo', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/huron.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Hurón', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                ],
              ),

              // 🟥 Tercer nivel: 3 imágenes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/perro.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Perro', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/cacatua.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Cacatúa', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/gato.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Gato', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
