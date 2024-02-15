//
//  ViewController.swift
//  Swifty Words
//
//  Created by Zeeshan Waheed on 15/02/2024.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
//  to keep up with score and level
    var score = 0
//  one because file name starts with level1
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
//      creating a score label that displays the score at the right side of screen
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
//      to display
        view.addSubview(scoreLabel)
        
        
//      creating a clues label
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
//      creating answer label
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
//      text field
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
//      such that user cant activate the text box
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
//      creating a submit button
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
//      functionality and how the button will behave
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
//      creating a clear button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
//      functionality and how the button will behave
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
//      creating letter buttons view
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        
//      setting constraints
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//          first we added score label constraints now we'll add clues label constraints
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
//          adding answer label constraints
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
//          adding current answer text label constraints
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
//          adding submit button constraints
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
//          adding clear button constraints
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
//          adding letter button constraints
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        
//      creating letter buttons
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
//              calling this function when any letter button is tapped
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
//              adding it to the letterbuttons array
                letterButtons.append(letterButton)
            }
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      displaying our functions
        loadLevel()
        
    }

//  function when a letter button is tapped
    @objc func letterTapped(_ sender: UIButton) {
        
    }
    
//  function when a submit button is tapped
    @objc func submitTapped() {
        
    }
    
//  function when clear button is tapped
    @objc func clearTapped(_ sender: UIButton) {
        
    }
    
    func loadLevel() {
//      hold the full string shown in clues label
        var clueString = ""
//      all text we show inside answer label
        var solutionsString = ""
//      all possible letter parts
        var letterBits = [String]()
        
//      getting the right file
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
//              splitting all 7 clues
                var lines = levelContents.components(separatedBy: "\n")
//              shuffling all clues
                lines.shuffle()
                
//              looping over all those lines, enumerator returns two values
                for (index, line) in lines.enumerated() {
//                  splitting the clue line into two parts (line eg. HA|UNT|ED: Ghosts in residence)
                    let parts = line.components(separatedBy: ": ")
//                  setting answer as first index element of array
                    let answer = parts[0]
//                  setting clue as second index element of array
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
//                  removing the pipes in string
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
//                  counting how many letters our solution has
                    solutionsString += "\(solutionWord.count) letters\n"
//                  appending that to out solutions array
                    solutions.append(solutionWord)
                    

                    let bits = answer.components(separatedBy: "|")
//                  adding solution letter bits to main letter bits such that it contains all
//                  possible letter bits
                    letterBits += bits
                }
            }
        }
        
//      trimming out final line breaks from clueString and solutionString
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
//      randomizing letter buttons
        letterButtons.shuffle()
        
        if letterButtons.count == letterBits.count {
//          iterating thorough all letter buttons and assign that title
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }

}
