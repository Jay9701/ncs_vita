// 샘플 탭
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/table_schema.dart';

class SampleTab extends StatefulWidget {
  const SampleTab({super.key});

  @override
  State<SampleTab> createState() => _TableGeneratorScreenState();
}

class _TableGeneratorScreenState extends State<SampleTab> {
  String selectedId = 'IP001'; // 선택된 데이터셋 ID
  List<String> rowLabels = [];
  List<String> colLabels = [];
  List<List<int>> tableData = [];
  bool isGenerated = false;

  // 데이터 생성 함수
  void _generateTable() {
    final schema = masterDatasets[selectedId]!;
    final random = Random();
    const colCount = 4; // 열 개수 고정 (나중에 조절 가능)

    setState(() {
      List<String> shuffledNames = List.from(names)..shuffle(random);
      rowLabels = List<String>.from(schema.row['labels']);
      colLabels = List.generate(colCount, (i) {
        int index = i + 1;
        String type = schema.col['type'];
        String suffix = schema.col['suffix'];

        if (type == 'number') {
          return '$index$suffix';
        } else if (type == 'letter') {
          return '${String.fromCharCode(64 + index)} $suffix';
        } else if (type == 'name') {
          String name = shuffledNames[i % names.length];
          return name;
        }

        return '$index'; // 기본값
      });

      tableData = List.generate(rowLabels.length, (r) {
        return List.generate(colCount, (c) {
          int range = (schema.max - schema.min) ~/ schema.step;
          return schema.min + (random.nextInt(range + 1) * schema.step);
        });
      });
      isGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('데이터셋 표 생성기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 데이터셋 선택 드롭다운
            DropdownButton<String>(
              value: selectedId,
              items: masterDatasets.keys.map((id) {
                return DropdownMenuItem(
                  value: id,
                  child: Text('$id: ${masterDatasets[id]!.dsc}'),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedId = val!),
            ),
            const SizedBox(height: 20),

            // 실행 버튼 (오케이 버튼!)
            ElevatedButton(
              onPressed: _generateTable,
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('표 생성하기 (OK)', style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 30),

            // 생성된 표 표시 영역
            if (isGenerated) ...[
              Text(
                '[ ${masterDatasets[selectedId]!.dsc} ]',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '단위: ${masterDatasets[selectedId]!.unit}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      const DataColumn(label: Text('구분')),
                      ...colLabels.map(
                        (label) => DataColumn(label: Text(label)),
                      ),
                    ],
                    rows: List.generate(rowLabels.length, (index) {
                      return DataRow(
                        cells: [
                          DataCell(Text(rowLabels[index])),
                          ...tableData[index].map(
                            (val) => DataCell(Text(val.toString())),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ] else
              const Expanded(child: Center(child: Text('버튼을 눌러 데이터를 생성하세요.'))),
          ],
        ),
      ),
    );
  }
}
