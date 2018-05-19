class AionUtility{
  static bool isValidAddress(address){
    RegExp regExp = new RegExp(
      r"^0xa[a-f\d]{63}$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(address);
  }
}