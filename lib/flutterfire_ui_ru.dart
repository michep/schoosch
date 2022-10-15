import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/i10n.dart';

class FlutterFireUIRuLocalizationsDelegate
    extends LocalizationsDelegate<FlutterFireUILocalizations> {
  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'ru';
  }

  @override
  Future<FlutterFireUILocalizations<FlutterFireUILocalizationLabels>> load(
    Locale locale,
  ) {
    final flutterFireUILocalizations =
        FlutterFireUILocalizations(locale, RuLocalizations());
    return SynchronousFuture<FlutterFireUILocalizations>(
      flutterFireUILocalizations,
    );
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<
            FlutterFireUILocalizations<FlutterFireUILocalizationLabels>>
        old,
  ) {
    return false;
  }
}

class RuLocalizations extends FlutterFireUILocalizationLabels {
  @override
  String get emailInputLabel => 'Электронная почта';

  @override
  String get passwordInputLabel => 'Пароль';

  @override
  String get signInActionText => 'Войти';

  @override
  String get registerActionText => 'Регистрация';

  @override
  String get linkEmailButtonText => 'Далее';

  @override
  String get signInButtonText => 'Войти';

  @override
  String get registerButtonText => 'Зарегистрироваться';

  @override
  String get signInWithPhoneButtonText => 'Войти с помощью телефона';

  @override
  String get signInWithGoogleButtonText => 'Войти через Google';

  @override
  String get signInWithAppleButtonText => 'Войти через Apple';

  @override
  String get signInWithFacebookButtonText => 'Войти через Facebook';

  @override
  String get signInWithTwitterButtonText => 'Войти через Twitter';

  @override
  String get phoneVerificationViewTitleText => 'Введите свой номер телефона';

  @override
  String get verifyPhoneNumberButtonText => 'Далее';

  @override
  String get verifyCodeButtonText => 'Подтвердить';

  @override
  String get verifyingPhoneNumberViewTitle => 'Введите код из SMS';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get smsAutoresolutionFailedError =>
      'Не удалось автоматически определить код SMS. Пожалуйста, введите код вручную';

  @override
  String get smsCodeSentText => 'SMS-код отправлен';

  @override
  String get sendingSMSCodeText => 'Отправка кода SMS...';

  @override
  String get verifyingSMSCodeText => 'Проверка кода SMS...';

  @override
  String get enterSMSCodeText => 'Введите SMS-код';

  @override
  String get emailIsRequiredErrorText => 'Требуется электронная почта';

  @override
  String get isNotAValidEmailErrorText =>
      'Укажите действительный адрес электронной почты';

  @override
  String get userNotFoundErrorText => 'Учетная запись не существует';

  @override
  String get emailTakenErrorText =>
      'Учетная запись с таким адресом электронной почты уже существует';

  @override
  String get accessDisabledErrorText =>
      'Доступ к этому аккаунту временно отключен';

  @override
  String get wrongOrNoPasswordErrorText =>
      'Пароль недействителен или у пользователя нет пароля';

  @override
  String get signInText => 'Войти';

  @override
  String get registerText => 'Регистрация';

  @override
  String get registerHintText => 'У вас нет учетной записи?';

  @override
  String get signInHintText => 'У вас уже есть учетная запись?';

  @override
  String get signOutButtonText => 'Выйти';

  @override
  String get phoneInputLabel => 'Номер телефона';

  @override
  String get phoneNumberIsRequiredErrorText => 'Требуется номер телефона';

  @override
  String get phoneNumberInvalidErrorText => 'Номер телефона недействителен';

  @override
  String get profile => 'Профиль';

  @override
  String get name => 'Имя';

  @override
  String get deleteAccount => 'Удалить учетную запись';

  @override
  String get passwordIsRequiredErrorText => 'Требуется пароль';

  @override
  String get confirmPasswordIsRequiredErrorText => 'Подтвердите свой пароль';

  @override
  String get confirmPasswordDoesNotMatchErrorText => 'Пароли не совпадают';

  @override
  String get confirmPasswordInputLabel => 'Подтвердите пароль';

  @override
  String get forgotPasswordButtonLabel => 'Забыли пароль?';

  @override
  String get forgotPasswordViewTitle => 'Забыли пароль';

  @override
  String get resetPasswordButtonLabel => 'Сбросить пароль';

  @override
  String get verifyItsYouText => 'Подтвердите, что это вы';

  @override
  String get differentMethodsSignInTitleText =>
      'Используйте один из следующих способов для входа';

  @override
  String get findProviderForEmailTitleText =>
      'Введите адрес электронной почты, чтобы продолжить';

  @override
  String get continueText => 'Продолжить';

  @override
  String get countryCode => 'Код';

  @override
  String get codeRequiredErrorText => 'Требуется код страны';

  @override
  String get invalidCountryCode => 'Неверный код';

  @override
  String get chooseACountry => 'Выберите страну';

  @override
  String get enableMoreSignInMethods => 'Включить дополнительные методы входа';

  @override
  String get signInMethods => 'Методы входа';

  @override
  String get provideEmail => 'Укажите свой адрес электронной почты и пароль';

  @override
  String get goBackButtonLabel => 'Назад';

  @override
  String get passwordResetEmailSentText =>
      'Мы отправили вам электронное письмо со ссылкой для сброса пароля. Пожалуйста, проверьте свою электронную почту.';

  @override
  String get forgotPasswordHintText =>
      'Укажите свой адрес электронной почты, и мы вышлем вам ссылку для сброса пароля';

  @override
  String get emailLinkSignInButtonLabel => 'Войти по ссылке';

  @override
  String get signInWithEmailLinkViewTitleText => 'Войти по ссылке';

  @override
  String get signInWithEmailLinkSentText =>
      'Мы отправили вам электронное письмо с ссылкой. Проверьте свою электронную почту и перейдите по ссылке, чтобы войти';

  @override
  String get sendLinkButtonLabel => 'Отправить ссылку';

  @override
  String get arrayLabel => 'array';

  @override
  String get booleanLabel => 'boolean';

  @override
  String get mapLabel => 'map';

  @override
  String get nullLabel => 'null';

  @override
  String get numberLabel => 'number';

  @override
  String get stringLabel => 'string';

  @override
  String get typeLabel => 'type';

  @override
  String get valueLabel => 'value';

  @override
  String get cancelLabel => 'отмена';

  @override
  String get updateLabel => 'обновление';

  @override
  String get northInitialLabel => 'N';

  @override
  String get southInitialLabel => 'S';

  @override
  String get westInitialLabel => 'W';

  @override
  String get eastInitialLabel => 'E';

  @override
  String get timestampLabel => 'timestamp';

  @override
  String get latitudeLabel => 'longitude';

  @override
  String get longitudeLabel => 'latitude';

  @override
  String get geopointLabel => 'geopoint';

  @override
  String get referenceLabel => 'reference';
}
