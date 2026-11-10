import 'package:flutter/material.dart';

class PrecoProduct extends StatelessWidget{
  final String precoNameProduct;
  final String precoPriceProduct;
  final String precoDescriptionProduct;
  final String precoQuantityProduct;
  final String? imagePath;

  const PrecoProduct(
    {
      super.key,
      required this.precoNameProduct,
      required this.precoPriceProduct,
      required this.precoDescriptionProduct,
      required this.precoQuantityProduct,
      this.imagePath,
    }
  );

  @override
  Widget build(BuildContext context){
    return Container(
      padding:  const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(color: Color(0xEEE3F3FA)),
        borderRadius: BorderRadius.circular(12),
     
      ),
     child : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                precoNameProduct,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  ),
              ),
               const SizedBox(height: 4),
              Text(
               precoPriceProduct,
               style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.indigo,
                ),
              ),
                const SizedBox(height: 4),
              Text(
                precoDescriptionProduct,
                style: const TextStyle(color: Colors.black54),
              ),
               Text(
                precoQuantityProduct,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
            ) ,
          ),
    ],
    )
    );
   
}

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 90,
        height: 90,
        child: imagePath == null
            ? Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image_outlined,
                  size: 36,
                  color: Colors.grey,
                ),
              )
            : Image.asset(imagePath!, fit: BoxFit.cover),
      ),
    );
  }


}