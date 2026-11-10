class Product {
  final String id, name, description, imageUrl;
  final double price;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sans nom',
      description: json['description'] ?? 'Aucune description disponible.',
      imageUrl: json['imageUrl'] ?? '',
      // Conversion ultra-sécurisée en double (gère les int, double et null sans crash)
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      inStock: json['inStock'] ?? true,
    );
  }
}

// Liste de produits mise à jour avec la structure corrigée
List<Product> allProducts = [
  Product(
    id: "1",
    name: "XIAOMI Redmi Buds 6 Play",
    price: 35.0,
    imageUrl: "assets/images/13.jpg",
    description:
        "XIAOMI Redmi Buds 6 Play – Ecouteurs Bluetooth, Conducteurs 10 mm, 5 Modes EQ, Jusqu'à 7.5h+36h Autonomie de la Batterie, 10min de Charge fournit 3h de Lecture Musicale, IPX4, Blue",
    inStock: true,
  ),
  Product(
    id: "2",
    name: "XIAOMI Redmi Buds 6 Play",
    price: 35.0,
    imageUrl: "assets/images/14.jpg",
    description:
        "XIAOMI Redmi Buds 6 Play – Ecouteurs Bluetooth, Conducteurs 10 mm, 5 Modes EQ, Jusqu'à 7.5h+36h Autonomie de la Batterie, 10min de Charge fournit 3h de Lecture Musicale, IPX4, Blanc",
    inStock: true,
  ),
  Product(
    id: "3",
    name: "XIAOMI Redmi Buds 6 Play",
    price: 35.0,
    imageUrl: "assets/images/15.jpg",
    description:
        "XIAOMI Redmi Buds 6 Play – Ecouteurs Bluetooth, Conducteurs 10 mm, 5 Modes EQ, Jusqu'à 7.5h+36h Autonomie de la Batterie, 10min de Charge fournit 3h de Lecture Musicale, IPX4, Noir",
    inStock: true,
  ),
  Product(
    id: "4",
    name: "XIAOMI Redmi Buds 6 Play",
    price: 35.0,
    imageUrl: "assets/images/16.jpg",
    description:
        "XIAOMI Redmi Buds 6 Play – Ecouteurs Bluetooth, Conducteurs 10 mm, 5 Modes EQ, Jusqu'à 7.5h+36h Autonomie de la Batterie, 10min de Charge fournit 3h de Lecture Musicale, IPX4, Rose poudré",
    inStock: true,
  ),
  Product(
    id: "5",
    name: "Apple Watch SE 3",
    price: 450.0,
    imageUrl: "assets/images/5.JPEG",
    description:
        "Apple Watch SE 3 [GPS 40 mm] Montre connectée avec boîtier Lumière stellaire et Bracelet Sport Lumière stellaire. Moniteur activité/Sommeil/fréquence Cardiaque, écran Toujours activé",
    inStock: false,
  ),
  Product(
    id: "6",
    name: "POWER BANK HEPU",
    price: 40.0,
    imageUrl: "assets/images/6.PNG",
    description:
        "Une puissance qui remplace 10 à 11 téléphones, avec une durabilité faite pour durer.",
    inStock: false,
  ),

  Product(
    id: "9",
    name: "Soundcore",
    price: 65.0,
    imageUrl: "assets/images/9.JPEG",
    description: "Version améliorée avec de nouvelles fonctionnalités.",
    inStock: true,
  ),
  Product(
    id: "10",
    name: "VOWTOP SMART WATCH",
    price: 40.0,
    imageUrl: "assets/images/10.JPEG",
    description:
        "Communication en haute définition (appels et messages), soutenue par une excellente autonomie.",
    inStock: true,
  ),
  Product(
    id: "11",
    name: "Sony WH-CH520",
    price: 100.0,
    imageUrl: "assets/images/11.JPG",
    description:
        "Sony WH-CH520 - Casque Bluetooth sans Fil, Multipoint, Micro intégré - jusqu'à 50 Heures d'autonomie et Charge Rapide - Noir",
    inStock: true,
  ),
  Product(
    id: "12",
    name: "JBL Wave Flex 2",
    price: 75.0,
    imageUrl: "assets/images/12.jpg",
    description:
        "JBL Wave Flex 2, Écouteurs sans Fil Bluetooth, 40 h d'autonomie, Son JBL Pure Bass, Technologie Smart Ambient, résistance à l'eau et à la poussière IP54, Connexion multipoint, Noir",
    inStock: true,
  ),
  Product(
    id: "13",
    name: "Soundcore H30i",
    price: 70.0,
    imageUrl: "assets/images/1.JPG",
    description:
        "Soundcore Casque Bluetooth sans Fil Supra-auriculaire H30i, Conception Pliable, Basses Pures, autonomie de 70 Heures, Bluetooth 5.3, Léger et Confortable, Connectivité par App, Connexion Multipoint",
    inStock: true,
  ),

  Product(
    id: "14",
    name: "JBL Tune 520BT",
    price: 90.0,
    imageUrl: "assets/images/2.JPEG",
    description:
        "JBL Tune 520BT, casque audio sans fil, léger et confortable, Bluetooth 5.3, autonomie jusqu'à 57 h, charge rapide, son JBL Pure Bass, noir",
    inStock: true,
  ),

  Product(
    id: "15",
    name: "Soundcore P20i",
    price: 49.0,
    imageUrl: "assets/images/3.JPEG",
    description:
        "Soundcore P20i Ecouteurs Bluetooth sans Fil by Anker, Écouteurs sans Fil Bluetooth 5.3, conducteurs 10mm, Grosses Basses, 30H de Lecture, étanchéité IPX5, EQ Via App, 2 micros, Mode écouteur Unique",
    inStock: true,
  ),

  Product(
    id: "16",
    name: "POWER BANK HEPU",
    price: 30.0,
    imageUrl: "assets/images/4.JPEG",
    description: "Le produit le plus performant de sa catégorie.",
    inStock: false,
  ),

  Product(
    id: "17",
    name: "Anker Nano Batterie Externe",
    price: 70.0,
    imageUrl: "assets/images/17.jpg",
    description:
        "Anker Nano Batterie Externe 10000 mAh avec câble USB-C intégré, Puissance maximale PD 30 W avec 1 Port USB-C & A, Compatible avec iPhone 17 Pro Max16//15/14/13, MacBook, Galaxy, iPad, AirPods",
    inStock: true,
  ),

  Product(
    id: "18",
    name: "CMF by Nothing Buds 2",
    price: 77.0,
    imageUrl: "assets/images/18.jpg",
    description:
        "CMF by Nothing Buds 2 Écouteurs sans Fil avec ANC Hybride de 48 DB, autonomie de 55 Heures, Driver PMI de 11 mm, 6 micros HD et Audio Spatial, résistance à l’Eau IP55 – Noir",
    inStock: true,
  ),

  Product(
    id: "19",
    name: "JBL Tune 660NC",
    price: 150.0,
    imageUrl: "assets/images/19.jpg",
    description:
        "JBL Tune 660NC – Casque Bluetooth sans fil pliable – Avec son JBL Pure Bass et suppression active du bruit – Jusqu'à 44 heures d'autonomie",
    inStock: true,
  ),

  Product(
    id: "20",
    name: "CMF by Nothing Buds 2",
    price: 77.0,
    imageUrl: "assets/images/20.jpg",
    description:
        "CMF by Nothing Buds 2 Écouteurs sans Fil avec ANC Hybride de 48 DB, autonomie de 55 Heures, Driver PMI de 11 mm, 6 micros HD et Audio Spatial, résistance à l’Eau IP55 – Gris foncé",
    inStock: true,
  ),

  Product(
    id: "21",
    name: "JBL Wave Buds 2",
    price: 80.0,
    imageUrl: "assets/images/21.jpg",
    description:
        "JBL Wave Buds 2, Écouteurs sans Fil Bluetooth, 40 h d'autonomie, Son JBL Pure Bass, Technologie Smart Ambient, résistance à l'eau et à la poussière IP54, Connexion multipoint, Noir",
    inStock: true,
  ),

  Product(
    id: "22",
    name: "Soundcore P30i",
    price: 77.0,
    imageUrl: "assets/images/22.jpg",
    description:
        "Soundcore Ecouteurs Bluetooth sans Fil P30i by Anker, Écouteurs sans Fil Reduction de Bruit Forte et Intelligente, Basses Puissantes, 45H d'autonomie, Étui 2-en-1 et Support pour téléphone, IP54",
    inStock: true,
  ),

  Product(
    id: "23",
    name: "JBL Charge 6",
    price: 295.0,
    imageUrl: "assets/images/23.jpg",
    description:
        "JBL Charge 6, Enceinte Bluetooth Portable sans Fil, 28h d'autonomie, étanche IP68, résistance à la poussière et aux Chocsn Son JBL Pro avec Sound Boost, Connexion Multi-Enceintes Auracast, Noir",
    inStock: true,
  ),
];
