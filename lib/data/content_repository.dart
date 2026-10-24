import 'package:lingo_learn/models/language.dart';
import 'package:lingo_learn/models/lesson.dart';

class ContentRepository {
  ContentRepository._();

  static const List<AppLanguage> languages = [
    AppLanguage(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
      ttsLocale: 'es-ES',
    ),
    AppLanguage(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
      ttsLocale: 'fr-FR',
    ),
    AppLanguage(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
      ttsLocale: 'de-DE',
    ),
  ];

  static AppLanguage languageByCode(String code) {
    return languages.firstWhere(
      (l) => l.code == code,
      orElse: () => languages.first,
    );
  }

  static List<Lesson> lessonsFor(String languageCode) =>
      _lessons.where((l) => l.languageCode == languageCode).toList();

  static List<Lesson> lessonsByCategory(
    String languageCode,
    LessonCategory category,
  ) =>
      lessonsFor(languageCode).where((l) => l.category == category).toList();

  static List<StudyItem> allItems(String languageCode) =>
      lessonsFor(languageCode).expand((l) => l.items).toList();

  /// Same lesson all day, changes every day.
  static Lesson dailyLesson(String languageCode, DateTime date) {
    final lessons = lessonsFor(languageCode);
    final dayOfYear = date.difference(DateTime(date.year)).inDays;
    return lessons[dayOfYear % lessons.length];
  }

