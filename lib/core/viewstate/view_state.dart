// ignore_for_file: constant_identifier_names

class ViewState<T> {
  late Status status;
  late T data;
  late String message;

  ViewState.loading() : status = Status.LOADING;
  ViewState.completed(this.data) : status = Status.COMPLETED;
  ViewState.error(this.message) : status = Status.ERROR;
  ViewState.initial() : status = Status.INITIAL;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { INITIAL, LOADING, COMPLETED, ERROR }
