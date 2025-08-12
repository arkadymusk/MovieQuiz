//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 11.04.2025.
//

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private var shuffledQuestions: [QuizQuestion] = []
    private var currentQuestionIndex = 0
    
    init(delegate: QuestionFactoryDelegate?){
        self.delegate = delegate
        self.shuffledQuestions = questions.shuffled()
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    func requestNextQuestion() {
        guard currentQuestionIndex < shuffledQuestions.count else {
                delegate?.didReceiveNextQuestion(question: nil)
                return
            }
            let question = shuffledQuestions[currentQuestionIndex]
            delegate?.didReceiveNextQuestion(question: question)
            currentQuestionIndex += 1
    }
    
    func reset() {
        shuffledQuestions = questions.shuffled()
        currentQuestionIndex = 0
    }
}

