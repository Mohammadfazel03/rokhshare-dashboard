part of 'collection_append_cubit.dart';

@immutable
sealed class CollectionAppendState {}

final class CollectionAppendInitial extends CollectionAppendState {}

final class CollectionAppendLoading extends CollectionAppendState {}

final class CollectionAppendSuccessAppend extends CollectionAppendState {}

final class CollectionAppendSuccessUpdate extends CollectionAppendState {}

final class CollectionAppendSuccess extends CollectionAppendState {
  final Collection collection;

  CollectionAppendSuccess({required this.collection});
}

final class CollectionAppendFailed extends CollectionAppendState {
  final String message;
  final int? code;

  CollectionAppendFailed({required this.message, this.code});
}
