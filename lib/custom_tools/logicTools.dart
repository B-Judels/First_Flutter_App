import 'package:freeuse_monthly_expense_tracker/models/DebitOrder.dart';
import 'package:freeuse_monthly_expense_tracker/models/Service.dart';
import 'package:freeuse_monthly_expense_tracker/models/DailyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/MedicalAid.dart';

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
