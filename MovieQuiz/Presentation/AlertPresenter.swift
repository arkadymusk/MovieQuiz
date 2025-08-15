//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 13.04.2025.
//
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
            self.delegate = delegate
        }

        func show(model: AlertModel) {
            
            let alert = UIAlertController(
                title: model.title,
                message: model.message,
                preferredStyle: .alert
            )

            let action = UIAlertAction(
                title: model.buttonText,
                style: .default
            ) { _ in
                model.completion()
            }

            alert.addAction(action)
            delegate?.presentAlert(alert)
        }
}
