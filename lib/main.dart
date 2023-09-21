import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class UnitDef {
  final String id;
  final String label;
  final String primaryScaleId;
  final String secondaryScaleId;
  final List<ScaleDef> scales;

  const UnitDef({
    required this.id,
    required this.label,
    required this.primaryScaleId,
    required this.secondaryScaleId,
    required this.scales,
  });

  factory UnitDef.fromJson(Map<String, dynamic> json) {
    return UnitDef(
      id: json['id'],
      label: json['label'],
      primaryScaleId: json['primaryScaleId'],
      secondaryScaleId: json['secondaryScaleId'],
      scales: (json['scales'] as List<dynamic>)
          .map((e) => ScaleDef.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'primaryScaleId': primaryScaleId,
        'secondaryScaleId': secondaryScaleId,
        'scales': scales.map((e) => e.toJson()).toList()
      };
}

class ScaleDef {
  final String id;
  final String pluralLabel;
  final String abbreviation;
  final double conversionFactor;

  const ScaleDef({
    required this.id,
    required this.pluralLabel,
    required this.abbreviation,
    required this.conversionFactor,
  });

  factory ScaleDef.fromJson(Map<String, dynamic> json) {
    return ScaleDef(
      id: json['id'],
      pluralLabel: json['pluralLabel'],
      abbreviation: json['abbreviation'],
      conversionFactor: json['conversionFactor'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pluralLabel': pluralLabel,
        'abbreviation': abbreviation,
        'conversionFactor': conversionFactor,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: FutureBuilderExample()),
    );
  }
}

class FutureBuilderExample extends StatefulWidget {
  const FutureBuilderExample({super.key});

  @override
  State<FutureBuilderExample> createState() => _FutureBuilderExampleState();
}

class _FutureBuilderExampleState extends State<FutureBuilderExample> {
  late Future<List<UnitDef>> _jsonData;

  Future<List<UnitDef>> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/unit-data.json');
    List<dynamic> unmodeledList = jsonDecode(jsonString);
    List<UnitDef> result =
        unmodeledList.map((item) => UnitDef.fromJson(item)).toList();

    return result;
  }

  @override
  void initState() {
    super.initState();

    _jsonData = loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<List<UnitDef>>(
          future: _jsonData,
          builder:
              (BuildContext context, AsyncSnapshot<List<UnitDef>> snapshot) {
            if (snapshot.hasData) {
              List<UnitDef> jsonData = snapshot.data!;
              return ListView.builder(
                itemCount: jsonData.length,
                itemBuilder: (BuildContext context, int index) {
                  // Build your widgets based on jsonData[index]
                  return ListTile(
                    title: Text(jsonData[index].label),
                    subtitle: Text(jsonEncode(jsonData[index])),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
