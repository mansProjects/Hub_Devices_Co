import 'package:flutter/material.dart';

class ConfirmationPrecommande extends StatelessWidget {
  final String nom;

  const ConfirmationPrecommande({super.key, required this.nom});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:Colors.green.shade50,
        border: Border.all(color:Colors.green.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width:35,
            height:35,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
          const SizedBox(width: 12),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Votre precommande est bien enregistree', style: TextStyle(fontWeight: FontWeight.bold, fontSize:14)
                ),
                 SizedBox(height: 4),
          Text(
                nom.isEmpty
                    ? 'Merci, paiement confirmé ! On s\'occupe du reste.'
                    : 'Merci $nom, paiement confirmé ! On s\'occupe du reste.',
                style: TextStyle(color: Colors.black54),
              ),
              ]

            ),
            )
      ],
      )
    );
  }
}