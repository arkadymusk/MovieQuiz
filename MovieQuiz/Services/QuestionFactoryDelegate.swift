//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 13.04.2025.
//

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

