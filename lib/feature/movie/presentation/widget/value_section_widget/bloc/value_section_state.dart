part of 'value_section_cubit.dart';

enum MediaValue {
  free(persianTitle: "رایگان", serverNameSpace: "Free"),
  advertising(persianTitle: "تبلیغاتی", serverNameSpace: "Advertising"),
  subscription(persianTitle: "اشتراکی", serverNameSpace: "Subscription");

  final String persianTitle;
  final String serverNameSpace;

  const MediaValue({required this.persianTitle, required this.serverNameSpace});
}

class ValueSectionState {
  final MediaValue? selectedValue;
  final String? error;

  ValueSectionState({required this.selectedValue, required this.error});

  ValueSectionState copyWith({MediaValue? selectedValue, String? error}) {
    return ValueSectionState(
        selectedValue: selectedValue ?? this.selectedValue,
        error: error ?? this.error);
  }

  ValueSectionState clearError() {
    return ValueSectionState(
        selectedValue: selectedValue,
        error: null);
  }
}
