import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen.dart';
import 'main.dart';

enum FormSubmissionStatus{ initial, submitting, success, failure}

class FormViewState{
  const FormViewState({
    this.name = '',
    this.email = '',
    this.status = FormSubmissionStatus.initial,
    this.errorMessage,
});

  final String name;
  final String email;
  final FormSubmissionStatus status;
  final String? errorMessage;

  bool get isValid => name.trim().isNotEmpty && email.isNotEmpty;

  FormViewState copyWith({
    String? name,
    String? email,
    FormSubmissionStatus? status,
    String? errorMessage,
    bool clearError = false,
}) { return FormViewState(
    name: name?? this.name,
    email: email ?? this.email,
    status: status ?? this.status,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
  }
}

class FormCubit extends Cubit<FormViewState>{
  FormCubit(): super(const FormViewState());

  void nameChanged(String value){
    emit(
      state.copyWith(
        name: value,
        status: FormSubmissionStatus.initial,
        clearError: true,
      ),
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: FormSubmissionStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> submitForm() async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: FormSubmissionStatus.failure,
          errorMessage: 'Please complete all fields before submitting.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FormSubmissionStatus.submitting,
        clearError: true,
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 1));

    emit(
      const FormViewState(
        status: FormSubmissionStatus.success,
      ),
    );
  }

  void resetStatus() {
    if (state.status != FormSubmissionStatus.initial) {
      emit(
        state.copyWith(
          status: FormSubmissionStatus.initial,
          clearError: true,
        ),
      );
    }
  }
}