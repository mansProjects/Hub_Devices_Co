import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/cmd_services.dart';

class PrecommanderFormPage extends StatefulWidget {
  const PrecommanderFormPage({super.key});

  @override
  State<PrecommanderFormPage> createState() => _PrecommanderFormPageState();
}

class _PrecommanderFormPageState extends State<PrecommanderFormPage> {
  static const String _numeroWhatsApp = '243840513896';
  static const int _tailleMaxOctets = 4 * 1024 * 1024; // 4 Mo
  static const Color _fondChamp = Color(0xFFF2F5FB);
  static const Color _bordure = Color(0xFFD9E2EF);
  static const Color _texteDoux = Color(0xFF6B7A90);
  static const List<String> _etapes = [
    'Discutez avec nous sur WhatsApp, si ce n\'est pas encore fait.',
    'Effectuez le paiement convenu sur WhatsApp.',
    'Remplissez le formulaire ci-dessous.',
    'Cliquez sur Confirmer pour valider la précommande.',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _articleController = TextEditingController();
  final _picker = ImagePicker();
  final _service = CommandeService();

  Uint8List? _preuveBytes;
  String? _preuveNom;
  String? _preuveErreur;
  String? _erreurEnvoi;
  bool _loading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _telephoneController.dispose();
    _articleController.dispose();
    super.dispose();
  }

  // ---------- Logique ----------

  Future<void> _choisirPreuve() async {
    final fichier = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (fichier == null) return;

    final bytes = await fichier.readAsBytes();
    if (!mounted) return;

    if (bytes.length > _tailleMaxOctets) {
      setState(() {
        _preuveBytes = null;
        _preuveNom = null;
        _preuveErreur = 'Image trop lourde (4 Mo maximum).';
      });
      return;
    }

    setState(() {
      _preuveBytes = bytes;
      _preuveNom = fichier.name;
      _preuveErreur = null;
    });
  }

