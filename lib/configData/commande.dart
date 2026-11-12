class Commande {
  final String nameClient;
  final String nameProduct;
  final String dateCommande;
  final String article;
  final String numeroClient;
  final String total;
  final String description;
  final int quantite;
  final bool paiementConfirme;
  final int etapesAtteintes;

  const Commande({
    required this.nameClient,
    required this.nameProduct,
    required this.dateCommande,
    required this.article,
    required this.numeroClient,
    required this.total,
    required this.description,
    required this.quantite,
    required this.paiementConfirme,
    required this.etapesAtteintes,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      nameClient: json['nom']?.trim() ?? '',
      nameProduct: (json['product_name'] ?? json['article'])?.toString().trim() ?? '',
      dateCommande: json['date_commande']?.toString() ?? '',
      article: (json['product_name'] ?? json['article'])?.toString().trim() ?? '',
      numeroClient: json['numero_client']?.toString() ?? '',
      total: json['total']?.toString() ?? '',
      description: json['description']?.toString().trim() ?? '',
      quantite: int.tryParse(json['quantite']?.toString() ?? '') ?? 1,
      paiementConfirme:
          (json['paiement_confirme']?.toString().trim().toUpperCase() ?? '') ==
              'OUI',
      etapesAtteintes:
          int.tryParse(json['etapes_atteintes']?.toString() ?? '') ?? 0,
    );
  }

    static const int dureeLivraisonJours = 14;

  int get joursRestants {
    final debut = _parseDate(dateCommande);
    if (debut == null) return dureeLivraisonJours;

    final now = DateTime.now();
    final aujourdhui = DateTime.utc(now.year, now.month, now.day);
    final depart = DateTime.utc(debut.year, debut.month, debut.day);

    final ecoules = aujourdhui.difference(depart).inDays;
    final restant = dureeLivraisonJours - ecoules;

    if (restant < 0) return 0;
    if (restant > dureeLivraisonJours) return dureeLivraisonJours;
    return restant;
  }
    double get progression =>
      (dureeLivraisonJours - joursRestants) / dureeLivraisonJours;
      
    String get prixAffiche {
    final t = total.trim();
    if (t.isEmpty) return '';
    return t.contains('\$') ? t : '$t \$';
  }

  static DateTime? _parseDate(String texte) {
    final t = texte.trim();
    if (t.isEmpty) return null;

    final jma = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(t);
    if (jma != null) {
      return DateTime(
        int.parse(jma.group(3)!),
        int.parse(jma.group(2)!),
        int.parse(jma.group(1)!),
      );
    }
    return DateTime.tryParse(t)?.toLocal();
  }
}