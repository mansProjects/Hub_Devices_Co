import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configData/commande.dart';


class CommandeService {
  static const String _baseUrl = 'https://script.google.com/macros/s/AKfycbx9QZwXSOihjkorHhYhHDFWOXQeTx6E6C6ttTG8D-6i2bZzMhNsRJej2LAUhWLo-P9H/exec';

  Future<Commande?> chercherParTelephone(String telephone) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {'telephone': telephone},
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    if (data['ok'] != true) {
      return null;
    }
    return Commande.fromJson(data['commande']);
  }

    Future<Offre?> chercherOffre(String code) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {'action': 'offre', 'code': code.trim()},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data['ok'] != true) return null;

    return Offre(
      code: code.trim(),
      article: data['offre']['article'].toString(),
      prix: data['offre']['prix'].toString(),
    );
  }

  Future<String?> enregistrerPrecommande({
    required String code,
    required String nom,
    required String telephone,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'action': 'enregistrer',
        'code': code,
        'nom': nom,
        'telephone': telephone,
      },
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data['ok'] != true) return null;

    return data['numero_client'].toString();
  }
}
class Offre {
  final String code;
  final String article;
  final String prix;

  const Offre({
    required this.code,
    required this.article,
    required this.prix,
  });
}