import 'package:flutter/material.dart';
import '../services/cmd_services.dart';

class CodePreco extends StatefulWidget {
  const CodePreco({super.key});

  @override
  State<CodePreco> createState() => _CodePrecoState();
}

class _CodePrecoState extends State<CodePreco> {
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
    if (code.isEmpty) {
      setState(() => _error = 'Entrez le code reçu sur WhatsApp.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final offre = await _service.chercherOffre(code);
      if (!mounted) return;

      if (offre == null) {
        setState(() => _error = 'Ce code est invalide ou a déjà été utilisé.');
      } else {
        Navigator.pushNamed(
          context,
          '/precommander/formulaire',
          arguments: offre,
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
        title: const Text('Précommander'),
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Entrez le code que nous vous avons donné sur WhatsApp '
                    'pour accéder au formulaire.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Code de précommande',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.characters,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: 'Ex : K7X2M9',
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
                                : const Text('Continuer'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Pas encore de code ? Discutez avec nous sur WhatsApp.',
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