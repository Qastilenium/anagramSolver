//
//  ViewController.swift
//  anagramGame
//
//  Created by Ilryc Marokonen on 02.03.2024.
//  thx hackingwithswift.com for education!

import Foundation
import UIKit

class ViewController: UITableViewController {
    var viewModel = WordGameViewModel()
    var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(userAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newGame))
        
        setupScoreLabel()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateScoreLabel), name: .scoreUpdated, object: nil)
    }
    
    
    // MARK: - Funcs
    @objc func newGame() { setupView() }
    
    func setupView() {
        viewModel.startGame()
        title = viewModel.title
        tableView.reloadData()
    }
    
    func setupScoreLabel() {
        scoreLabel = UILabel(frame: CGRect(x: 300, y: 300, width: 150, height: 20))
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateScoreLabel()
    }
    
    @objc func updateScoreLabel() {
        scoreLabel.text = "Score - \(viewModel.model.score)"
    }
    
    @objc func userAnswer() {
        let ac = UIAlertController(title: "Enter your answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            if self?.viewModel.submit(answer) == nil {
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .right)
            }
            else if let error = self?.viewModel.submit(answer) {
                let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Well... Here we go again", style: .destructive))
                self?.present(alertController, animated: true)
            } else {
                self?.tableView.reloadData()
            }
            self?.updateScoreLabel()
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    // MARK: - Overrided funcs
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.usedWords.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = viewModel.usedWords[indexPath.row]
        return cell
    }
}

// MARK: - Extensions
extension Notification.Name {
    static let scoreUpdated = Notification.Name("scoreUpdated")
}