  static const List<Lesson> _lessons = [
    // ───────────── SPANISH ─────────────
    Lesson(
      id: 'es_vocab_basics',
      languageCode: 'es',
      category: LessonCategory.vocabulary,
      title: 'Greetings & Basics',
      subtitle: 'Say hello like a local',
      items: [
        StudyItem('Hola', 'Hello', 'OH-lah', 'Hola, ¿qué tal?',
            "Hello, how's it going?"),
        StudyItem('Adiós', 'Goodbye', 'ah-DYOHS', 'Adiós, hasta mañana.',
            'Goodbye, see you tomorrow.'),
        StudyItem('Gracias', 'Thank you', 'GRAH-syahs',
            'Muchas gracias por tu ayuda.', 'Thank you very much for your help.'),
        StudyItem('Por favor', 'Please', 'por fah-VOR',
            'Un café, por favor.', 'A coffee, please.'),
        StudyItem('Buenos días', 'Good morning', 'BWEH-nohs DEE-ahs',
            'Buenos días, señora.', 'Good morning, madam.'),
      ],
    ),
    Lesson(
      id: 'es_vocab_food',
      languageCode: 'es',
      category: LessonCategory.vocabulary,
      title: 'Food & Drink',
      subtitle: 'Order at any café',
      items: [
        StudyItem('Agua', 'Water', 'AH-gwah', 'Quiero un vaso de agua.',
            'I want a glass of water.'),
        StudyItem('Pan', 'Bread', 'pahn', 'El pan está fresco.',
            'The bread is fresh.'),
        StudyItem('Manzana', 'Apple', 'mahn-SAH-nah',
            'Como una manzana cada día.', 'I eat an apple every day.'),
        StudyItem('Café', 'Coffee', 'kah-FEH', 'Me gusta el café con leche.',
            'I like coffee with milk.'),
        StudyItem('Leche', 'Milk', 'LEH-cheh', 'La leche está fría.',
            'The milk is cold.'),
      ],
    ),
    Lesson(
      id: 'es_phrases_daily',
      languageCode: 'es',
      category: LessonCategory.phrases,
      title: 'Daily Phrases',
      subtitle: 'Survive any conversation',
      items: [
        StudyItem('¿Cómo estás?', 'How are you?', 'KOH-moh ehs-TAHS',
            'Hola María, ¿cómo estás?', 'Hi María, how are you?'),
        StudyItem('Me llamo Ana', 'My name is Ana', 'meh YAH-moh AH-nah',
            'Hola, me llamo Ana.', 'Hi, my name is Ana.'),
        StudyItem('¿Dónde está el baño?', 'Where is the bathroom?',
            'DOHN-deh ehs-TAH ehl BAH-nyoh', 'Perdón, ¿dónde está el baño?',
            'Excuse me, where is the bathroom?'),
        StudyItem('No entiendo', "I don't understand", 'noh ehn-TYEHN-doh',
            'Lo siento, no entiendo.', "Sorry, I don't understand."),
        StudyItem('¿Cuánto cuesta?', 'How much does it cost?',
            'KWAHN-toh KWEHS-tah', '¿Cuánto cuesta este libro?',
            'How much does this book cost?'),
      ],
    ),
    Lesson(
      id: 'es_grammar_ser',
      languageCode: 'es',
      category: LessonCategory.grammar,
      title: 'The Verb "Ser"',
      subtitle: 'To be: identity & origin',
      items: [
        StudyItem('Yo soy', 'I am', 'yoh soy', 'Yo soy estudiante.',
            'I am a student.'),
        StudyItem('Tú eres', 'You are', 'too EH-rehs', 'Tú eres muy amable.',
            'You are very kind.'),
        StudyItem('Él es', 'He is', 'ehl ehs', 'Él es mi hermano.',
            'He is my brother.'),
        StudyItem('Nosotros somos', 'We are', 'noh-SOH-trohs SOH-mohs',
            'Nosotros somos amigos.', 'We are friends.'),
        StudyItem('Ellos son', 'They are', 'EH-yohs sohn',
            'Ellos son de México.', 'They are from Mexico.'),
      ],
    ),

    // ───────────── FRENCH ─────────────
    Lesson(
      id: 'fr_vocab_basics',
      languageCode: 'fr',
      category: LessonCategory.vocabulary,
      title: 'Greetings & Basics',
      subtitle: 'Say hello like a local',
      items: [
        StudyItem('Bonjour', 'Hello', 'bohn-ZHOOR', 'Bonjour, madame.',
            'Hello, madam.'),
        StudyItem('Au revoir', 'Goodbye', 'oh ruh-VWAHR',
            'Au revoir, à demain !', 'Goodbye, see you tomorrow!'),
        StudyItem('Merci', 'Thank you', 'mehr-SEE', 'Merci beaucoup.',
            'Thank you very much.'),
        StudyItem("S'il vous plaît", 'Please', 'seel voo PLEH',
            "Un thé, s'il vous plaît.", 'A tea, please.'),
        StudyItem('Bonsoir', 'Good evening', 'bohn-SWAHR',
            'Bonsoir, comment allez-vous ?', 'Good evening, how are you?'),
      ],
    ),
    Lesson(
      id: 'fr_vocab_food',
      languageCode: 'fr',
      category: LessonCategory.vocabulary,
      title: 'Food & Drink',
      subtitle: 'Order at any café',
      items: [
        StudyItem('Eau', 'Water', 'oh', "Je voudrais de l'eau.",
            'I would like some water.'),
        StudyItem('Pain', 'Bread', 'pan', 'Le pain est chaud.',
            'The bread is warm.'),
        StudyItem('Pomme', 'Apple', 'pum', 'Elle mange une pomme.',
            'She eats an apple.'),
        StudyItem('Café', 'Coffee', 'ka-FAY', 'Je bois un café le matin.',
            'I drink a coffee in the morning.'),
        StudyItem('Lait', 'Milk', 'leh', 'Le lait est sur la table.',
            'The milk is on the table.'),
      ],
    ),
    Lesson(
      id: 'fr_phrases_daily',
      languageCode: 'fr',
      category: LessonCategory.phrases,
      title: 'Daily Phrases',
      subtitle: 'Survive any conversation',
      items: [
        StudyItem('Comment ça va ?', 'How are you?', 'koh-mahn sa VA',
            'Salut Paul, comment ça va ?', 'Hi Paul, how are you?'),
        StudyItem("Je m'appelle Marie", 'My name is Marie',
            'zhuh ma-PEL ma-REE', "Bonjour, je m'appelle Marie.",
            'Hello, my name is Marie.'),
        StudyItem('Où sont les toilettes ?', 'Where is the bathroom?',
            'oo sohn lay twa-LET', 'Excusez-moi, où sont les toilettes ?',
            'Excuse me, where is the bathroom?'),
        StudyItem('Je ne comprends pas', "I don't understand",
            'zhuh nuh kohm-PRAHN pah', 'Désolé, je ne comprends pas.',
            "Sorry, I don't understand."),
        StudyItem('Combien ça coûte ?', 'How much does it cost?',
            'kohm-byan sa KOOT', 'Combien ça coûte, ce livre ?',
            'How much does this book cost?'),
      ],
    ),
    Lesson(
      id: 'fr_grammar_etre',
      languageCode: 'fr',
      category: LessonCategory.grammar,
      title: 'The Verb "Être"',
      subtitle: 'To be: identity & origin',
      items: [
        StudyItem('Je suis', 'I am', 'zhuh SWEE', 'Je suis étudiant.',
            'I am a student.'),
        StudyItem('Tu es', 'You are', 'too EH', 'Tu es très gentil.',
            'You are very kind.'),
        StudyItem('Il est', 'He is', 'eel EH', 'Il est mon frère.',
            'He is my brother.'),
        StudyItem('Nous sommes', 'We are', 'noo SUM', 'Nous sommes amis.',
            'We are friends.'),
        StudyItem('Ils sont', 'They are', 'eel SOHN', 'Ils sont de Paris.',
            'They are from Paris.'),
      ],
    ),

    // ───────────── GERMAN ─────────────
    Lesson(
      id: 'de_vocab_basics',
      languageCode: 'de',
      category: LessonCategory.vocabulary,
      title: 'Greetings & Basics',
      subtitle: 'Say hello like a local',
      items: [
        StudyItem('Hallo', 'Hello', 'HAH-loh', "Hallo, wie geht's?",
            'Hello, how are you?'),
        StudyItem('Auf Wiedersehen', 'Goodbye', 'owf VEE-der-zayn',
            'Auf Wiedersehen, bis morgen!', 'Goodbye, see you tomorrow!'),
        StudyItem('Danke', 'Thank you', 'DAHN-kuh', 'Danke für deine Hilfe.',
            'Thanks for your help.'),
        StudyItem('Bitte', 'Please', 'BIT-tuh', 'Einen Kaffee, bitte.',
            'A coffee, please.'),
        StudyItem('Guten Morgen', 'Good morning', 'GOO-ten MOR-gen',
            'Guten Morgen, Frau Weber.', 'Good morning, Mrs. Weber.'),
      ],
    ),
    Lesson(
      id: 'de_vocab_food',
      languageCode: 'de',
      category: LessonCategory.vocabulary,
      title: 'Food & Drink',
      subtitle: 'Order at any café',
      items: [
        StudyItem('Wasser', 'Water', 'VAH-ser', 'Ich möchte ein Glas Wasser.',
            'I would like a glass of water.'),
        StudyItem('Brot', 'Bread', 'broht', 'Das Brot ist frisch.',
            'The bread is fresh.'),
        StudyItem('Apfel', 'Apple', 'AHP-fel', 'Ich esse einen Apfel.',
            'I am eating an apple.'),
        StudyItem('Kaffee', 'Coffee', 'KAH-fay', 'Ich trinke gern Kaffee.',
            'I like drinking coffee.'),
        StudyItem('Milch', 'Milk', 'milkh', 'Die Milch ist kalt.',
            'The milk is cold.'),
      ],
    ),
    Lesson(
      id: 'de_phrases_daily',
      languageCode: 'de',
      category: LessonCategory.phrases,
      title: 'Daily Phrases',
      subtitle: 'Survive any conversation',
      items: [
        StudyItem("Wie geht's?", 'How are you?', 'vee gayts',
            "Hallo Tom, wie geht's?", 'Hi Tom, how are you?'),
        StudyItem('Ich heiße Anna', 'My name is Anna', 'ikh HY-suh AH-nah',
            'Hallo, ich heiße Anna.', 'Hello, my name is Anna.'),
        StudyItem('Wo ist die Toilette?', 'Where is the bathroom?',
            'voh ist dee toy-LET-uh', 'Entschuldigung, wo ist die Toilette?',
            'Excuse me, where is the bathroom?'),
        StudyItem('Ich verstehe nicht', "I don't understand",
            'ikh fer-SHTAY-uh nikht', 'Entschuldigung, ich verstehe nicht.',
            "Sorry, I don't understand."),
        StudyItem('Wie viel kostet das?', 'How much does it cost?',
            'vee feel KOS-tet dahs', 'Wie viel kostet das Buch?',
            'How much does the book cost?'),
      ],
    ),
    Lesson(
      id: 'de_grammar_sein',
      languageCode: 'de',
      category: LessonCategory.grammar,
      title: 'The Verb "Sein"',
      subtitle: 'To be: identity & origin',
      items: [
        StudyItem('Ich bin', 'I am', 'ikh bin', 'Ich bin Student.',
            'I am a student.'),
        StudyItem('Du bist', 'You are', 'doo bist', 'Du bist sehr nett.',
            'You are very nice.'),
        StudyItem('Er ist', 'He is', 'air ist', 'Er ist mein Bruder.',
            'He is my brother.'),
        StudyItem('Wir sind', 'We are', 'veer zint', 'Wir sind Freunde.',
            'We are friends.'),
        StudyItem('Sie sind', 'They are', 'zee zint', 'Sie sind aus Berlin.',
            'They are from Berlin.'),
      ],
    ),
  ];
}