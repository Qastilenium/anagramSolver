//
//  WordGameViewModel.swift
//  anagramGame
//
//  Created by Ilryc Marokonen on 02.03.2024.
//  thx hackingwithswift.com for education!

import Foundation
import UIKit

class WordGameViewModel {
    private(set) var model: WordGame {
        didSet {
            NotificationCenter.default.post(name: .scoreUpdated, object: nil)
        }
    }
    
    var title: String? {
        didSet {
            model.viewTitle = title
        }
    }
    
    var score: Int {
        didSet {
            model.score = score
        }
    }
    
    var usedWords: [String] { model.usedWords }
    
    init() {
        model = WordGame(viewTitle: "")
        title = model.allWords.randomElement()
        score = model.score
    }
    
    func startGame() {
        model.startGame()
        title = model.allWords.randomElement()
    }
    
    func submit(_ answer: String) -> (title: String, message: String)? {
        model.submit(answer)
    }
}
