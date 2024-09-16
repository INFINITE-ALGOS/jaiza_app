import 'package:flutter/material.dart';
import 'package:law_education_app/widgets/custom_servicestatus_future_builder.dart';

class RejectedServiceScreenLawyer extends StatefulWidget {
  const RejectedServiceScreenLawyer({super.key});

  @override
  State<RejectedServiceScreenLawyer> createState() => _RejectedServiceScreenLawyerState();
}

class _RejectedServiceScreenLawyerState extends State<RejectedServiceScreenLawyer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomServiceStreamBuilder(serviceStatus: "rejected"),
    );
  }
}
