import 'package:flutter/material.dart';
import 'package:hub_devices_co/models/product.dart';
import 'package:hub_devices_co/providers/cart_provider.dart';
import 'package:provider/provider.dart';

// adapte les imports selon ton projet
import 'product_detail_screen.dart';

class RedMiPage extends StatelessWidget {
  const RedMiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Les 4 premiers produits seulement
    final redmiProducts = allProducts.take(4).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("RedMi")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),

          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;

              int columns = 2;

              if (screenWidth > 900) {
                columns = 4;
              } else if (screenWidth > 600) {
                columns = 3;
              }

              double spacing = 14;

              double cardWidth =
                  (screenWidth - spacing * (columns - 1)) / columns;

              double cardHeight = cardWidth / 0.70;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,

                children: redmiProducts.map((product) {
                  Widget card = Container(
                    width: cardWidth,
                    height: cardHeight,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(12),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),

                          blurRadius: 6,

                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },

                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),

                              child: Image.asset(
                                product.imageUrl,

                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const Divider(height: 1),

                        Padding(
                          padding: const EdgeInsets.all(10),

                          child: Column(
                            children: [
                              Text(
                                product.name,

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "${product.price} \$",

                                style: const TextStyle(
                                  color: Colors.blue,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // BOUTON ACHETER
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: product.inStock
                                      ? () {
                                          // Ajout au panier via le Provider
                                          context.read<CartProvider>().addItem(
                                            product,
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${product.name} ajouté au panier !",
                                              ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_shopping_cart, size: 16),
                                      SizedBox(width: 5),
                                      Text(
                                        "Acheter",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  if (!product.inStock) {
                    card = Stack(
                      alignment: Alignment.center,

                      children: [
                        ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.modulate,
                          ),

                          child: card,
                        ),

                        Container(
                          padding: const EdgeInsets.all(8),

                          color: Colors.blue,

                          child: const Text(
                            "SOLD OUT",

                            style: TextStyle(
                              color: Colors.white,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return card;
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
