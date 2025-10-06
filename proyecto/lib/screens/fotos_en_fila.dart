import 'package:proyecto/screens/screens.dart';

class FotosEnFila extends StatelessWidget {
  const FotosEnFila({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavegacionDrawer(),
    appBar: AppBar(title: const Text('Fotos en Fila')),
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://picsum.photos/100?image=10',
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 10),
          Image.network(
            'https://picsum.photos/100?image=20',
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 10),
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
