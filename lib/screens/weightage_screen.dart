// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class WeightagePage extends StatefulWidget {
  const WeightagePage({super.key});

  bool isFilled() { return true; }

  @override
  State<WeightagePage> createState() => _WeightagePageState();
}

class _WeightagePageState extends State<WeightagePage> {
  @override
  Widget build(BuildContext context) {
    final scr = MediaQuery.of(context).size;
    return Placeholder(
      fallbackWidth : scr.width * 0.85,
    );
  }
}