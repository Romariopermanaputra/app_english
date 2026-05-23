
class QuestionDataClass5 {
    static const Map<int, String> readingPassages = {
    1: "Pipit and Bara go to the fruit market. 'How many kilos of mangoes do you want to buy?' asks Pipit. 'I want to buy two kilos of mangoes,' says Bara. 'I don't want to buy a pineapple.' They also buy spinach. 'How much is the broccoli?' asks Bara. 'It is eighteen thousand rupiah,' says the seller. Pipit wants to buy one bunch of spinach. They are happy with their groceries!",
    
    2: "It is time to cook! Emak is in the kitchen. 'Can you get me a plate, please?' asks Emak. 'Yes, Emak,' says Pipit. 'Can you put the plate here, please?' Emak says. Pipit helps in the kitchen. 'Spread the margarine,' says Emak. 'Heat the cooking oil. Toast the bread.' Pipit helps to make a special sandwich. 'Cut the sandwich in half,' says Emak. Pipit is happy to help!",
    
    3: "Ferdinand wants to visit Bara's house. 'How do you get to school?' asks Mita. 'Go straight on Garuda Street. Turn right on Merpati Street,' says Pipit. 'Where is your house, Bara?' asks Ferdinand. 'My house is beside the school. It is in front of the beach,' says Bara. Ferdinand goes straight, turns left, and finds Bara's house. They play together happily!",
  };

  static const Map<int, List<Map<String, dynamic>>> readingQuestions = {
    1: [
      {
        "q": "Where do Pipit and Bara go?",
        "options": ["The library", "The fruit market", "The school", "The park"],
        "a": "The fruit market",
      },
      {
        "q": "How many kilos of mangoes does Bara want to buy?",
        "options": ["One kilo", "Two kilos", "Three kilos", "Four kilos"],
        "a": "Two kilos",
      },
      {
        "q": "Does Bara want to buy a pineapple?",
        "options": ["Yes", "No", "Maybe", "Unknown"],
        "a": "No",
      },
      {
        "q": "How much is the broccoli?",
        "options": ["Ten thousand rupiah", "Fifteen thousand rupiah", "Eighteen thousand rupiah", "Twenty thousand rupiah"],
        "a": "Eighteen thousand rupiah",
      },
      {
        "q": "What does Pipit want to buy?",
        "options": ["Two bunches of spinach", "One bunch of spinach", "Three bunches of spinach", "No spinach"],
        "a": "One bunch of spinach",
      },
    ],
    2: [
      {
        "q": "Where is Emak?",
        "options": ["In the garden", "In the kitchen", "In the market", "In the bedroom"],
        "a": "In the kitchen",
      },
      {
        "q": "What does Emak ask Pipit to get?",
        "options": ["A bowl", "A plate", "A spoon", "A cup"],
        "a": "A plate",
      },
      {
        "q": "What does Pipit help to make?",
        "options": ["A cake", "A special sandwich", "Soup", "Rice"],
        "a": "A special sandwich",
      },
      {
        "q": "What does Emak say to do with the margarine?",
        "options": ["Cut it", "Spread it", "Eat it", "Throw it"],
        "a": "Spread it",
      },
      {
        "q": "What does Pipit do at the end?",
        "options": ["She is sad", "She is happy to help", "She is tired", "She is hungry"],
        "a": "She is happy to help",
      },
    ],
    3: [
      {
        "q": "Who wants to visit Bara's house?",
        "options": ["Pipit", "Mita", "Ferdinand", "Putra"],
        "a": "Ferdinand",
      },
      {
        "q": "What street does Ferdinand go straight on?",
        "options": ["Merpati Street", "Garuda Street", "Elang Street", "Dadali Street"],
        "a": "Garuda Street",
      },
      {
        "q": "Where does Ferdinand turn right?",
        "options": ["Garuda Street", "Merpati Street", "Beach Street", "Market Street"],
        "a": "Merpati Street",
      },
      {
        "q": "Where is Bara's house?",
        "options": ["Behind the market", "Beside the school, in front of the beach", "Next to the mosque", "Between the church and grocery store"],
        "a": "Beside the school, in front of the beach",
      },
      {
        "q": "What do Ferdinand and Bara do at the end?",
        "options": ["They study", "They play together happily", "They cook", "They go to the market"],
        "a": "They play together happily",
      },
    ],
  };

  static const Map<int, List<Map<String, String>>> writingQuestions = {
    1: [
      {"q": "I want to buy two kilos of mangoes", "a": "i want to buy two kilos of mangoes"},
      {"q": "How much is the broccoli", "a": "how much is the broccoli"},
      {"q": "I want to buy one bunch of spinach", "a": "i want to buy one bunch of spinach"},
      {"q": "The mangoes are fresh", "a": "the mangoes are fresh"},
      {"q": "We go to the fruit market", "a": "we go to the fruit market"},
    ],
    2: [
      {"q": "Can you get me a plate please", "a": "can you get me a plate please"},
      {"q": "Spread the margarine", "a": "spread the margarine"},
      {"q": "Heat the cooking oil", "a": "heat the cooking oil"},
      {"q": "Toast the bread", "a": "toast the bread"},
      {"q": "Cut the sandwich in half", "a": "cut the sandwich in half"},
    ],
    3: [
      {"q": "Go straight on Garuda Street", "a": "go straight on garuda street"},
      {"q": "Turn right on Merpati Street", "a": "turn right on merpati street"},
      {"q": "My house is beside the school", "a": "my house is beside the school"},
      {"q": "Turn left at the end of the street", "a": "turn left at the end of the street"},
      {"q": "We play together happily", "a": "we play together happily"},
    ],
  };

  static const Map<int, List<Map<String, String>>> speakingQuestions = {
    1: [
      {"q": "How many kilos of mangoes do you want to buy", "a": "i want to buy two kilos of mangoes"},
      {"q": "How much is the broccoli", "a": "it is eighteen thousand rupiah"},
      {"q": "Do you want to buy a pineapple", "a": "no i don't want to buy a pineapple"},
      {"q": "What do you want to buy at the market", "a": "i want to buy spinach"},
      {"q": "Are the mangoes fresh", "a": "yes the mangoes are fresh"},
    ],
    2: [
      {"q": "Can you get me a plate please", "a": "yes i can get you a plate"},
      {"q": "What do you do with the margarine", "a": "i spread the margarine"},
      {"q": "How do you make the sandwich", "a": "i toast the bread and cut it in half"},
      {"q": "Do you help in the kitchen", "a": "yes i help in the kitchen"},
      {"q": "Is the sandwich delicious", "a": "yes the sandwich is delicious"},
    ],
    3: [
      {"q": "How do you get to Bara's house", "a": "go straight on Garuda Street then turn right"},
      {"q": "Where is your house", "a": "my house is beside the school"},
      {"q": "Do you turn left or right", "a": "i turn right on Merpati Street"},
      {"q": "Is the beach near Bara's house", "a": "yes it is in front of the beach"},
      {"q": "Do you play with your friends", "a": "yes we play together happily"},
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
