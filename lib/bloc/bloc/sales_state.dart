abstract class ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final double totalAmount;

  ReportLoaded(this.totalAmount);
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}
