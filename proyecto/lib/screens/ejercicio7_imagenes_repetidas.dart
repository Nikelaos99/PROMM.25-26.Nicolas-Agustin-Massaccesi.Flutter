import 'package:proyecto/screens/screens.dart';

class ImagenesRepetidas extends StatelessWidget {
  const ImagenesRepetidas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavegacionDrawer(),
      appBar: AppBar(title: const Text('Imágenes Repetidas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen desde assets
            Image.asset(
              'assets/images/repetida.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Imagen con Image.network
            Image.network(
              'https://picsum.photos/id/237/200/200',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Imagen con NetworkImage
            Image(
              image: const NetworkImage('https://picsum.photos/id/237/200/200'),
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
