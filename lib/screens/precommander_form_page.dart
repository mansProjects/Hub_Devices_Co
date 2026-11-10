import 'package:flutter/material.dart';
import '../services/cmd_services.dart';

class PrecommanderFormPage extends StatefulWidget {
  final Offre offre;

  const PrecommanderFormPage({super.key, required this.offre});

  @override
  State<PrecommanderFormPage> createState() => _PrecommanderFormPageState();
}

class _PrecommanderFormPageState extends State<PrecommanderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _service = CommandeService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nomController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final numeroClient = await _service.enregistrerPrecommande(
        code: widget.offre.code,
        nom: _nomController.text.trim(),
        telephone: _telephoneController.text.trim(),
      );
      if (!mounted) return;

      if (numeroClient == null) {
        setState(() => _error =
            'Ce code n\'est plus valide ou les informations sont incorrectes.');
      } else {
        await _afficherSucces(numeroClient);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _error =
          'Connexion impossible. Vérifiez votre internet et réessayez.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _afficherSucces(String numeroClient) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Précommande enregistrée'),
        content: Text(
          'Votre numéro client est $numeroClient.\n\n'
          'Vous pouvez suivre votre commande avec votre numéro de téléphone.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              dialogContext,
              '/suivi',
              (route) => route.isFirst,
            ),
            child: const Text('Suivre ma précommande'),
          ),
        ],
      ),
    );
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ma précommande',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vérifiez votre article, puis complétez vos informations.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    _buildOffreVerrouillee(),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nomController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'Ex : Alex Kanguvu',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'Entrez votre nom.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: 'Ex : 081 234 5678',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final digits =
                            (value ?? '').replaceAll(RegExp(r'\D'), '');
                        if (digits.length < 9) {
                          return 'Entrez un numéro de téléphone valide.';
                        }
                        return null;
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
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
                            : const Text('Valider ma précommande'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffreVerrouillee() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Article',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      widget.offre.article,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.lock_outline, size: 20, color: Colors.black45),
            ],
          ),
          const Divider(height: 20),
          const Text(
            'Prix convenu',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            widget.offre.prix,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF0077B5),
            ),
          ),
        ],
      ),
    );
  }
}