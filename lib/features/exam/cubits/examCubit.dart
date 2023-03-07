/* import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bevicschurch/features/exam/examRepository.dart';
import 'package:bevicschurch/features/exam/models/exam.dart';
import 'package:bevicschurch/features/exam/models/examResult.dart'; 

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamFetchInProgress extends ExamState {}

class ExamFetchFailure extends ExamState {
  final String errorMessage;

  ExamFetchFailure(this.errorMessage);
}

class ExamFetchSuccess extends ExamState {
  final List<Question> questions;
  final Exam exam;

  ExamFetchSuccess({required this.exam, required this.questions});
}

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository _examRepository;

  ExamCubit(this._examRepository) : super(ExamInitial());

  void updateState(ExamState newState) {
    emit(newState);
  }

  void startExam({required Exam exam, required String userId}) async {
    emit(ExamFetchInProgress());
    //
    try {
      //fetch question

    /*   List<Question> questions =
          await _examRepository.getExamMouduleQuestions(examModuleId: exam.id);

      // */

      //check if user can give exam or not
      //if user is in exam then it will throw 103 error means fill all data
      await _examRepository.updateExamStatusToInExam(
          examModuleId: exam.id, userId: userId);
      await _examRepository.examLocalDataSource.addExamModuleId(exam.id);
    
    } catch (e) {
      emit(ExamFetchFailure(e.toString()));
    }
  }

 

  int getQuetionIndexById(String questionId) {
    if (state is ExamFetchSuccess) {
      return (state as ExamFetchSuccess)
          .questions
          .indexWhere((element) => element.id == questionId);
    }
    return 0;
  }

 

 

  Exam getExam() {
    if (state is ExamFetchSuccess) {
      return (state as ExamFetchSuccess).exam;
    }
    return Exam.fromJson({});
  }

  bool canUserSubmitAnswerAgainInExam() {
    return getExam().answerAgain == "1";
  }

/*   void submitResult({
    required String userId,
    required String totalDuration,
    required bool rulesViolated,
    required List<String> capturedQuestionIds,
  }) {
    if (state is ExamFetchSuccess) {
      List<Statistics> markStatistics = [];

      getUniqueQuestionMark().forEach((mark) {
        List<Question> questions = getQuestionsByMark(mark);
        int correctAnswers = questions
            .where((element) =>
                element.submittedAnswerId ==
                AnswerEncryption.decryptCorrectAnswer(
                    rawKey: userId, correctAnswer: element.correctAnswer!))
            .toList()
            .length;
        Statistics statistics = Statistics(
            mark: mark,
            correctAnswer: correctAnswers.toString(),
            incorrect: (questions.length - correctAnswers).toString());
        markStatistics.add(statistics);
      });

      //
      markStatistics.forEach((element) {
        print(element.toJson());
      });

      _examRepository.submitExamResult(
          capturedQuestionIds: capturedQuestionIds,
          rulesViolated: rulesViolated,
          obtainedMarks: obtainedMarks(userId).toString(),
          examModuleId: (state as ExamFetchSuccess).exam.id,
          userId: userId,
          totalDuration: totalDuration,
          statistics: markStatistics.map((e) => e.toJson()).toList());

      _examRepository.examLocalDataSource
          .removeExamModuleId((state as ExamFetchSuccess).exam.id);
    }
  } */

  int correctAnswers(String userId) {
    if (state is ExamFetchSuccess) {
      return (state as ExamFetchSuccess)
          .questions
          .where((element) =>
              element.submittedAnswerId ==
              //AnswerEncryption.decryptCorrectAnswer(
                //  rawKey: userId, correctAnswer: element.correctAnswer!)
                  )
          .toList()
          .length;
    }
    return 0;
  }

  int incorrectAnswers(String userId) {
    if (state is ExamFetchSuccess) {
      return (state as ExamFetchSuccess).questions.length -
          correctAnswers(userId);
    }
    return 0;
  }

  int obtainedMarks(String userId) {
    if (state is ExamFetchSuccess) {
      final correctAnswers = (state as ExamFetchSuccess)
          .questions
          .where((element) =>
              element.submittedAnswerId ==
              
                  )
          .toList();
      int obtainedMark = 0;

      correctAnswers.forEach((element) {
        obtainedMark = obtainedMark + int.parse(element.marks ?? "0");
      });

      return obtainedMark;
    }
    return 0;
  }

  List<Question> getQuestionsByMark(String questionMark) {
    if (state is ExamFetchSuccess) {
      return (state as ExamFetchSuccess)
          .questions
          .where((question) => question.marks == questionMark)
          .toList();
    }
    return [];
  }

  List<String> getUniqueQuestionMark() {
    if (state is ExamFetchSuccess) {
      return (state as ExamFetchSuccess)
          .questions
          .map((question) => question.marks!)
          .toSet()
          .toList();
    }
    return [];
  }

  void completePendingExams({required String userId}) {
    _examRepository.completePendingExams(userId: userId);
  }
}
 */