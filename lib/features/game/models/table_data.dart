class GeneratedTable {
  final String title; // 표 제목
  final String unit; // 단위
  final List<String> rows; // 행 라벨 (국어, 영어...)
  final List<String> cols; // 열 라벨 (1반, 2반...)
  final List<List<int>> data; // 실제 숫자 데이터 [행][열]

  GeneratedTable({
    required this.title,
    required this.unit,
    required this.rows,
    required this.cols,
    required this.data,
  });
}
