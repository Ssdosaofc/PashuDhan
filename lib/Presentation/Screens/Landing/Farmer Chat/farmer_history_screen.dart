import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Constants/color_constants.dart';
import '../../../../Domain/entities/treatment_entity.dart';
import '../../../bloc/treatment_bloc/treatment_bloc.dart';
import '../../../bloc/treatment_bloc/treatment_event.dart';
import '../../../bloc/treatment_bloc/treatment_state.dart';

class FarmerHistoryScreen extends StatefulWidget {
  const FarmerHistoryScreen({super.key});

  @override
  State<FarmerHistoryScreen> createState() => _FarmerHistoryScreenState();
}

class _FarmerHistoryScreenState extends State<FarmerHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TreatmentBloc>().add(FetchAllTreatments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      body: BlocBuilder<TreatmentBloc, TreatmentState>(
        builder: (context, state) {
          if (state is TreatmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TreatmentError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is TreatmentLoaded) {
            final treatments = state.treatments;

            if (treatments.isEmpty) {
              return const Center(
                child: Text(
                  "No treatments found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: treatments.length,
              itemBuilder: (context, index) {
                final treatment = treatments[index];
                return _buildTreatmentCard(treatment);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTreatmentCard(TreatmentEntity treatment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal & Disease
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  treatment.animal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  treatment.when,
                  style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              treatment.disease,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              treatment.prescription,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text("Dosage: ${treatment.dosage}", style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 20),
                Text("Duration: ${treatment.duration} days", style: const TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
