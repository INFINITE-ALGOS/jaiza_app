import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomJobStreamBuilder extends StatefulWidget {
  final String jobStatus;
  const CustomJobStreamBuilder({super.key, required this.jobStatus});

  @override
  State<CustomJobStreamBuilder> createState() => _CustomJobStreamBuilderState();
}

class _CustomJobStreamBuilderState extends State<CustomJobStreamBuilder> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
