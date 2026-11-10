import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/app_constants.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  // Calcul du montant total
  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (ex) => CartItem(product: ex.product, quantity: ex.quantity + 1),
      );
    } else {
      _items.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners();
  }

  void removeOneItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (ex) => CartItem(product: ex.product, quantity: ex.quantity - 1),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // MÉTHODE DE GÉNÉRATION DU MESSAGE WHATSAPP
  String generateWhatsAppMessage(String name, String phone, String address) {
    String msg = "*Nouvelle Commande - ${AppConstants.appName}*\n\n";
    msg += "*Client:* $name\n*Tel:* $phone\n*Adresse:* $address\n\n";
    msg += "*Articles :*\n";

    _items.forEach((key, item) {
      msg +=
          "- ${item.product.name} (x${item.quantity}) : ${item.product.price * item.quantity} \$\n";
    });

    msg += "\n*TOTAL : $totalAmount \$*";
    msg +=
        "\n*Mode de paiement : Cash à la livraison ( 6000 FC pour frais de livraison )*"; // Conformément au cahier des charges [cite: 5, 45]

    return msg;
  }

  void addToCart(Product product) {}

  void removeItem(String id) {}
}
