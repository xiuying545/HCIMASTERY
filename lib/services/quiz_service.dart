import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/quiz.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addQuiz(Quiz quiz) async {
    DocumentReference docRef = await _db.collection('Quiz').add(quiz.toJson());
    print('Quiz added with ID: ${docRef.id}'); // Log the ID of the added quiz
  }

  Future<List<Quiz>> getQuizzesByChapter(int chapter) async {
    // predefinedQuizzes();
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Quiz')
          .where("chapter", isEqualTo: chapter)
          .get();

      List<Quiz> quizList = querySnapshot.docs.map((doc) {

        var quizData = Quiz.fromJson(doc.data() as Map<String, dynamic>);
        
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
          answer: 'A',
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
        answer: '',
      );
    }
  }

  Future<void> predefinedQuizzes() async {
    List<Quiz> predefinedQuizList = [
      // Chapter 1 Questions
      Quiz(
        chapter: 1,
        question: 'What does HCI stand for?',
        options: [
          'Human-Computer Interaction',
          'Human-Centric Interface',
          'Human-Computer Interface',
          'Human Communication Interaction'
        ],
        answer: 'Human-Computer Interaction',
      ),
      Quiz(
        chapter: 1,
        question: 'Which of the following is NOT an input device?',
        options: ['Keyboard', 'Mouse', 'Monitor', 'Touchscreen'],
        answer: 'Monitor',
      ),
      Quiz(
        chapter: 1,
        question: 'What is a key goal of HCI?',
        options: [
          'Improve user experience',
          'Increase production speed',
          'Reduce costs',
          'Maximize functionality'
        ],
        answer: 'Improve user experience',
      ),
      Quiz(
        chapter: 1,
        question:
            'Which principle focuses on making systems easy to learn and use?',
        options: ['Usability', 'Accessibility', 'Affordance', 'Feedback'],
        answer: 'Usability',
      ),
      Quiz(
        chapter: 1,
        question:
            'What is the term for the difference between the user’s mental model and the system’s model?',
        options: [
          'Cognitive load',
          'Usability gap',
          'Interaction gap',
          'Mismatch'
        ],
        answer: 'Mismatch',
      ),
      Quiz(
        chapter: 1,
        question:
            'Which type of interface uses visual elements to facilitate user interaction?',
        options: [
          'Text-based interface',
          'Graphical User Interface (GUI)',
          'Command Line Interface',
          'Voice User Interface'
        ],
        answer: 'Graphical User Interface (GUI)',
      ),
      Quiz(
        chapter: 1,
        question: 'What does usability testing typically involve?',
        options: ['A/B testing', 'Focus groups', 'User observation', 'Surveys'],
        answer: 'User observation',
      ),
      Quiz(
        chapter: 1,
        question:
            'Which term refers to the layout of interactive elements in a user interface?',
        options: [
          'Interface design',
          'Information architecture',
          'User flow',
          'Wireframe'
        ],
        answer: 'Interface design',
      ),
      Quiz(
        chapter: 1,
        question: 'What does the term “affordance” mean in HCI?',
        options: [
          'The capacity of an interface to support user tasks',
          'The physical properties of an object that suggest its use',
          'The feedback provided by the system',
          'The learning curve associated with an interface'
        ],
        answer: 'The physical properties of an object that suggest its use',
      ),
      Quiz(
        chapter: 1,
        question:
            'What is the primary focus of the User-Centered Design process?',
        options: [
          'Technical feasibility',
          'User needs and goals',
          'Market trends',
          'Design aesthetics'
        ],
        answer: 'User needs and goals',
      ),
      // Add more chapters and questions as needed
    ];

    for (Quiz quiz in predefinedQuizList) {
      await addQuiz(quiz);
    }
  }
}
