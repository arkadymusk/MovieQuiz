//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Аркадий Червонный on 09.08.2025.
//

import UIKit

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case bestGameCorrectAnswers
        case correctAnswers
        case gamesCount
        case bestGameDate
        case bestGameTotalAnswers
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrectAnswers.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotalAnswers.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrectAnswers.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotalAnswers.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalQuestions = gamesCount * 10
        
        guard totalQuestions > 0 else {
            return 0
        }
        
        return (Double(correctAnswers) / Double(totalQuestions)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        correctAnswers += count
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
}
