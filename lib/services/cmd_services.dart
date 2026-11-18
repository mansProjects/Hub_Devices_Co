import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../configData/commande.dart';


class CommandeService {
  static const String _baseUrl = 'https://script.google.com/macros/s/AKfycbxxokmhfTvouprbTf-P2B5IwfO-62LsZV8QJR-My_nGiK6jQ0X4pWycLS-0CUSDMBdq/exec';
  
    Future<String?> envoyerPrecommande({
    required String nom,
    required String telephone,
    required String article,
    required Uint8List preuve,
    required String preuveType,
  }) async {
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'text/plain; charset=utf-8'},
          body: jsonEncode({
            'nom': nom,
            'telephone': telephone,
            'article': article,
            'preuveType': preuveType,
            'preuveBase64': base64Encode(preuve),
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data['ok'] != true) return null;

    return data['reference'].toString();
  }

    Future<Commande?> chercherParCode(String code) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {'action': 'suivi_code', 'code': code.trim()},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data['ok'] != true) return null;

    return Commande.fromJson(data['commande']);
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