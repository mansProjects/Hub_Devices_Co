import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub_devices_co/constants/app_constants.dart';
import 'package:hub_devices_co/screens/about_screen.dart';
import 'package:hub_devices_co/screens/contacts.dart';
import 'package:hub_devices_co/screens/red_mi.dart';
import 'package:hub_devices_co/widgets/precommande_section.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import '../screens/login_page.dart';

class HomeScreen extends StatelessWidget {
  final String _urlFacebook = "https://www.facebook.com/share/1DgYxwmGfY/";
  final String _urlInstagram =
      "https://www.instagram.com/hub_dco?igsh=MTFjczN0YTh6OGlpNw==";

  final ScrollController _scrollController = ScrollController();

  // Fonction pour ouvrir les liens
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d\'ouvrir $url';
    }
  }

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Hub & Devices Co.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text("${context.watch<CartProvider>().items.length}"),
              child: const Icon(Icons.shopping_cart, color: Colors.blue),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppConstants.primaryBlue),
              accountName: Text(
                "Hub & Devices Co.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("Bienvenue sur notre boutique"),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: AppConstants.primaryBlue,
              ),
              title: const Text("Accueil"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.shopping_cart_outlined,
                color: AppConstants.primaryBlue,
              ),
              title: const Text("Mon panier"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: AppConstants.primaryBlue),
              title: const Text("Redmi Products"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RedMiPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: AppConstants.primaryBlue,
              ),
              title: const Text("À propos de nous"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HubDevicesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_page,
                color: AppConstants.primaryBlue,
              ),
              title: const Text("Contacts"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // SECTION DES BANNIÈRES
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio:
                          16 /
                          9, // Garde la proportion visuelle idéale sur tous les écrans
                      child: SizedBox(
                        width: double
                            .infinity, // Force la largeur maximale de l'écran
                        height: double
                            .infinity, // Force la hauteur maximale du conteneur AspectRatio
                        child: AnotherCarousel(
                          images: const [
                            AssetImage("assets/images/banier.jpg"),
                            AssetImage("assets/images/Banner website 2.png"),
                            AssetImage("assets/images/Banner website 7.jpg"),

                            AssetImage("assets/images/Banner website 3.png"),

                            AssetImage("assets/images/Banner website 4.png"),
                          ],
                          dotSize: 4,
                          indicatorBgPadding: 5.0,
                          boxFit: BoxFit
                              .contain, // 👈 Remplit entièrement le conteneur en ajustant l'image dynamiquement
                        ),
                      ),
                    ),
                    // Section precommande
                  Padding(
                        padding: const EdgeInsets.all(16),
                        child: PrecommandeSection(
                          onPrecommander: () => Navigator.pushNamed(context, '/precommander'),
                          onSuivre: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "N O S   P R O D U I T S",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // --- ZONE GRILLE DE PRODUITS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 1. Configuration du nombre de colonnes adaptatives
                  double screenWidth = constraints.maxWidth;
                  int columns = 2; // Mobile
                  if (screenWidth > 900) {
                    columns = 4; // PC / Écrans larges
                  } else if (screenWidth > 600) {
                    columns = 3; // Tablettes
                  }

                  // 2. Calcul des dimensions
                  double spacing = 14.0;
                  double totalSpacing = spacing * (columns - 1);
                  double cardWidth = (screenWidth - totalSpacing) / columns;

                  double itemAspectRatio = 0.70;
                  double cardHeight = cardWidth / itemAspectRatio;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: allProducts.map((product) {
                      // Structure visuelle brute  carte produit
                      Widget customCard = Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // [A] ZONE IMAGE - CLIQUABLE VERS LES DÉTAILS
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
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.white,
                                    child: Image.asset(
                                      product.imageUrl,
                                      key: ValueKey(
                                        'web_img_${product.id}_${product.imageUrl}',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey[100]),
                            // [B] ZONE DES TEXTES ET BOUTON
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // NOM DU PRODUIT - CLIQUABLE VERS LES DÉTAILS
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // PRIX DU PRODUIT
                                  Text(
                                    "${product.price.toStringAsFixed(2)} \$",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.blue,
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
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      onPressed: product.inStock
                                          ? () {
                                              // Ajout au panier via le Provider
                                              context
                                                  .read<CartProvider>()
                                                  .addItem(product);

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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_shopping_cart,
                                            size: 16,
                                          ),
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

                      // FILTRE ET TEXTE DE RUPTURE DE STOCK (SOLD OUT)
                      if (!product.inStock) {
                        customCard = Stack(
                          alignment: Alignment.center,
                          children: [
                            ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.modulate,
                              ),
                              child: customCard,
                            ),
                            Transform.rotate(
                              angle: -0.15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "SOLD OUT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return AbsorbPointer(
                        absorbing: !product.inStock,
                        child: customCard,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),

          // SECTION FUTURS PRODUITS
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "N O S   F U T U R E S   P R O D U I T S",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,

                        child: AnotherCarousel(
                          images: const [
                            AssetImage("assets/images/futur 1.jpg"),
                            AssetImage("assets/images/futur 2.jpg"),
                            AssetImage("assets/images/futur 3.jpg"),
                            AssetImage("assets/images/futur 4.jpg"),
                            AssetImage("assets/images/futur 5.jpg"),
                            AssetImage("assets/images/futur 6.jpg"),
                          ],
                          dotSize: 4,
                          indicatorBgPadding: 5.0,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // SECTION À PROPOS DE NOUS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  const Text(
                    "A   P R O P O S   D E   N O U S",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 40,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          "assets/images/apropos.jpg",
                          width: 350,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                "Chez nous, retrouvez des articles authentiques.Testés et validés avant même qu’on vous les propose.Notre engagement : Simplicité d'usage.Fiabilité au quotidien.Qualité premium.Parce que vous méritez du vrai, en toute  sans mauvaise surprise.",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HubDevicesPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B92C4),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Tout savoir sur nous",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // SECTION AVIS CLIENTS
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "A V I S    D E S   C L I E N T S",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 9 / 9,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: AnotherCarousel(
                          images: const [
                            AssetImage("assets/images/avis 1.jpg"),
                            AssetImage("assets/images/50.PNG"),
                            AssetImage("assets/images/51.PNG"),
                            AssetImage("assets/images/52.PNG"),
                            AssetImage("assets/images/53.PNG"),
                          ],
                          dotSize: 4,
                          indicatorBgPadding: 5.0,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // SECTION CONTACT ET FOOTER
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  'C O N T A C T E Z - N O U S',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 30,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        width: 280,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B92C4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Nos réseaux sociaux',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => _launchURL(_urlFacebook),
                                  child: const Icon(
                                    Icons.facebook,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => _launchURL(_urlInstagram),
                                  child: const FaIcon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Hub & Devices Co.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var whatsappUrl =
                                      "whatsapp://send?phone=+243840513896";
                                  if (await canLaunchUrl(
                                    Uri.parse(whatsappUrl),
                                  )) {
                                    await launchUrl(Uri.parse(whatsappUrl));
                                  } else {
                                    await launchUrl(
                                      Uri.parse("https://wa.me/243840513896"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 100),
                              GestureDetector(
                                onTap: () async {
                                  final Uri telLaunchUri = Uri(
                                    scheme: 'tel',
                                    path: '+243840513896',
                                  );
                                  if (await canLaunchUrl(telLaunchUri)) {
                                    await launchUrl(telLaunchUri);
                                  }
                                },
                                child: const Icon(
                                  Icons.phone_in_talk,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B92C4),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              '(243) 840513896',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // NOUVELLE SECTION DE MENU
                Container(
                  width: double.infinity,
                  color: const Color(
                    0xFF1B92C4,
                  ), // Fond bleu identique à l'image
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Remonte au début de la page grâce au ScrollController
                          _scrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          "Acceuil",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => HubDevicesPage()),
                          );
                        },
                        child: const Text(
                          "A propos de nous",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContactPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Contact",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RedMiPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Redmi",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                // COPYRIGHT
                const SizedBox(height: 30),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("© 2026 Hub & Devices Co. Tous droits réservés."),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