  Future<void> _ouvrirWhatsApp() async {
    final article = _articleController.text.trim();
    final message = article.isEmpty
        ? 'Bonjour, je souhaite faire une précommande.'
        : 'Bonjour, je souhaite précommander : $article.';
    final uri = Uri.parse(
      'https://wa.me/$_numeroWhatsApp?text=${Uri.encodeComponent(message)}',
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp.')),
      );
    }
  }

  String? _detecterType(Uint8List o) {
    if (o.length > 12) {
      if (o[0] == 0xFF && o[1] == 0xD8 && o[2] == 0xFF) return 'image/jpeg';
      if (o[0] == 0x89 && o[1] == 0x50 && o[2] == 0x4E && o[3] == 0x47) {
        return 'image/png';
      }
      if (o[0] == 0x52 &&
          o[1] == 0x49 &&
          o[2] == 0x46 &&
          o[3] == 0x46 &&
          o[8] == 0x57 &&
          o[9] == 0x45 &&
          o[10] == 0x42 &&
          o[11] == 0x50) {
        return 'image/webp';
      }
    }
    return null;
  }

  Future<void> _confirmer() async {
    final formulaireValide = _formKey.currentState!.validate();
    if (_preuveBytes == null) {
      setState(() =>
          _preuveErreur = 'Ajoutez la capture de votre preuve de paiement.');
    }
    if (!formulaireValide || _preuveBytes == null) return;

    final type = _detecterType(_preuveBytes!);
    if (type == null) {
      setState(() => _preuveErreur =
          'Format non accepté. Utilisez une image JPG, PNG ou WebP.');
      return;
    }

    setState(() {
      _loading = true;
      _erreurEnvoi = null;
    });

    try {
      final reference = await _service.envoyerPrecommande(
        nom: _nomController.text.trim(),
        telephone: _telephoneController.text.trim(),
        article: _articleController.text.trim(),
        preuve: _preuveBytes!,
        preuveType: type,
      );
      if (!mounted) return;

      if (reference == null) {
        setState(() => _erreurEnvoi =
            'Votre précommande n\'a pas pu être enregistrée. '
            'Vérifiez vos informations et réessayez.');
      } else {
        await _afficherConfirmation(reference);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurEnvoi =
          'Connexion impossible. Vérifiez votre internet et réessayez.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _afficherConfirmation(String reference) {
    final nom = _nomController.text.trim();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 56),
        title: const Text(
          'Précommande bien reçue !',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Merci $nom, nous avons bien reçu votre précommande.\n\n'
          'Votre référence : $reference\n\n'
          'Notre équipe vérifie vos informations et votre preuve de '
          'paiement. D\'ici 1h, vous recevrez votre code '
          'personnel sur WhatsApp pour suivre votre commande jusqu\'à '
          'la livraison.\n\n'
          'Gardez votre téléphone à portée de main !',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).primaryColor,
              ),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                dialogContext,
                '/',
                (route) => false,
              ),
              child: const Text('Terminer'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Page ----------

  @override
  Widget build(BuildContext context) {
    final couleur = Theme.of(context).primaryColor;

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
        title: const Text('Précommander'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHaut(couleur),
                        const SizedBox(height: 28),
                        const Text(
                          'Remplissez le formulaire',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildFormulaire(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBarreBas(couleur),
          ],
        ),
      ),
    );
  }

  // ---------- HAUT DE PAGE (inchangé) ----------

  Widget _buildHaut(Color couleur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Formulaire de précommande',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Étapes à suivre',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (int i = 0; i < _etapes.length; i++) ...[
          _buildEtape(i + 1, _etapes[i], couleur),
          if (i < _etapes.length - 1) const SizedBox(height: 10),
        ],
        const SizedBox(height: 20),
        const Text(
          'Nous vous enverrons un code sur WhatsApp pour suivre '
          'l\'évolution de votre commande jusqu\'à la livraison.',
          style: TextStyle(height: 1.4),
        ),
      ],
    );
  }

  Widget _buildEtape(int numero, String texte, Color couleur) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: couleur.withValues(alpha: 0.35)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$numero. ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: texte),
          ],
        ),
        style: const TextStyle(fontSize: 14, height: 1.3),
      ),
    );
  }

  // ---------- BAS DE PAGE (nouveau design) ----------

  InputDecoration _decoration(String hint, IconData icone) {
    final couleur = Theme.of(context).primaryColor;
    final erreur = Theme.of(context).colorScheme.error;

    OutlineInputBorder bord(Color c, [double largeur = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: c, width: largeur),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _texteDoux),
      prefixIcon: Icon(icone, color: _texteDoux),
      filled: true,
      fillColor: _fondChamp,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: bord(_bordure),
      enabledBorder: bord(_bordure),
      focusedBorder: bord(couleur, 1.5),
      errorBorder: bord(erreur),
      focusedErrorBorder: bord(erreur, 1.5),
    );
  }

  Widget _buildFormulaire() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _bordure),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Votre nom complet', Icons.person_outline),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return 'Entrez votre nom.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: _decoration(
                'Votre numéro de téléphone',
                Icons.phone_outlined,
              ),
              validator: (value) {
                final chiffres = (value ?? '').replaceAll(RegExp(r'\D'), '');
                if (chiffres.length < 9) {
                  return 'Entrez un numéro de téléphone valide.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _articleController,
              textInputAction: TextInputAction.done,
              decoration: _decoration(
                'Nom de l\'article',
                Icons.shopping_bag_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Entrez le nom de l\'article.';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            _buildPreuve(),
            
                        const SizedBox(height: 22),
            _buildPreuve(),
            const SizedBox(height: 18),
            const Text(
              'Avez-vous déjà discuté avec nous sur WhatsApp ? '
              'Sinon, écrivez-nous avant de confirmers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _texteDoux, fontSize: 14, height: 1.4),
            ),

            if (_erreurEnvoi != null) ...[
              const SizedBox(height: 14),
              Text(
                _erreurEnvoi!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            _buildBoutonWhatsApp(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreuve() {
    final erreur = Theme.of(context).colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preuve de paiement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Capture d\'écran du message d\'envoi d\'argent ou du dépôt.',
          style: TextStyle(color: _texteDoux, fontSize: 14, height: 1.3),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _choisirPreuve,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _fondChamp,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _preuveErreur == null ? _bordure : erreur,
              ),
            ),
            child: _preuveBytes == null
                ? const Row(
                    children: [
                      Icon(Icons.upload_file_outlined, color: _texteDoux),
                      SizedBox(width: 12),
                      Text(
                        'Importer une capture',
                        style: TextStyle(color: _texteDoux, fontSize: 16),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _preuveBytes!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _preuveNom ?? 'Image choisie',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Changer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
           
           
        if (_preuveErreur != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: Text(
              _preuveErreur!,
              style: TextStyle(color: erreur, fontSize: 12),
            ),
          ),
      ],
             
    );
    
  }

  Widget _buildBoutonWhatsApp() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF128C7E),
          side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
          shape: const StadiumBorder(),
        ),
        onPressed: _ouvrirWhatsApp,
        icon: const Icon(Icons.chat_outlined),
        label: const Text('Écrivez-nous sur WhatsApp'),
      ),
    );
  }


  Widget _buildBarreBas(Color couleur) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _bordure)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: couleur,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: _loading ? null : _confirmer,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 15),
                            Text(
                              'Confirmer',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 16, color: _texteDoux),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Suivi de commande jusqu\'à la livraison',
                      style: TextStyle(color: _texteDoux, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}