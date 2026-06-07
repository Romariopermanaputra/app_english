class QuestionDataClass4 {
  static const Map<int, String> readingPassages = {
    1: "Pipit is a student in Grade 4. Every morning, she gets up at five-thirty. First, she makes her bed. Then, she takes a shower. After that, she has breakfast with her family. At six o'clock, Pipit goes to school. She loves her morning routine!",
    
    2: "It is lunch time. Bara and his family are having lunch together. They have rice, vegetables, and fried chicken. Bara loves fried chicken! His mother says, 'Eat some fruits too, Bara.' Bara eats sweet mango. After eating, he washes the dishes. Yummy lunch!",
    
    3: "Pipit has many toys at her house. She has a kite, a robot, a plushie, marbles, and a board game. Bara asks, 'May I borrow your kite?' Pipit says, 'Yes, you may.' Mita asks, 'May I borrow your robot?' Pipit says, 'Sure, here it is.' They share toys and play together happily!",
  };

  static const Map<int, List<Map<String, dynamic>>> readingQuestions = {
    1: [
      {
        "q": "What time does Pipit get up?",
        "options": ["5:00", "5:30", "6:00", "6:30"],
        "a": "5:30",
      },
      {
        "q": "What does Pipit do first after getting up?",
        "options": ["Take a shower", "Have breakfast", "Make her bed", "Go to school"],
        "a": "Make her bed",
      },
      {
        "q": "When does Pipit go to school?",
        "options": ["5:30", "6:00", "6:30", "7:00"],
        "a": "6:00",
      },
      {
        "q": "Does Pipit take a shower in the morning?",
        "options": ["Yes", "No", "Maybe", "Unknown"],
        "a": "Yes",
      },
      {
        "q": "What does Pipit have for breakfast?",
        "options": ["Rice", "Sandwich", "Porridge", "The passage doesn't say"],
        "a": "The passage doesn't say",
      },
    ],
    2: [
      {
        "q": "What meal time is it in the story?",
        "options": ["Breakfast", "Lunch", "Dinner", "Snack time"],
        "a": "Lunch",
      },
      {
        "q": "What is Bara's favorite food?",
        "options": ["Rice", "Vegetables", "Fried chicken", "Mango"],
        "a": "Fried chicken",
      },
      {
        "q": "What fruit does Bara eat?",
        "options": ["Apple", "Banana", "Mango", "Orange"],
        "a": "Mango",
      },
      {
        "q": "What does Bara do after eating?",
        "options": ["Play", "Sleep", "Wash the dishes", "Go to school"],
        "a": "Wash the dishes",
      },
      {
        "q": "How does the mango taste?",
        "options": ["Spicy", "Sweet", "Bitter", "Salty"],
        "a": "Sweet",
      },
    ],
    3: [
      {
        "q": "Where do Pipit and her friends play?",
        "options": ["At school", "At the park", "At Pipit's house", "At the library"],
        "a": "At Pipit's house",
      },
      {
        "q": "Which toy does Bara want to borrow?",
        "options": ["Robot", "Kite", "Plushie", "Marbles"],
        "a": "Kite",
      },
      {
        "q": "What does Pipit say when Bara asks to borrow the kite?",
        "options": ["No, you may not", "Sorry", "Yes, you may", "Wait"],
        "a": "Yes, you may",
      },
      {
        "q": "Who asks to borrow the robot?",
        "options": ["Bara", "Pipit", "Mita", "Ferdinand"],
        "a": "Mita",
      },
      {
        "q": "What do the children learn in the story?",
        "options": ["To study", "To share toys", "To cook", "To clean"],
        "a": "To share toys",
      },
    ],
  };

  static const Map<int, List<Map<String, String>>> writingQuestions = {
    1: [
      {"q": "Saya bangun di pagi hari", "a": "i get up in the morning"},
      {"q": "Saya mandi", "a": "i take a shower"},
      {"q": "Saya merapikan tempat tidur", "a": "i make the bed"},
      {"q": "Saya sarapan", "a": "i have breakfast"},
      {"q": "Saya pergi ke sekolah", "a": "i go to school"},
    ],
    2: [
      {"q": "Saya makan bubur untuk sarapan", "a": "i am having porridge for breakfast"},
      {"q": "Apa menu untuk makan siang", "a": "what is for lunch"},
      {"q": "Mie itu pedas", "a": "noodles are spicy"},
      {"q": "Saya suka ikan karena lezat", "a": "i like fish because it is delicious"},
      {"q": "Mangga itu manis", "a": "the mango is sweet"},
    ],
    3: [
      {"q": "Bolehkah saya meminjam layang-layangmu", "a": "may i borrow your kite"},
      {"q": "Ya kamu boleh", "a": "yes you may"},
      {"q": "Robot itu berwarna biru", "a": "the robot is blue"},
      {"q": "Bentuknya adalah persegi", "a": "the shape is a square"},
      {"q": "Mari berbagi dan bermain bersama", "a": "let us share and play together"},
    ],
  };

  static const Map<int, List<Map<String, String>>> speakingQuestions = {
    1: [
      {"q": "What do you do in the morning", "a": "i get up in the morning"},
      {"q": "What time do you get up", "a": "i get up at five thirty"},
      {"q": "Do you take a shower", "a": "yes i take a shower"},
      {"q": "What do you have for breakfast", "a": "i have breakfast"},
      {"q": "When do you go to school", "a": "i go to school at six o clock"},
    ],
    2: [
      {"q": "What are you having for lunch", "a": "i am having rice and vegetables"},
      {"q": "Do you like fried chicken", "a": "yes i like fried chicken"},
      {"q": "Is the noodles spicy", "a": "yes noodles are spicy"},
      {"q": "What fruit do you like", "a": "i like sweet mango"},
      {"q": "Is the food delicious", "a": "yes it is delicious"},
    ],
    3: [
      {"q": "May I borrow your toy", "a": "yes you may"},
      {"q": "What color is your robot", "a": "the robot is blue"},
      {"q": "What shape is the marble", "a": "the shape is a circle"},
      {"q": "Can we play together", "a": "sure let us play together"},
      {"q": "Do you share your toys", "a": "yes i share my toys"},
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
