class Language {
  final int id;
  final String name;
  final String languageCode;

  Language(this.id, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[

      Language(1, "English", "en"),
      Language(2, "हिंदी", "hi"),
      Language(3, "मराठी", "mr"),
      Language(4, "गुजराती", "gu"),
      Language(5, "तमिळ", "ta"),
    ];
  }
}
