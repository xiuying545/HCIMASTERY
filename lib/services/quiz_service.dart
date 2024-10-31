import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/quiz.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addQuiz(Quiz quiz) async {
    DocumentReference docRef = await _db.collection('Quiz').add(quiz.toJson());
    print('Quiz added with ID: ${docRef.id}'); // Log the ID of the added quiz
  }

Future<List<Quiz>> getQuizzesByChapter(int chapter) async {
  try {
    
    QuerySnapshot querySnapshot = await _db
        .collection('Quiz')
        .where("chapter", isEqualTo: chapter)
        .get();

    List<Quiz> quizList = querySnapshot.docs.map((doc) {
      var quizData = Quiz.fromJson(doc.data() as Map<String, dynamic>);
      
      // Assign the document ID to the quizzID field
      quizData.quizzID = doc.id;
      
      return quizData;
    }).toList();

    print('Fetched quizzes: ${quizList.length}');
    return quizList;
  } catch (e) {
    print('Error fetching quizzes: $e');
    return [];
  }
}

  Future<Quiz> getQuizzById(String quizId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection('Quiz').doc(quizId).get();

      print('Fetched quiz with ID: $quizId');
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return Quiz.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Quiz not found or data is null.');
        // Return a default Quiz object if not found
        return Quiz(
          quizzID: quizId,
          chapter: 0,
          question: 'Default Question',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          answer: 0,
        );
      }
    } catch (e) {
      print('Error fetching quiz: $e');
      // Return a default Quiz object in case of an error
      return Quiz(
        quizzID: quizId,
        chapter: 0,
        question: 'Error fetching quiz',
        options: [],
        answer: 0,
      );
    }
  }

  Future<void> predefinedQuizzes() async {
    List<Quiz> predefinedQuizList = [
      // Chapter 1 Questions
    Quiz(
  chapter: 1,
  question: 'What is the main purpose of a user interface?',
  options: [
    'To perform calculations',
    'To manage system resources',
    'To facilitate user interaction with the system',
    'To store data'
  ],
  answer: 2, // To facilitate user interaction is at index 2
),
Quiz(
  chapter: 1,
  question: 'Which of the following is an example of a command line interface?',
  options: [
    'Microsoft Word',
    'Terminal',
    'Adobe Photoshop',
    'Web Browser'
  ],
  answer: 1, // Terminal is at index 1
),
Quiz(
  chapter: 1,
  question: 'What does “feedback” refer to in HCI?',
  options: [
    'User responses to the system',
    'System responses to user actions',
    'Design suggestions from users',
    'User testing results'
  ],
  answer: 1, // System responses to user actions is at index 1
),
Quiz(
  chapter: 1,
  question: 'Which principle emphasizes designing for users with diverse abilities?',
  options: [
    'Usability',
    'Accessibility',
    'User experience',
    'Human factors'
  ],
  answer: 1, // Accessibility is at index 1
),
Quiz(
  chapter: 1,
  question: 'What is a wireframe in UI design?',
  options: [
    'A detailed visual representation of the user interface',
    'A low-fidelity blueprint of the user interface',
    'The final design of the application',
    'A prototype used for user testing'
  ],
  answer: 1, // A low-fidelity blueprint is at index 1
),
Quiz(
  chapter: 1,
  question: 'Which type of testing involves observing real users interacting with a product?',
  options: [
    'Unit testing',
    'Integration testing',
    'Usability testing',
    'System testing'
  ],
  answer: 2, // Usability testing is at index 2
),
Quiz(
  chapter: 1,
  question: 'What does the term “cognitive load” refer to?',
  options: [
    'The amount of information a user can process at one time',
    'The physical effort required to interact with a system',
    'The mental effort required to learn a new interface',
    'The time it takes to complete a task'
  ],
  answer: 0, // The amount of information is at index 0
),
Quiz(
  chapter: 1,
  question: 'What is the significance of a “mental model” in HCI?',
  options: [
    'It represents how users perceive and interact with a system',
    'It is the physical design of a system',
    'It is a model of the system architecture',
    'It is the documentation for a software application'
  ],
  answer: 0, // It represents how users perceive is at index 0
),
Quiz(
  chapter: 1,
  question: 'Which design principle involves making important functions easily accessible?',
  options: [
    'Hierarchy',
    'Visibility',
    'Affordance',
    'Consistency'
  ],
  answer: 1, // Visibility is at index 1
),
Quiz(
  chapter: 1,
  question: 'What is a common method for improving user experience in HCI?',
  options: [
    'Increasing system complexity',
    'Reducing user feedback',
    'Simplifying navigation',
    'Limiting user choices'
  ],
  answer: 2, // Simplifying navigation is at index 2
),

    ];

    for (Quiz quiz in predefinedQuizList) {
      await addQuiz(quiz);
    }
  }
}
