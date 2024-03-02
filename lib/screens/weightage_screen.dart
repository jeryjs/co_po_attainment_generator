// ignore_for_file: prefer_const_constructors
import 'package:co_po_attainment_v2_1_flutter/utils/excel_writer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeightagePage extends StatefulWidget {
  const WeightagePage({super.key});

  bool isFilled() {
    return true;
  }

  @override
  State<WeightagePage> createState() => _WeightagePageState();
}

class _WeightagePageState extends State<WeightagePage> {
  @override
  Widget build(BuildContext context) {
    final scr = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.fromBorderSide(BorderSide(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            width: 2)),
      ),
      width: scr.width * 0.85,
      height: scr.height * 0.8,
      child: buildView(),
    );
  }

  Widget buildView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Expanded(flex: 3, child: buildCoTarget()),
              Expanded(flex: 6, child: buildAttainmentLevel()),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: buildAttainment(),
        ),
        ElevatedButton(
          onPressed: () => ExcelWriter().writeToExcel(),
          child: Text('Test write to excel'),
        ),
      ],
    );
  }
}

Widget buildCoTarget() {
  return Card(
    child: ListView(
      children: [
        ListTile(
          title: Text('CO1'),
          subtitle: Text('Target: 80%'),
        ),
        ListTile(
          title: Text('CO2'),
          subtitle: Text('Target: 70%'),
        ),
        ListTile(
          title: Text('CO3'),
          subtitle: Text('Target: 60%'),
        ),
        ListTile(
          title: Text('CO4'),
          subtitle: Text('Target: 50%'),
        ),
        ListTile(
          title: Text('CO5'),
          subtitle: Text('Target: 40%'),
        ),
      ],
    
    ),
  );
}

Widget buildAttainmentLevel() {
  return Card(
    child: Placeholder(),
  );
}

Widget buildAttainment() {
  return Card(
    child: Placeholder(),
  );
}
