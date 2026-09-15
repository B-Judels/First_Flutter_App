import 'package:freeuse_monthly_expense_tracker/models/debit_order.dart';
import 'package:freeuse_monthly_expense_tracker/models/service_model.dart';
import 'package:freeuse_monthly_expense_tracker/models/daily_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/medical_aid.dart';

class LogicTools {
  const LogicTools();

  List<DebitOrder> debitOrderItemRemover(
    List<DebitOrder> dOrders,
    int elementNum,
  ) {
    dOrders.removeAt(elementNum);
    return dOrders;
  }

  List<Service> serviceItemRemover(List<Service> services, int elementNum) {
    services.removeAt(elementNum);
    return services;
  }

  List<DailyHabit> dHabitItemRemover(List<DailyHabit> habits, int elementNum) {
    habits.removeAt(elementNum);
    return habits;
  }

  List<MedicalAid> medAidItemRemover(List<MedicalAid> meds, int elementNum) {
    meds.removeAt(elementNum);
    return meds;
  }
}
