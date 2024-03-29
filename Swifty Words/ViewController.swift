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
    var score = 0 {
//      if anytime the score is changed it is updated
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
//  to keep track of questions answered for levelling up
    var actualQuestionsAnswered = 0
    
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
        
//      adding border for letter buttons
        buttonsView.layer.borderWidth = 1
        
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
//      all our buttons have title but if there were a button without the title program would exit
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
//      adding button string to current answer text field
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
//      all buttons that user has tapped
        activatedButtons.append(sender)
//      using isHidden such that it can't be tapped again
        sender.isHidden = true
    }
    
//  function when a submit button is tapped
    @objc func submitTapped() {
//      storing our text field input in answer Text variable
        guard let answerText = currentAnswer.text else { return }
    
//      finding answer text using index
        if let solutionPosition = solutions.firstIndex(of: answerText) {
//          removing all activated buttons if answer is found
            activatedButtons.removeAll()
//          splitting the answers
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            
//          checking which answer the input was equal to and then setting the answer in the answers label section where the format is "6 letters"
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
//          clearing out search field
            currentAnswer.text = ""
//          adding one to score
            score += 1
            
//          this variable is to keep track or questions answered
            actualQuestionsAnswered += 1
            
//          if this condition is true it means that all answers were obtained and it'll load new file to get new questions
            if actualQuestionsAnswered % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
//          deducting score
            score -= 1
//          if the guess is wrong it returns an alert controller and clears the text field
            let ac = UIAlertController(title: nil, message: "Wrong guess!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "try again!", style: .default) { _ in
                let button = UIButton(type: .system)
                self.clearTapped(button)
            })
            present(ac, animated: true)
            
        }
    }
    
//  levelling up function
    func levelUp(action: UIAlertAction) {
        level += 1
        
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
//  function when clear button is tapped
    @objc func clearTapped(_ sender: UIButton) {
//      clearing the text field
        currentAnswer.text = ""
        
//      unhiding all buttons such that they can be tapped
        for button in activatedButtons {
            button.isHidden = false
        }
        
//      removing all buttons from the array
        activatedButtons.removeAll()
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
