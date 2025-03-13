import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/sales_event.dart';
import 'package:pos_project/bloc/bloc/sales_state.dart';
import 'package:pos_project/models/transaction.dart';
import 'package:pos_project/services/firestore_services.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final FirestoreService firestoreService; // Assume you have this service

  ReportBloc(this.firestoreService) : super(ReportLoading()) {
    on<FetchDailyReport>((event, emit) async {
      emit(ReportLoading());
      try {
        DateTime today = DateTime.now();
        DateTime start = DateTime(today.year, today.month, today.day);
        DateTime end = start.add(const Duration(days: 1));

        List<Transactions> transactions = await firestoreService
            .fetchTransactionsByDateRange(start, end, event.uid);

        double totalAmount = transactions.fold(
            0, (sum, transaction) => sum + transaction.amount);

        emit(ReportLoaded(totalAmount));
      } catch (e) {
        emit(ReportError("Failed to fetch daily report"));
      }
    });

    on<FetchWeeklyReport>((event, emit) async {
      emit(ReportLoading());
      try {
        DateTime today = DateTime.now();
        DateTime start = today.subtract(Duration(days: today.weekday - 1));
        DateTime end = start.add(const Duration(days: 7));

        List<Transactions> transactions = await firestoreService
            .fetchTransactionsByDateRange(start, end, event.uid);

        double totalAmount = transactions.fold(
            0, (sum, transaction) => sum + transaction.amount);

        emit(ReportLoaded(totalAmount));
      } catch (e) {
        emit(ReportError("Failed to fetch weekly report"));
      }
    });

    on<FetchMonthlyReport>((event, emit) async {
      emit(ReportLoading());
      try {
        DateTime today = DateTime.now();
        DateTime start = DateTime(today.year, today.month, 1);
        DateTime end = DateTime(today.year, today.month + 1, 1);

        List<Transactions> transactions = await firestoreService
            .fetchTransactionsByDateRange(start, end, event.uid);

        double totalAmount = transactions.fold(
            0, (sum, transaction) => sum + transaction.amount);

        emit(ReportLoaded(totalAmount));
      } catch (e) {
        emit(ReportError("Failed to fetch monthly report"));
      }
    });
  }
}
