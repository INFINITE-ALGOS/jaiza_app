import 'package:flutter/material.dart';
import 'package:law_education_app/widgets/custom_servicestatus_future_builder.dart';

class PendingServiceScreenLawyer extends StatefulWidget {
  const PendingServiceScreenLawyer({super.key});

  @override
  State<PendingServiceScreenLawyer> createState() => _PendingServiceScreenLawyerState();
}

class _PendingServiceScreenLawyerState extends State<PendingServiceScreenLawyer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomServiceStreamBuilder(serviceStatus: "pending"),
    );
  }
}
