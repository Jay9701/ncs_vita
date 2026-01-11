import 'dart:math';
import 'package:flutter/material.dart';

enum TableId { IP001, IP002, IP003, IP004 }

class IndependentSchema {
  final String dsc;
  final int min;
  final int max;
  final int step;
  final String unit;
  final Map<String, dynamic> row;
  final Map<String, dynamic> col;

  IndependentSchema({
    required this.dsc,
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
    required this.row,
    required this.col,
  });
}

final Map<String, IndependentSchema> masterDatasets = {
  'IP001': IndependentSchema(
    dsc: "학급별 시험성적",
    min: 20,
    max: 100,
    step: 1,
    unit: "점",
    row: {
      'auto': false,
      'labels': ["국어", "영어", "수학", "과학", "사회"],
    },
    col: {'auto': true, 'suffix': "반", 'type': "number"},
  ),
  'IP002': IndependentSchema(
    dsc: "지역별 지출액",
    min: 1000,
    max: 5000,
    step: 100,
    unit: "천 원",
    row: {
      'auto': false,
      'labels': ["식비", "교통비", "문화비", "기타"],
    },
    col: {'auto': true, 'suffix': "지역", 'type': "letter"},
  ),
  'IP003': IndependentSchema(
    dsc: "창고별 재고량",
    min: 100,
    max: 2000,
    step: 50,
    unit: "개",
    row: {
      'auto': false,
      'labels': ["TV", "냉장고", "세탁기", "에어컨", "건조기"],
    },
    col: {'auto': true, 'suffix': "창고", 'type': "number"},
  ),
  'IP004': IndependentSchema(
    dsc: "개인별 운동 시간",
    min: 1,
    max: 6,
    step: 1,
    unit: "시간",
    row: {
      'auto': false,
      'labels': ["1주차", "2주차", "3주차", "4주차"],
    },
    col: {'auto': true, 'suffix': "", 'type': "name"},
  ),
};

final List<String> names = ['철수', '영희', '세희', '재훈', '하준', '지은'];
