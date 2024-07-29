part of 'artist_section_cubit.dart';

final class ArtistSectionState {
  final List<Cast> casts;
  final Position? selectedRole;
  final String? error;

  const ArtistSectionState(
      {required this.casts, required this.selectedRole, required this.error});

  ArtistSectionState copyWith(
      {List<Cast>? casts, Position? selectedRole, String? error}) {
    return ArtistSectionState(
        casts: casts ?? this.casts,
        selectedRole: selectedRole ?? this.selectedRole,
        error: error ?? this.error);
  }

  ArtistSectionState clearError() {
    return ArtistSectionState(
        casts: casts, selectedRole: selectedRole, error: null);
  }
}
