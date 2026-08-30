class GeneratedTable {
  final String title; // 표 제목
  final String unit; // 단위
  final List<String> rows; // 행 라벨 (국어, 영어...)
  final List<String> cols; // 열 라벨 (1반, 2반...)
  final List<List<int>> data; // 실제 숫자 데이터 [행][열]
  final String rowSummaryLabel;
  final String columnSummaryLabel;
  final List<int> rowSummaries;
  final List<int> columnSummaries;
  final int grandSummary;

  GeneratedTable({
    required this.title,
    required this.unit,
    required this.rows,
    required this.cols,
    required this.data,
    required this.rowSummaryLabel,
    required this.columnSummaryLabel,
    required this.rowSummaries,
    required this.columnSummaries,
    required this.grandSummary,
  });
}
