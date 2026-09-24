import 'package:sqflite/sqflite.dart';

String saveErrorMessage(Object error) {
  String code = 'SAVE-UNKNOWN';
  if (error is DatabaseException) {
    code = error.isNoSuchTableError()
        ? 'DB-SCHEMA'
        : error.isReadOnlyError()
        ? 'DB-READONLY'
        : error.isDatabaseClosedError()
        ? 'DB-CLOSED'
        : 'DB-${error.getResultCode() ?? 'UNKNOWN'}';
  } else if (error is ArgumentError || error is FormatException) {
    return 'Please check your income and expense amounts, then try again. (SAVE-INPUT)';
  }
  return 'Unable to save. Your changes are still here; please retry. ($code)';
}
