import 'package:first_flutter_app/models/DebitOrder.dart';
import 'package:first_flutter_app/models/Service.dart';
import 'package:first_flutter_app/models/DailyHabit.dart';
import 'package:first_flutter_app/models/MedicalAid.dart';

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
