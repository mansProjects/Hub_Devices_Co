import 'package:material_ui/material_ui.dart';
import '../services/cmd_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = TextEditingController();
  final _service = CommandeService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _controller.text.trim();
    final nettoye = code.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    if (nettoye.length < 6) {
      setState(() => _error = 'Entrez le code reçu sur WhatsApp.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final commande = await _service.chercherParCode(code);
      if (!mounted) return;

      if (commande == null) {
        setState(() => _error =
            'Code invalide. Vérifiez le code reçu sur WhatsApp.');
      } else {
        Navigator.pushNamed(
          context,
          '/suivi/commande',
          arguments: commande,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _error =
          'Connexion impossible. Vérifiez votre internet et réessayez.');
    } finally {
      if (mounted) setState(() => _loading = false);
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
        title: const Text('Suivi de précommande'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ma précommande',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Entrez le code que nous vous avons envoyé sur WhatsApp '
                    'pour suivre votre commande.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Code de suivi',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.characters,
                          autocorrect: false,
                          enableSuggestions: false,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: 'Ex : K7X2-M9QP',
                            prefixIcon: const Icon(Icons.vpn_key_outlined, color: Color.fromARGB(255, 181, 124, 0), size: 18),
                            errorText: _error,
                            errorMaxLines: 2,
                            filled:true,
                            fillColor: Color(0xFFF1F4FD),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: Color(0xFFD9E0F0), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: Color(0xFFD9E0F0), width: 1),
                            )
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Color(0xFF0077B5),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Voir ma précommande'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Pas encore de code ? Il arrive sur WhatsApp après '
                      'vérification de votre paiement.',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}