// Importa todas las pantallas necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

class AppRoutes {
  // 🛣️ Definición de nombres constantes para las rutas
  // Estas constantes se usan para navegar entre pantallas de forma segura
  static const String home =
      '/ejercicio1_home_screen'; // Ruta principal (pantalla de inicio)
  static const String imagenRepresentativa =
      '/ejercicio2_imagen_representativa'; // Pantalla que muestra una imagen que me representa y mi nombre
  static const String fotosColumna =
      '/ejercicio3_fotos_en_columna'; // Pantalla que muestra fotos en una columna
  static const String iconos =
      '/ejercicio4_iconos'; // Pantalla con íconos personalizados
  static const String fotosColumna2 =
      '/ejercicio5_fotos_en_columna2'; // Pantalla que muestra fotos en una columna
  static const String textos =
      '/ejercicio6_textos'; // Pantalla con estilos de texto
  static const String repetidas =
      '/ejercicio7_imagenes_repetidas'; // Pantalla con la misma imagen cargada de distintas formas
  static const String piramide =
      '/ejercicio8_piramide'; // Pantalla con estructura tipo pirámide
  static const String reto =
      '/ejercicio9_reto'; // Pantalla de desafío o actividad
  static const String contador =
      '/ejercicio10_contador'; // Pantalla con contador interactivo
  static const String instagram =
      '/ejercicio11_instagram'; // Pantalla estilo Instagram
  static const String colores =
      '/ejercicio12_colores_aleatorios'; // Pantalla con minijuego de colores
  static const String juego =
      '/ejercicio13_juego'; // Pantalla con juego de hacer clic en imagenes

  // 🗺️ Mapa de rutas que vincula cada nombre con su widget correspondiente
  // Este mapa se usa por Flutter para construir la pantalla cuando se navega a una ruta
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    imagenRepresentativa: (context) => const ImagenRepresentativa(),
    fotosColumna: (context) => const FotosEnColumna(),
    iconos: (context) => const Iconos(),
    fotosColumna2: (context) => const FotosEnColumna2(),
    textos: (context) => const Textos(),
    repetidas: (context) => const ImagenesRepetidas(),
    piramide: (context) => const Piramide(),
    instagram: (context) => const Instagram(),
    reto: (context) => const Reto(),
    contador: (context) => const Contador(),
    colores: (context) => const RandomColors(),
    juego: (context) => const Juego(),
  };
}
