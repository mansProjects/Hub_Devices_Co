import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HubDevicesPage extends StatelessWidget {
  final String _urlFacebook = "https://www.facebook.com/share/1DgYxwmGfY/";
  final String _urlInstagram =
      "https://www.instagram.com/hub_dco?igsh=MTFjczN0YTh6OGlpNw==";

  const HubDevicesPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d\'ouvrir $url';
    }
  }

  Future<void> _sendEmailContact() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'Contact@hubdevices.com',
      queryParameters: {'subject': 'Demande d\'informations - Hub & Devices'},
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Erreur mail : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.3,
            colors: [
              Color(0xFF1E6DBE), // Bleu éclatant au centre
              Color(0xFF1E6DBE), // Bleu nuit profond sur les bords
            ],
          ),
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 70.0,
                      floating: false,
                      pinned: true, // Reste fixé en haut lors du scroll
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      centerTitle: true,
                      title: const Text(
                        "À PROPOS DE NOUS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(1.0),
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.15),
                          height: 1.0,
                        ),
                      ),
                    ),
                  ];
                },
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // --- CARTE BIOGRAPHIE (GLASSMORPHISM) ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          "Nous sommes Hub & Devices Co., une boutique en ligne fonctionnelle à Kinshasa, avec une idée simple : la qualité ne devrait pas être un luxe.Dans un marché où trop souvent les produits déçoivent, nous avons choisi de faire les choses autrement.Offrir des appareils fiables, modernes et accessibles, directement depuis votre téléphone, sans détour ni complication.\n\nNous sommes une équipe passionnée et proche de vous.Notre énergie vient de la conviction que la technologie peut transformer le quotidien, et que chacun mérite d’y accéder facilement.Livraison rapide, paiement sécurisé à la réception : nous avons pensé à tout pour que l’expérience soit fluide.\n\nEt demain ? Notre vision grandit chaque jour.Nous construisons pas à pas quelque chose qui dépasse le présent.Restez connectés… Avec nous.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.6,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // --- SECTION CONTACT ACROCHE ---
                  Text(
                    "PRENDRE CONTACT",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --- BOUTONS DE CONTACT RAPIDE (UX AMÉLIORÉE) ---
                  Row(
                    children: [
                      // Bouton WhatsApp
                      Expanded(
                        child: _buildContactButton(
                          icon: FontAwesomeIcons.whatsapp,
                          label: "WhatsApp",
                          color: const Color(0xFF25D366),
                          onTap: () async {
                            var url = "whatsapp://send?phone=+243840513896";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              await launchUrl(
                                Uri.parse("https://wa.me/243840513896"),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Bouton Appel
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.phone_in_talk_rounded,
                          label: "Appeler",
                          color: Colors.white,
                          iconColor: const Color(0xFF0D47A1),
                          textColor: const Color(0xFF0D47A1),
                          onTap: () async {
                            final Uri tel = Uri(
                              scheme: 'tel',
                              path: '+243840513896',
                            );
                            if (await canLaunchUrl(tel)) await launchUrl(tel);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bouton Email Large
                  InkWell(
                    onTap: _sendEmailContact,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Contact@hubdevices.com",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- RÉSEAUX SOCIAUX ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIconButton(
                        icon: FontAwesomeIcons.facebook,
                        onTap: () => _launchURL(_urlFacebook),
                      ),
                      const SizedBox(width: 30),
                      _buildSocialIconButton(
                        icon: FontAwesomeIcons.instagram,
                        onTap: () => _launchURL(_urlInstagram),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // --- FOOTER BRANDING ---
                  Column(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "HUB & DEVICES CO.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget : Créateur de boutons élégants
  Widget _buildContactButton({
    required dynamic icon,
    required String label,
    required Color color,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                icon is FaIconData
                ? FaIcon(icon, color: iconColor, size: 20)
                : Icon(icon as IconData, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget : Boutons réseaux sociaux minimalistes
  Widget _buildSocialIconButton({
    required FaIconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: FaIcon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
