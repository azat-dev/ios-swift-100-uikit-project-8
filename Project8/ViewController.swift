//
//  ViewController.swift
//  Project8
//
//  Created by Azat Kaiumov on 27.05.2021.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var level = 1
    var numberOfCorrectAnswers = 0
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    
    func initViews() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.text = "Clues"
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = .systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(.init(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.text = "Answers"
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = .systemFont(ofSize: 24)
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(.init(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.font = .systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letters to guess"
        view.addSubview(currentAnswer)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -50),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.leadingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let buttonWidth = 150
        let buttonHeight = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = .systemFont(ofSize: 36)
                button.setTitle("WWW", for: .normal)
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(
                    x: column * buttonWidth,
                    y: row * buttonHeight,
                    width: buttonWidth,
                    height: buttonHeight
                )
                
                button.frame = frame
                
                letterButtons.append(button)
                buttonsView.addSubview(button)
            }
        }
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        guard let levelUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            return
        }
        
        guard let levelText = try? String(contentsOf: levelUrl) else {
            return
        }
        
        let lines = levelText.components(separatedBy: "\n").shuffled()
        
        for (index, line) in lines.enumerated() {
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            
            
            letterBits += answer.components(separatedBy: "|")
            clueString += "\(index + 1). \(clue)\n"
            
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            solutionString += "\(solutionWord.count) letters\n"
            solutions.append(solutionWord)
        }
        
        DispatchQueue.main.async {
            self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            
            if letterBits.count == self.letterButtons.count {
                for (index, button) in self.letterButtons.enumerated() {
                    button.setTitle(letterBits[index], for: .normal)
                }
            }
        }
    }
    
    @objc func clearTapped() {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func levelUp() {
        level += 1
        numberOfCorrectAnswers = 0
        solutions.removeAll()
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    func showNextLevelAlert() {
        let alert = UIAlertController(
            title: "Well done!",
            message: "Are you ready for the next level?",
            preferredStyle: .alert
        )
        
        alert.addAction(
            .init(
                title: "Let's go!",
                style: .default,
                handler: {[weak self] _ in self?.levelUp() }
            )
        )
        
        present(alert, animated: true)
    }
    
    func showWrongAnswerAlert() {
        let alert = UIAlertController(title: "Wrong", message: "Wrong answer!", preferredStyle: .alert)
        alert.addAction(.init(title: "Continue", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func submitTapped() {
        guard let currentAnswerText = currentAnswer.text else {
            return
        }
        
        guard let solutionIndex = solutions.firstIndex(of: currentAnswerText) else {
            score -= 1
            showWrongAnswerAlert()
            return
        }
        
        currentAnswer.text = ""
        
        guard let answersString = answersLabel.text else {
            return
        }
        
        var answers = answersString.components(separatedBy: "\n")
        answers[solutionIndex] = solutions[solutionIndex]
        
        answersLabel.text = answers.joined(separator: "\n")
        score += 1
        numberOfCorrectAnswers += 1
        
        if numberOfCorrectAnswers % 7 == 0 {
            showNextLevelAlert()
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        
        currentAnswer.text = currentAnswer.text?.appending(text)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLevel()
        }
    }
}

