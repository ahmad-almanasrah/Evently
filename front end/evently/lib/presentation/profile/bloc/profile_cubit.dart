import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evently/data/repo/home/profile_repo.dart';
import 'package:evently/presentation/profile/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  // Constructor: We require the Repo to do our job
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  // The function the UI will call
  Future<void> getProfileData() async {
    // 1. Show Loading Spinner
    emit(ProfileLoading());

    try {
      // 2. Ask Repo for data (This might take a second)
      final userModel = await profileRepo.getUserProfile();

      // 3. Success! Hand the data to the UI
      emit(ProfileSuccess(userModel));
    } catch (e) {
      // 4. Failure! Show error message
      emit(ProfileError(e.toString()));
    }
  }
}
