import 'package:flutter/material.dart';
import 'package:skin_firts/core/constants/color_manager.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final VoidCallback onclick;

  const DoctorCard({
    Key? key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount, required this.onclick, required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onclick,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Info",
                          style: TextStyle(fontSize: 14, color: AppColors.mainWhite),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _circleIcon(Icons.calendar_month),
                      const SizedBox(width: 8),
                      _circleIcon(Icons.info_outline),
                      const SizedBox(width: 8),
                      _circleIcon(Icons.help_outline),
                      const SizedBox(width: 8),
                      _circleIcon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: AppColors.primaryColor),
    );
  }
}
