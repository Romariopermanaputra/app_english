
class QuestionDataClass6 {
  static const Map<int, String> readingPassages = {
    1: "Pipit and Bara are at the vegetable market. Bara reads his mother's shopping list. They buy lettuce, cabbage, corn, cucumbers, and pumpkins. Pipit likes fresh vegetables because they are healthy. 'What is your favorite vegetable?' asks Pipit. 'I like corn and cabbage,' says Bara. They are happy to buy healthy vegetables for their family.",

    2: "Pipit always keeps her body clean. She brushes her teeth every morning and evening. She washes her hands before eating and takes a bath twice a day. Bara also cuts his nails every week. 'Good hygiene habits keep us healthy,' says Emak. Pipit and Bara are happy because they always take care of their bodies.",

    3: "Pipit and Bara go on a trip to the zoo with their classmates. They see elephants, lions, monkeys, and giraffes. 'Look at the tall giraffe!' says Pipit. Bara likes the elephants because they are big and strong. They take pictures and learn about many animals at the zoo. They are very excited and happy.",
  };

  static const Map<int, List<Map<String, dynamic>>> readingQuestions = {
    1: [
      {
        "q": "Where are Pipit and Bara?",
        "options": ["At the zoo", "At the vegetable market", "At school", "At the beach"],
        "a": "At the vegetable market",
      },
      {
        "q": "What vegetables do they buy?",
        "options": ["Apples and oranges", "Lettuce and cabbage", "Fish and meat", "Rice and bread"],
        "a": "Lettuce and cabbage",
      },
      {
        "q": "Why does Pipit like vegetables?",
        "options": ["They are expensive", "They are sweet", "They are healthy", "They are salty"],
        "a": "They are healthy",
      },
      {
        "q": "What is Bara's favorite vegetable?",
        "options": ["Corn and cabbage", "Spinach and carrot", "Potato and tomato", "Onion and garlic"],
        "a": "Corn and cabbage",
      },
      {
        "q": "How do they feel at the end?",
        "options": ["Sad", "Angry", "Happy", "Tired"],
        "a": "Happy",
      },
    ],

    2: [
      {
        "q": "When does Pipit brush her teeth?",
        "options": ["Every morning and evening", "Only at night", "Only in the morning", "Never"],
        "a": "Every morning and evening",
      },
      {
        "q": "What does Pipit do before eating?",
        "options": ["Sleep", "Wash her hands", "Play games", "Read books"],
        "a": "Wash her hands",
      },
      {
        "q": "How many times does Pipit take a bath every day?",
        "options": ["One time", "Two times", "Three times", "Four times"],
        "a": "Two times",
      },
      {
        "q": "What does Bara cut every week?",
        "options": ["His hair", "His clothes", "His nails", "His shoes"],
        "a": "His nails",
      },
      {
        "q": "Why are hygiene habits important?",
        "options": ["They keep us healthy", "They make us sleepy", "They are funny", "They are difficult"],
        "a": "They keep us healthy",
      },
    ],

    3: [
      {
        "q": "Where do Pipit and Bara go?",
        "options": ["To the market", "To the beach", "To the zoo", "To the library"],
        "a": "To the zoo",
      },
      {
        "q": "What animals do they see?",
        "options": ["Cats and dogs", "Elephants and lions", "Fish and chickens", "Snakes and frogs"],
        "a": "Elephants and lions",
      },
      {
        "q": "Which animal is tall?",
        "options": ["Monkey", "Lion", "Elephant", "Giraffe"],
        "a": "Giraffe",
      },
      {
        "q": "Why does Bara like elephants?",
        "options": ["They are small", "They are colorful", "They are big and strong", "They are fast"],
        "a": "They are big and strong",
      },
      {
        "q": "How do they feel during the trip?",
        "options": ["Excited and happy", "Sad and tired", "Hungry and angry", "Scared and quiet"],
        "a": "Excited and happy",
      },
    ],
  };

  static const Map<int, List<Map<String, String>>> writingQuestions = {
    1: [
      {"q": "Saya suka sayuran sehat", "a": "i like healthy vegetables"},
      {"q": "Jagung adalah sayuran favoritku", "a": "corn is my favorite vegetable"},
      {"q": "Kita membeli selada dan kubis", "a": "we buy lettuce and cabbage"},
      {"q": "Sayuran itu segar", "a": "the vegetables are fresh"},
      {"q": "Labu itu besar dan oranye", "a": "pumpkins are big and orange"},
    ],

    2: [
      {"q": "Saya menyikat gigi setiap hari", "a": "i brush my teeth every day"},
      {"q": "Cuci tanganmu sebelum makan", "a": "wash your hands before eating"},
      {"q": "Saya mandi dua kali sehari", "a": "i take a bath twice a day"},
      {"q": "Kebersihan yang baik membuat kita sehat", "a": "good hygiene keeps us healthy"},
      {"q": "Bara memotong kukunya setiap minggu", "a": "bara cuts his nails every week"},
    ],

    3: [
      {"q": "Kita pergi ke kebun binatang hari ini", "a": "we go to the zoo today"},
      {"q": "Jerapah itu sangat tinggi", "a": "the giraffe is very tall"},
      {"q": "Gajah itu besar dan kuat", "a": "elephants are big and strong"},
      {"q": "Saya suka monyet di kebun binatang", "a": "i like monkeys at the zoo"},
      {"q": "Perjalanan ke kebun binatang itu menyenangkan", "a": "the zoo trip is exciting"},
    ],
  };

  static const Map<int, List<Map<String, String>>> speakingQuestions = {
    1: [
      {"q": "What is your favorite vegetable", "a": "my favorite vegetable is corn"},
      {"q": "Do you like healthy vegetables", "a": "yes i like healthy vegetables"},
      {"q": "What vegetables do you buy", "a": "i buy lettuce and cabbage"},
      {"q": "Are the vegetables fresh", "a": "yes the vegetables are fresh"},
      {"q": "Do you like corn", "a": "yes i like corn"},
    ],

    2: [
      {"q": "When do you brush your teeth", "a": "i brush my teeth every morning and evening"},
      {"q": "Do you wash your hands before eating", "a": "yes i wash my hands before eating"},
      {"q": "How many times do you take a bath", "a": "i take a bath twice a day"},
      {"q": "Why is hygiene important", "a": "because it keeps us healthy"},
      {"q": "Do you cut your nails every week", "a": "yes i cut my nails every week"},
    ],

    3: [
      {"q": "Where do you go on the trip", "a": "i go to the zoo"},
      {"q": "What animals do you like", "a": "i like elephants and giraffes"},
      {"q": "Is the giraffe tall", "a": "yes the giraffe is very tall"},
      {"q": "Why do you like elephants", "a": "because they are big and strong"},
      {"q": "Is the zoo trip fun", "a": "yes the zoo trip is very fun"},
    ],
  };


  static List<Map<String, dynamic>> reading(int chapter) {
    return readingQuestions[chapter] ?? readingQuestions[1]!;
  }

  static String readingText(int chapter) {
    return readingPassages[chapter] ?? readingPassages[1]!;
  }

  static List<Map<String, String>> writing(int chapter) {
    return writingQuestions[chapter] ?? writingQuestions[1]!;
  }

  static List<Map<String, String>> speaking(int chapter) {
    return speakingQuestions[chapter] ?? speakingQuestions[1]!;
  }
}
