import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BeforePreco extends StatelessWidget {
  const BeforePreco({super.key});

  // À remplacer : numéro WhatsApp au format international,
  // sans "+" ni espaces (ex : 243 + les 9 chiffres du numéro)
  static const String _numeroWhatsApp = '243840513896';

  static const String _message =
      'Bonjour, je souhaite en savoir plus sur la précommande.';

  static const List<String> _etapes = [
    'Cliquez sur « Discuter sur WhatsApp » ci-dessous.',
    'Dites-nous quel article vous intéresse.',
    'Nous convenons ensemble des détails et du prix.',
    'Vous payez et vous envoyez la preuve de paiement.',
    'Nous vous donnons un code pour accéder au formulaire de précommande.',
    'Et vous pouvez suivre l\'evolution de votre précommande jusqu\'à livraison.',
  ];

  Future<void> _ouvrirWhatsApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/$_numeroWhatsApp?text=${Uri.encodeComponent(_message)}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour à l\'accueil',
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          ),
        ),
        title: const Text('Pour précommander'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comment précommander ?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  for (int i = 0; i < _etapes.length; i++) ...[
                    _buildEtape(i + 1, _etapes[i]),
                    if (i < _etapes.length - 1) const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final boutonWhatsApp = FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () => _ouvrirWhatsApp(context),
                        icon: const Icon(Icons.chat),
                        label: const Text('Discuter sur WhatsApp'),
                      );

                      final boutonDejaContacte = OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                       onPressed: () => Navigator.pushNamed(context, '/precommander/code'),
                        child: const Text('Déjà contacté sur WhatsApp ?'),
                      );

                      if (constraints.maxWidth >= 480) {
                        return Row(
                          children: [
                            Expanded(child: boutonWhatsApp),
                            const SizedBox(width: 12),
                            Expanded(child: boutonDejaContacte),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(width: double.infinity, child: boutonWhatsApp),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: boutonDejaContacte,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEtape(int numero, String texte) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF0077B5), width: 2),
          ),
          child: Text(
            '$numero',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0077B5),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              texte,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}