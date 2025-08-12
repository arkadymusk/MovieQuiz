//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 13.04.2025.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)
}
