//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 25.09.2025.
//
import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    private var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    var alertPresenter: AlertPresenterProtocol?
    private var isAnsweringNow = false
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(delegate: viewController as? AlertPresenterDelegate)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        viewController.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStep {
        let questionStep = QuizStep(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
    }
    
    func nextQuestion() {
        self.questionFactory?.requestNextQuestion()
    }
    
    func makeResultsMessage() -> String {
        """
        Ваш результат: \(correctAnswers)/10 \n
        Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0) \n
        Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date.dateTimeString ?? "")) \n
        Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%
        """
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            // идем в состояние "результат квиза"
            
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            
            let title = "Этот раунд окончен!"
            let text = makeResultsMessage()
            let buttonText = "Сыграть еще раз"
            
            let alertModel = AlertModel(
                title: title,
                message: text,
                buttonText: buttonText
            ) { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }

            alertPresenter?.show(model: alertModel)
            viewController?.clearImageBorder()

        } else {
            self.switchToNextQuestion()
            // идем в состояние "вопрос показан"
            viewController?.clearImageBorder()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    
    
    func proceedWithAnswer(isCorrect: Bool) {
        guard !isAnsweringNow else { return }
        isAnsweringNow = true
        
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.setButtonsEnabled(false)
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // код, который мы хотим вызвать через 1 секунду
            self?.proceedToNextQuestionOrResults()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
       
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func reloadData() {
        questionFactory?.loadData()
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
           
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.clearImageBorder()
            self.viewController?.show(quiz: viewModel)
            self.viewController?.setButtonsEnabled(true)
            self.isAnsweringNow = false
        }
    }
}
