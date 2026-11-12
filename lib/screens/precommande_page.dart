import 'package:flutter/material.dart';
import '../configData/commande.dart';
import '../widgets/confirmation_card.dart';
import '../widgets/preco_product.dart';
import '../widgets/progress_card.dart';
import '../widgets/timeline_step.dart';
import '../widgets/recap_preco.dart';

class PrecommandePage extends StatelessWidget {
  final Commande commande;

  const PrecommandePage({super.key, required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Précommande'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConfirmationPrecommande(
              nom: commande.nameClient,
            ),
            const SizedBox(height: 24),
            PrecoProduct(
                  precoNameProduct:
                  commande.nameProduct.isEmpty ? 'Article' : commande.nameProduct,
                  precoPriceProduct: commande.prixAffiche,
                  precoDescriptionProduct: commande.description,
                  precoQuantityProduct: 'Quantité: ${commande.quantite}',
                ),

            const SizedBox(height: 24),
            ProgressCard(
                  valueDay: '${commande.joursRestants}',
                  titleDay: commande.joursRestants <= 1 ? 'jour restant' : 'jours restants',
                  subtitleDay: 'Avant l\'arrivée du colis.',
                  progressBar: commande.progression,
                  progressBarLabel: 'de la livraison atteinte !',
                      ),
            const SizedBox(height: 24),
            const Text(
              'E T A P E S',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TimelineCard(
              reachedSteps: commande.etapesAtteintes,
              steps: const [
                TimelineStep(
                  title: 'Commande enregistrée',
                  subtitle: 'Nous avons bien reçu votre commande.',
                ),
                TimelineStep(
                  title: 'Paiement confirmé',
                  subtitle: 'Votre paiement a été validé.',
                ),
                TimelineStep(
                  title: 'Préparation',
                  subtitle: 'Votre commande est en préparation.',
                ),
                TimelineStep(
                  title: 'Expédition',
                  subtitle: 'Votre colis est en route.',
                ),
                TimelineStep(
                  title: 'Livraison',
                  subtitle: 'Votre commande est arrivée.',
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'R E C A P I T U L A T I F',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RecapCard(
              orderDate: commande.dateCommande,
              customerNumber: commande.numeroClient,
              total: commande.total,
              isPaymentConfirmed: commande.paiementConfirme,
            ),
          ],
        ),
      ),
    );
  }
}