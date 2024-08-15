import 'package:bloc/bloc.dart';
import 'package:dashboard/feature/episode/data/repositories/episode_repository.dart';
import 'package:dashboard/feature/movie/data/remote/model/comment.dart';
import 'package:dashboard/utils/data_response.dart';
import 'package:dashboard/utils/page_response.dart';
import 'package:flutter/material.dart';

part 'comment_table_state.dart';

class CommentTableCubit extends Cubit<CommentTableState> {
  final EpisodeRepository _repository;

  CommentTableCubit({required EpisodeRepository repository})
      : _repository = repository,
        super(const CommentTableInitial());

  Future<void> getData({required int episodeId, int page = 1}) async {
    emit(CommentTableLoading(numberPages: state.numberPages, pageIndex: page));
    DataResponse<PageResponse<Comment>> response =
        await _repository.getComments(episodeId: episodeId, page: page);
    if (response is DataFailed) {
      emit(CommentTableError(
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: page,
          numberPages: state.numberPages));
    } else {
      emit(CommentTableSuccess(
          data: response.data!,
          numberPages: response.data!.totalPages!,
          pageIndex: page));
    }
  }

  Future<void> changeState(
      {required int commentId,
      required CommentState commentState,
      required int mediaId}) async {
    emit(CommentTableLoading(
        numberPages: state.numberPages, pageIndex: state.pageIndex));
    DataResponse<void> response = await _repository.changeCommentState(
        commentId: commentId, state: commentState.serverKey);
    if (response is DataFailed) {
      var temp = commentState == CommentState.accept ? "تایید" : "رد";
      emit(CommentTableError(
          title: "خطا در $temp نظر",
          error: response.error ?? "مشکلی پیش آمده است",
          code: response.code,
          pageIndex: state.pageIndex,
          numberPages: state.numberPages));
    } else {
      getData(page: state.pageIndex, episodeId: mediaId);
    }
  }
}
