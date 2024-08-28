import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/widgets/custom_servicestatus_future_builder.dart';

class ActiveServiceScreenLawyer extends StatefulWidget {
  const ActiveServiceScreenLawyer({super.key});
  @override
  State<ActiveServiceScreenLawyer> createState() => _ActiveServiceScreenLawyerState();
}

class _ActiveServiceScreenLawyerState extends State<ActiveServiceScreenLawyer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomServiceStreamBuilder(serviceStatus: "accepted"),
    );
  }
}
