import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:myaccount/features/user/validations/email.dart';
import 'package:myaccount/commons/validations/validations.dart';
import 'package:myaccount/features/user/validations/password.dart';
import 'package:user_repository/user_repository.dart';
import 'package:myaccount/commons/extensions/string.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState()) {
    on<UserEmailChanged>(_onEmailChanged);
    on<UserNameChanged>(_onNameChanged);
    on<UserPasswordChanged>(_onPasswordChanged);
    on<UserConfirmationPasswordChanged>(_onConfirmationPasswordChanged);
    on<UserFamilyNameChanged>(_onFamilyNameChanged);
    on<UserPictureChanged>(_onPictureChanged);
    on<UserBirthdateChanged>(_onBirthdateChanged);
    on<UserGenderChanged>(_onGenderChanged);

    on<UserUpdateSubmitted>(_onUpdate);
    on<UserRegistrationSubmitted>(_onRegister);
  }

  final UserRepository _userRepository;

  void _onEmailChanged(
    UserEmailChanged event,
    Emitter<UserState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.name,
        state.password,
        state.confirmationPassword,
        state.familyName,
        state.picture,
        state.birthdate,
        state.gender
      ]),
    ));
  }

  void _onNameChanged(
    UserNameChanged event,
    Emitter<UserState> emit,
  ) {
    final name = SimpleString.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([
        state.email,
        name,
        state.password,
        state.confirmationPassword,
        state.familyName,
        state.picture,
        state.birthdate,
        state.gender
      ]),
    ));
  }

  void _onFamilyNameChanged(
    UserFamilyNameChanged event,
    Emitter<UserState> emit,
  ) {
    final familyName = SimpleString.dirty(event.familyName);
    emit(state.copyWith(
      familyName: familyName,
      status: Formz.validate([
        state.email,
        state.name,
        state.password,
        state.confirmationPassword,
        familyName,
        state.picture,
        state.birthdate,
        state.gender
      ]),
    ));
  }

  void _onPictureChanged(
    UserPictureChanged event,
    Emitter<UserState> emit,
  ) {
    final picture = SimpleString.dirty(event.picture);
    emit(state.copyWith(
      picture: picture,
      status: Formz.validate([
        state.email,
        state.name,
        state.password,
        state.confirmationPassword,
        state.familyName,
        picture,
        state.birthdate,
        state.gender
      ]),
    ));
  }

  void _onBirthdateChanged(
    UserBirthdateChanged event,
    Emitter<UserState> emit,
  ) {
    final birthdate = SimpleString.dirty(event.birthdate);
    emit(state.copyWith(
      birthdate: birthdate,
      status: Formz.validate([
        state.email,
        state.name,
        state.password,
        state.confirmationPassword,
        state.familyName,
        state.picture,
        birthdate,
        state.gender
      ]),
    ));
  }

  void _onGenderChanged(
    UserGenderChanged event,
    Emitter<UserState> emit,
  ) {
    final gender = SimpleString.dirty(event.gender);
    emit(state.copyWith(
      gender: gender,
      status: Formz.validate([
        state.email,
        state.name,
        state.password,
        state.confirmationPassword,
        state.familyName,
        state.picture,
        gender,
        state.gender
      ]),
    ));
  }

  void _onPasswordChanged(
    UserPasswordChanged event,
    Emitter<UserState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        state.name,
        password,
        state.confirmationPassword,
        state.familyName,
        state.picture,
        state.gender,
        state.gender
      ]),
    ));
  }

  void _onConfirmationPasswordChanged(
    UserConfirmationPasswordChanged event,
    Emitter<UserState> emit,
  ) {
    final confirmationPassword = Password.dirty(event.passwordConfirmation);
    emit(state.copyWith(
      confirmationPassword: confirmationPassword,
      status: Formz.validate([
        state.email,
        state.name,
        state.password,
        confirmationPassword,
        state.familyName,
        state.picture,
        state.gender,
        state.gender
      ]),
    ));
  }

  void _onRegister(
    UserRegistrationSubmitted event,
    Emitter<UserState> emit,
  ) async {
    if (state.status.isInvalid || state.status.isPure) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      return;
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _userRepository.register(state.toFullDto());
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onUpdate(
    UserUpdateSubmitted event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    if (!state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      return;
    }

    try {
      await _userRepository.update(state.toPartialDto());
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
