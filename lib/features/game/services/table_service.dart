import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/table_schema.dart'; // masterDatasets와 IndependentSchema가 있는 곳
import '../models/table_data.dart';

class TableService {
  static final Random _random = Random();

  /// 스키마 ID를 받아 독립적인 표 데이터를 생성합니다.
  static GeneratedTable generate(String schemaId, {int colCount = 4}) {
    final schema = masterDatasets[schemaId];
    if (schema == null) throw Exception("Schema not found: $schemaId");

    // 1. 열 라벨(Column Labels) 생성
    List<String> shuffledNames = List.from(names)..shuffle(_random);
    List<String> colLabels = List.generate(colCount, (i) {
      int index = i + 1;
      String type = schema.col['type'];
      String suffix = schema.col['suffix'];

      if (type == 'number') return '$index$suffix';
      if (type == 'letter') return '${String.fromCharCode(64 + index)} $suffix';
      if (type == 'name') return shuffledNames[i % names.length];
      return '$index';
    });

    // 2. 행 라벨(Row Labels) 가져오기
    List<String> rowLabels = List<String>.from(schema.row['labels']);

    // 3. 숫자 데이터 생성 (min, max, step 활용)
    int range = (schema.max - schema.min) ~/ schema.step;
    List<List<int>> tableData = List.generate(rowLabels.length, (r) {
      return List.generate(colCount, (c) {
        return schema.min + (_random.nextInt(range + 1) * schema.step);
      });
    });

    GeneratedTable tableInfo = GeneratedTable(
      title: schema.dsc,
      unit: schema.unit,
      rows: rowLabels,
      cols: colLabels,
      data: tableData,
    );

    if (kDebugMode) {
      // 1. 기본 정보 출력
      print('\n[ ${tableInfo.title} ] (단위: ${tableInfo.unit})');
      print('=' * 50); // 상단 구분선

      // 2. 헤더(열 이름) 구성
      // '구분'이라는 첫 칸을 포함하여 출력
      StringBuffer header = StringBuffer('구분'.padRight(10));
      for (var col in tableInfo.cols) {
        header.write('| ${col.padRight(8)}');
      }
      print(header.toString());
      print('-' * 50); // 헤더 구분선

      // 3. 데이터 행 출력
      for (int i = 0; i < tableInfo.rows.length; i++) {
        StringBuffer row = StringBuffer(tableInfo.rows[i].padRight(10));
        for (var value in tableInfo.data[i]) {
          row.write('| ${value.toString().padRight(8)}');
        }
        print(row.toString());
      }
      print('=' * 50); // 하단 구분선
    }

    return tableInfo;
  }
}
