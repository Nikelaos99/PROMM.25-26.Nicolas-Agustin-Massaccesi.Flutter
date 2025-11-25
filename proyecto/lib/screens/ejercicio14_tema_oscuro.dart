import 'package:proyecto/screens/screens.dart';

class TemaOscuro extends StatefulWidget {
  // Función que recibe el cambio del Switch
  final void Function(bool) cambiarTema;

  // Estado actual del tema (claro u oscuro)
  final ThemeMode modoTema;

  const TemaOscuro({
    super.key,
    required this.cambiarTema,
    required this.modoTema,
  });

  @override
  State<TemaOscuro> createState() => _TemaOscuroState();
}

class _TemaOscuroState extends State<TemaOscuro> {
  late bool _activado;

  @override
  void initState() {
    super.initState();
    _activado = widget.modoTema == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavegacionDrawer(), // Drawer de navegación
      appBar: AppBar(title: const Text('Tema Oscuro')), // Título de la pantalla
      body: Center(
        child: SwitchListTile(
          title: const Text('Activar Tema Oscuro'),
          value: _activado, // Estado local del Switch
          onChanged: (valor) {
            setState(() {
              _activado = valor; // actualiza inmediatamente el switch
            });
            widget.cambiarTema(valor); // cambia el tema global
          },
        ),
      ),
    );
  }
}
