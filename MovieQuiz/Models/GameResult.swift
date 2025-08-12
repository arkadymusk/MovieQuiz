//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 09.08.2025.
//
import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ result: GameResult) -> Bool {
        correct > result.correct
    }
}
