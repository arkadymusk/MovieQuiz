//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 29.09.2025.
//

protocol MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStep)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func setButtonsEnabled(_ isEnabled: Bool)
    func clearImageBorder()
}
