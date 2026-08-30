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
    final rowSummary = schema.rowSummary ?? TableSummary.sum;
    final columnSummary = schema.columnSummary ?? TableSummary.sum;

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

    // 3. 숫자 데이터 생성 및 평균 요약을 위한 정수값 검증
    final range = (schema.max - schema.min) ~/ schema.step;
    late List<List<int>> tableData;
    late List<int> rowSums;
    late List<int> columnSums;

    for (var attempt = 0; attempt < 1000; attempt++) {
      tableData = List.generate(rowLabels.length, (rowIndex) {
        return List.generate(colCount, (columnIndex) {
          return schema.min + (_random.nextInt(range + 1) * schema.step);
        });
      });
      rowSums = tableData
          .map((row) => row.reduce((sum, value) => sum + value))
          .toList();
      columnSums = List.generate(
        colCount,
        (columnIndex) => tableData
            .map((row) => row[columnIndex])
            .reduce((sum, value) => sum + value),
      );

      final rowsAreIntegral =
          rowSummary != TableSummary.average ||
          rowSums.every((sum) => sum % colCount == 0);
      final columnsAreIntegral =
          columnSummary != TableSummary.average ||
          columnSums.every((sum) => sum % rowLabels.length == 0);
      if (rowsAreIntegral && columnsAreIntegral) break;
      if (attempt == 999) {
        throw StateError('Unable to generate integral table averages.');
      }
    }

    final rowSummaries = rowSummary == TableSummary.average
        ? rowSums.map((sum) => sum ~/ colCount).toList()
        : rowSums;
    final columnSummaries = columnSummary == TableSummary.average
        ? columnSums.map((sum) => sum ~/ rowLabels.length).toList()
        : columnSums;
    final grandSummary = rowSums.reduce((sum, value) => sum + value);

    GeneratedTable tableInfo = GeneratedTable(
      title: schema.dsc,
      unit: schema.unit,
      rows: rowLabels,
      cols: colLabels,
      data: tableData,
      rowSummaryLabel: rowSummary == TableSummary.average ? '평균' : '합',
      columnSummaryLabel: columnSummary == TableSummary.average ? '평균' : '합',
      rowSummaries: rowSummaries,
      columnSummaries: columnSummaries,
      grandSummary: grandSummary,
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
