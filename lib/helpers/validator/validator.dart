abstract class Validator<T> {

  //return null when input is valid, otherwise return the error message
  String? validate(T input);

}
