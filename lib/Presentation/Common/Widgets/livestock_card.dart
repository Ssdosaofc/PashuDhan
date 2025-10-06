import 'package:flutter/material.dart';
import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';
import '../../../Domain/entities/animal_entity.dart';

class LivestockCard extends StatelessWidget {
  final AnimalEntity animal;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const LivestockCard({
    super.key,
    required this.animal,
    required this.onDelete, this.onTap,
  });

  String _getImageForAnimal(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('cow')) return AssetsConstants.cow;
    if (lower.contains('goat')) return AssetsConstants.goat;
    if (lower.contains('sheep')) return AssetsConstants.sheeps;
    if (lower.contains('duck')) return AssetsConstants.duck;
    if (lower.contains('camel')) return AssetsConstants.camel;
    if (lower.contains('horse')) return AssetsConstants.horse;
    if (lower.contains('hen')) return AssetsConstants.hen;
    return AssetsConstants.female_buffalo;
  }

  @override
  Widget build(BuildContext context) {
    final imageAsset = _getImageForAnimal(animal.name);

    return GestureDetector(
      onTap: onTap,
      child : Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageAsset,
                    width: 100,
                    height: 100,
                    // fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animal.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Healthy | ID #${animal.id}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
              ],
            ),
            Positioned(
              top: -10,
              right: -16,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
