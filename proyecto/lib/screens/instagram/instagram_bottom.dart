import 'package:flutter/material.dart';

// Widget con estado que representa la parte inferior del perfil estilo Instagram
class InstagramBottom extends StatefulWidget {
  const InstagramBottom({super.key});

  @override
  State<InstagramBottom> createState() => InstagramBottomState();
}

class InstagramBottomState extends State<InstagramBottom> {
  bool muestraGrid =
      true; // Controla qué pestaña está activa (grid o perfil etiquetado)

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 🟣 Historias destacadas (scroll horizontal)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: 85,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  construirElementoHistoria(
                    'assets/images/instagram/nuevo.jpg',
                    'Nuevo',
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/pilotando.jpg',
                    'Pilotando',
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/francia.jpg',
                    'Francia',
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/arquitectura.jpg',
                    'Arquitectura',
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/retrato.jpg',
                    'Retratos',
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/comida.jpg',
                    'Comida',
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/coche.jpg',
                    'Coches',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 🟦 Sección de pestañas (grid y perfil etiquetado)
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // Selector de pestañas
                TabBar(
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.grid_on_rounded, size: 30),
                    ), // Vista de cuadrícula
                    Tab(
                      icon: Icon(Icons.person_pin_sharp, size: 30),
                    ), // Vista de perfil etiquetado
                  ],
                  onTap: (index) {
                    setState(() {
                      muestraGrid = index == 0;
                    });
                  },
                ),
                const SizedBox(height: 8),

                // Contenido de cada pestaña
                SizedBox(
                  height: 220,
                  child: TabBarView(
                    children: [
                      // 🖼️ Vista en cuadrícula con 9 imágenes
                      GridView.count(
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        crossAxisCount: 3,
                        children: List.generate(9, (index) {
                          return Image.asset(
                            'assets/images/instagram/grid${index + 1}.jpg',
                            fit: BoxFit.cover,
                          );
                        }),
                      ),

                      // 🧘 Vista alternativa con una imagen destacada
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/instagram/relax.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ⚫ Barra de navegación inferior estilo Instagram
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.home_rounded, size: 40),
              const Icon(Icons.search_rounded, size: 40),
              const Icon(Icons.add_circle, size: 40),
              const Icon(Icons.favorite_rounded, size: 40),

              // Foto de perfil como ícono final
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/instagram/retrato.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔁 Método auxiliar para construir cada historia destacada
  Widget construirElementoHistoria(String rutaImagen, String etiqueta) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              image: DecorationImage(
                image: AssetImage(rutaImagen),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
          Text(etiqueta, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
