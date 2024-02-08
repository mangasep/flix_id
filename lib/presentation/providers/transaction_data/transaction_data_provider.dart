import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/transaction.dart';
import 'package:flix_id/domain/usecases/get_transactions/get_transactions.dart';
import 'package:flix_id/domain/usecases/get_transactions/get_transactions_param.dart';
import 'package:flix_id/presentation/providers/usecases/get_transactions_provider.dart';
import 'package:flix_id/presentation/providers/user_data/user_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/user.dart';

part 'transaction_data_provider.g.dart';

@Riverpod(keepAlive: true)
class TransactionData extends _$TransactionData {
  @override
  Future<List<Transaction>> build() async {
    User? user = ref.read(userDataProvider).valueOrNull;

    if (user != null) {
      state = const AsyncLoading();

      GetTranscations getTranscations = ref.read(getTranscationsProvider);

      var result = await getTranscations(GetTransactionsParam(uid: user.uid));

      if (result case Success(value: final transactions)) {
        return transactions;
      }
    }
    return const [];
  }

  Future<void> refreshTransactionData() async {
    User? user = ref.read(userDataProvider).valueOrNull;

    if (user != null) {
      state = const AsyncLoading();

      GetTranscations getTranscations = ref.read(getTranscationsProvider);

      var result = await getTranscations(GetTransactionsParam(uid: user.uid));

      switch (result) {
        case Success(value: final transactions):
          state = AsyncData(transactions);
        case Failed(:final message):
          state = AsyncError(FlutterError(message), StackTrace.current);
          state = AsyncData(state.valueOrNull ?? const []);
      }
    }
  }
}
