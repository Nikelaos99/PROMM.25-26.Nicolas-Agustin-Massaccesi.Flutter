// Importa todas las pantallas necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

class AppRoutes {
  // Definición de nombres constantes para las rutas
  static const String splash = '/splash_screen';
  static const String home = '/ejercicio1_home_screen';
  static const String imagenRepresentativa =
      '/ejercicio2_imagen_representativa';
  static const String fotosColumna = '/ejercicio3_fotos_en_columna';
  static const String iconos = '/ejercicio4_iconos';
  static const String fotosColumna2 = '/ejercicio5_fotos_en_columna2';
  static const String textos = '/ejercicio6_textos';
  static const String repetidas = '/ejercicio7_imagenes_repetidas';
  static const String piramide = '/ejercicio8_piramide';
  static const String reto = '/ejercicio9_reto';
  static const String contador = '/ejercicio10_contador';
  static const String instagram = '/ejercicio11_instagram';
  static const String colores = '/ejercicio12_colores_aleatorios';
  static const String juego = '/ejercicio13_juego';
  static const String temaOscuro = '/ejercicio14_tema_oscuro';
  static const String formulario = '/ejercicio15_formulario';
  static const String formulario2 = '/ejercicio16_formulario2';

  // Mapa de rutas que vincula cada nombre con su widget correspondiente
  static Map<String, WidgetBuilder> obtenerRutas(
    void Function(bool) cambiarTema,
    ThemeMode modoTema,
  ) {
    return {
      splash: (context) => const SplashScreen(),
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
      temaOscuro: (context) =>
          TemaOscuro(cambiarTema: cambiarTema, modoTema: modoTema),
      formulario: (context) => const Formulario(),
      formulario2: (context) => const Formulario2(),
    };
  }
}
