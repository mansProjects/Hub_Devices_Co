import 'package:flutter/material.dart';

class RecapCard extends StatelessWidget {
  final String orderDate;
  final String customerNumber;
  final String total;
  final bool isPaymentConfirmed;

  const RecapCard({
    super.key,
    required this.orderDate,
    required this.customerNumber,
    required this.total,
    required this.isPaymentConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRow('Date', _buildValue(orderDate)),
          const Divider(height: 24),
          _buildRow('Numéro ', _buildValue(customerNumber)),
          const Divider(height: 24),
          _buildRow('Total', _buildValue(total)),
          const Divider(height: 24),
          _buildRow('Paiement', _buildStatus()),
        ],
      ),
    );
  }

  Widget _buildRow(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        value,
      ],
    );
  }

  Widget _buildValue(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaymentConfirmed
            ? Colors.green.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaymentConfirmed ? 'Confirmé' : 'En attente',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isPaymentConfirmed
              ? Colors.green.shade800
              : Colors.orange.shade800,
        ),
      ),
    );
  }
}