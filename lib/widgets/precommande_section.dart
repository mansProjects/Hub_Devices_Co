import 'package:flutter/material.dart';

class PrecommandeSection extends StatefulWidget {
  final VoidCallback onPrecommander;
  final VoidCallback onSuivre;

  const PrecommandeSection({
    super.key,
    required this.onPrecommander,
    required this.onSuivre,
  });

  @override
  State<PrecommandeSection> createState() => _PrecommandeSectionState();
}

class _PrecommandeSectionState extends State<PrecommandeSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  static const Color _bleuNuit = Color(0xFF0B3C7A);
  static const Color _bleuMarque = Color(0xFF1E6DBE);
  static const Color _bleuCiel = Color(0xFF42B0F0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AnimatedBuilder(
        animation: _controller,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool large = constraints.maxWidth >= 600;
              return large ? _buildLarge() : _buildEtroit();
            },
          ),
        ),
        builder: (context, child) {
          final double t = Curves.easeInOut.transform(_controller.value);
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + t, -1),
                end: Alignment(1, 1 - t),
                colors: const [_bleuNuit, _bleuMarque, _bleuCiel],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -50 + 25 * t,
                  right: -30 + 20 * t,
                  child: _bulle(170, 0.10),
                ),
                Positioned(
                  bottom: -20 + 18 * t,
                  left: 120 - 30 * t,
                  child: _bulle(90, 0.10),
                ),
                Positioned(
                  top: 90 - 25 * t,
                  left: -14 + 22 * t,
                  child: _bulle(60, 0.12),
                ),
                child!,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bulle(double diametre, double opacite) {
    return Container(
      width: diametre,
      height: diametre,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacite),
      ),
    );
  }

  Widget _buildLarge() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildGauche()),
          const SizedBox(width: 24),
          Expanded(child: _buildPanneauSuivi(large: true)),
        ],
      ),
    );
  }

  Widget _buildEtroit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGauche(),
        const SizedBox(height: 24),
        _buildPanneauSuivi(large: false),
      ],
    );
  }

  Widget _buildGauche() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBadge(),
        const SizedBox(height: 14),
        const Text(
          'Précommandez tous vos produits HighTech chez nous !',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Et soyez livré au meilleur délai.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.05).animate(_controller),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _bleuNuit,
              elevation: 6,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: widget.onPrecommander,
            icon: const Icon(Icons.arrow_forward, size: 18),
            iconAlignment: IconAlignment.end,
            label: const Text('Précommander'),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _pulse,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF5CFF9D),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Précommandes ouvertes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanneauSuivi({required bool large}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Déjà précommandé ?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Entrez votre numéro de téléphone pour suivre l\'avancement '
            'de votre commande jusqu\'à la livraison.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          large ? const Spacer() : const SizedBox(height: 16),
              Align(
            alignment: large ? Alignment.centerRight : Alignment.center,
            child: SizedBox(
              width: large ? null : double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                ),
                onPressed: widget.onSuivre,
                child: const Text(
                  'Suivre ma précommande',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}