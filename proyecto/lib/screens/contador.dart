// Importa todas las pantallas y utilidades necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

// Widget principal que representa la pantalla del contador
class Contador extends StatelessWidget {
  const Contador({super.key}); // Constructor constante

  @override
  Widget build(BuildContext context) {
    // Devuelve el widget con estado que maneja la lógica del contador
    return const MyHomePage(title: 'Contador');
  }
}

// Widget con estado que contiene la lógica del contador
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Título que se muestra en el AppBar

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Estado asociado al widget MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Valor actual del contador

  // Incrementa el contador
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Decrementa el contador
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  // Reinicia el contador a cero
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavegacionDrawer(), // Drawer lateral para navegación
      appBar: AppBar(title: Text(widget.title)), // Título en la barra superior
      // Cuerpo centrado con el texto y el valor del contador
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Has apretado el botón tantas veces:'),
            Text(
              '$_counter', // Muestra el valor actual del contador
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      // Botones flotantes posicionados en la pantalla
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          // Botón para incrementar
          Positioned(
            bottom: 80,
            right: 10,
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Incrementar',
              heroTag: 'increment',
              child: Icon(Icons.add),
            ),
          ),

          // Botón para decrementar
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrementar',
              heroTag: 'decrement',
              child: Icon(Icons.remove),
            ),
          ),

          // Botón para reiniciar
          Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: _resetCounter,
              tooltip: 'Reiniciar',
              heroTag: 'reset',
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
