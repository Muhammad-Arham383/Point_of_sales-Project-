abstract class ReportEvent {}

class FetchDailyReport extends ReportEvent {
  final String uid;

  FetchDailyReport(this.uid);
}

class FetchWeeklyReport extends ReportEvent {
  final String uid;

  FetchWeeklyReport(this.uid);
}

class FetchMonthlyReport extends ReportEvent {
  final String uid;

  FetchMonthlyReport(this.uid);
}
