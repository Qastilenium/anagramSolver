//
//  WordGame.swift
//  anagramGame
//
//  Created by Ilryc Marokonen on 02.03.2024.
//  thx hackingwithswift.com for education!

import Foundation
import UIKit

struct WordGame {
    var viewTitle: String?
    var score: Int = 0
    var allWords: [String] = []
    var usedWords: [String] = []
    
    init(viewTitle: String?) {
        self.viewTitle = viewTitle
        startGame()
    }
    
    mutating func startGame() {
        if let startGameWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startGameWords = try? String(contentsOf: startGameWordsURL) {
                allWords = startGameWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty { allWords = ["dumbhead"] }
        
        usedWords.removeAll(keepingCapacity: true)
        
        score = 0
    }
    
    mutating func submit(_ answer: String) -> (title: String, message: String)? {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    score += 1
                    print(score)
                    return nil
                } else {
                    errorTitle = "Unrecognized word"
                    errorMessage = "There can't be gibberish, y'know"
                }
            } else {
                errorTitle = "Already used"
                errorMessage = "You're so original!"
            }
        } else {
            guard let title = viewTitle?.lowercased() else { return nil }
            errorTitle = "Error in spellcasting!"
            errorMessage = "You can't spell that word from \(title)"
        }

        return (errorTitle, errorMessage)
    }
    
    mutating func isPossible(word: String) -> Bool {
        guard var tempWord = viewTitle?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }

    func isOriginal(word: String) -> Bool { !usedWords.contains(word) }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
}
