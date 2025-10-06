import 'package:proyecto/screens/screens.dart';

class FotosEnColumna extends StatelessWidget {
  const FotosEnColumna({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavegacionDrawer(),
    appBar: AppBar(title: const Text('Fotos en Columna')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://picsum.photos/100?image=5',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),
          Image.network(
            'https://picsum.photos/100?image=15',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),
          Image.network(
            'https://picsum.photos/100?image=25',
            width: 100,
            height: 100,
          ),
        ],
      ),
    ),
  );
}
