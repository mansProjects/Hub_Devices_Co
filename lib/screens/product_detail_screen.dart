import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: List.generate(
        5,
        (index) => const Icon(Icons.star, color: Colors.orange, size: 20),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // 1. Fond Bleu
          Container(
            color: const Color(0xFF2D7DA3), // Bleu de fond
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Contenu Principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ), // Espace pour ne pas coller au bouton retour
                  // La Carte Blanche
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        40,
                      ), // Bords très arrondis
                    ),
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image du Produit (Adaptée pour les assets locaux avec correctif Web)
                        Center(
                          child: Image.asset(
                            product.imageUrl,
                            key: ValueKey(
                              'detail_img_${product.id}_${product.imageUrl}',
                            ),
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Titre et Étoiles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF1E88BD),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            row,
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ZONE DU PRIX (Ajoutée pour afficher la valeur de l'article)
                        Text(
                          "${product.price.toStringAsFixed(2)} \$",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Description / Détails techniques
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Bouton d'action intelligent (S'adapte au stock)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88BD),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: product.inStock
                              ? () {
                                  context.read<CartProvider>().addItem(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${product.name} ajouté au panier !",
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              : null, // Se désactive si hors stock
                          child: Text(
                            product.inStock
                                ? "Ajouter au panier"
                                : "Rupture de stock",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Texte du bas (Hub & Devices Co.)
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.panorama_fish_eye,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Hub & Devices Co.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // BOUTON RETOUR SÉCURISÉ
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
