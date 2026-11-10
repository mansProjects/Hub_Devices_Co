import 'package:flutter/material.dart';
import '../services/cmd_services.dart';
import '../screens/precommande_page.dart';

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
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) {
      setState(() => _error = 'Entrez un numéro de téléphone valide.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final commande =
          await _service.chercherParTelephone(_controller.text.trim());
      if (!mounted) return;

      if (commande == null) {
        setState(() => _error = 'Aucune précommande trouvée pour ce numéro.');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PrecommandePage(commande: commande),
          ),
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
                    'M A  P R É C O M M A N D E',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Entrez votre numéro de téléphone pour suivre votre commande.',
                    style: TextStyle(color: Colors.black54,fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Numéro de téléphone',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.phone,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: 'Ex : 081 234 5678',
                            errorText: _error,
                            errorMaxLines: 2,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Voir ma précommande'),
                          ),
                        ),
                      ],
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