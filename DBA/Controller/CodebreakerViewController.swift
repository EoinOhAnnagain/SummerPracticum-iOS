//
//  HitAndBlowViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 14/07/2021.
//

import UIKit

class CodebreakerViewController: UIViewController {
    
    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlets for user controls
    @IBOutlet weak var UC1: UIButton!
    @IBOutlet weak var UC2: UIButton!
    @IBOutlet weak var UC3: UIButton!
    @IBOutlet weak var UC4: UIButton!
    
    // IBOutlet collections for numerous colour displays
    @IBOutlet var UserCircles: [UIButton]!
    @IBOutlet var AnswerCircles: [UIButton]!
    @IBOutlet var roundCircles: [UIButton]!
    
    // IBOutlet for answer button
    @IBOutlet weak var answerButton: UIButton!
    
    // IBOutlet collections for labels
    @IBOutlet var roundLabels: [UILabel]!
    @IBOutlet var hitAndBlowLabels: [UILabel]!
    
    // IBOutles for the end of the game
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var gameOverImage: UIImageView!
    @IBOutlet var victoryImages: [UIImageView]!
    
    // Array for colours the game uses
    let colors: [UIColor] = [.systemPurple, .systemGreen, .systemOrange, .systemGray, .systemRed, .systemTeal]
    
    // Round and circle counters
    var currentRound = 0
    var currentCircle = 0
    
    // Array to hold computers code and users answers
    var codeColors: [UIColor] = []
    var answerColors: [UIColor] = []
    
    // Variables for computing the number of hits and blows in a round
    var hitCounter = 0
    var blowCounter = 0
    var used = [false, false, false, false]
    var hits = [false, false, false, false]
    var blows = [false, false, false, false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide images that are not needed yet
        gameOverImage.alpha = 0
        resultLabel.alpha = 0
        for victoryImage in victoryImages {
            victoryImage.alpha = 0
        }
        
        // Set answer button image
        answerButton.setImage(UIImage(systemName: "circle.grid.2x2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)), for: .normal)
        
        // Create code
        codeColors = []
        for _ in 1...4 {
            codeColors.append(colors[Int.random(in: 0...5)])
        }
        
        // Round corners and circle setup
        labelFont(roundLabels)
        labelFont(hitAndBlowLabels)
        for circle in UserCircles {
            roundCorners(circle)
            circle.backgroundColor = colors[circle.tag]
        }
        for circle in AnswerCircles {
            roundCorners(circle)
            circle.backgroundColor = UIColor(named: K.color)
            circle.setTitle("..?..", for: .normal)
            circle.layer.borderWidth = 3
            circle.layer.borderColor = UIColor.systemGray3.cgColor
        }
        
//        Uncomment this section to dispaly the devices chosen code for debugging 
//        for i in 0...3 {
//            AnswerCircles[i].backgroundColor = codeColors[i]
//        }
        
        // Prepare for current round
        prepRoundCircles(roundCircles)
        prepRoundLabels()
        currectRoundPrep(roundCircles, roundLabels[0])
    }
    

    func labelFont(_ labels: [UILabel]) {
        // Reduce font size on smaller devices
        for label in labels {
            label.adjustsFontSizeToFitWidth = true
        }
    }
    
//MARK: - Round Preparation
    
    func prepRoundCircles(_ circles: [UIButton]) {
        // Hind all round circles
        
        for circle in circles {
            roundCorners(circle)
            circle.backgroundColor = .clear
            circle.layer.borderWidth = 0
        }
    }
    
    func prepRoundLabels() {
        // Hind all round labels
        
        for label in roundLabels {
            label.alpha = 0
        }
        for label in hitAndBlowLabels {
            label.alpha = 0
        }
    }
    
    func currectRoundPrep(_ circles: [UIButton],_ roundLabel: UILabel) {
        // Prep the circles and labels for the current round
        for i in currentCircle...currentCircle+3 {
            roundCircles[i].backgroundColor = .clear
            roundCircles[i].layer.borderWidth = 3
            roundCircles[i].layer.borderColor = UIColor.systemGray3.cgColor
        }
        roundLabel.text = "Round\n\(currentRound+1)"
        roundLabel.alpha = 1
    }
    
    
//MARK: - User Interaction
    
    @IBAction func userButtonPressed(_ sender: UIButton) {
        // Change the colour of the user buttons
        
        sender.tag += 1
        if sender.tag == 6 {
            sender.tag = 0
        }
        sender.backgroundColor = colors[sender.tag]
    }
    
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        // Lock in users guess and check it for hits and blows
        
        // If the game is over start a new game by calling viewDidLoad()
        if currentRound == -1 {
            currentRound += 1
            viewDidLoad()
        } else {
            
            // Incriment current round counter
            currentRound += 1
            
            // Create array of the users colours
            var userColors: [UIColor] = []
            for circle in UserCircles {
                userColors.append(circle.backgroundColor!)
            }
            
            // Set the round circles to the users colours
            for i in 0...3 {
                roundCircles[currentCircle].backgroundColor = userColors[i]
                currentCircle += 1
            }
            
            // Check if the current round is the last round
            if currentRound == 8 {
                
                // Reset the counters in preparation for a new round
                currentRound = -1
                currentCircle = 0
                
                // Check if the user lost with the flag that it is the last round
                if checkAnswers(true) == false {
                    // If the player didnt win call gameLost()
                    gameLost()
                }
                
                
                
            } else {
                
                // Call check answer. Return is not needed here.
                checkAnswers(false)
            }
        }
    }
    
    
//MARK: - Game Logic
    
    func checkAnswers(_ last: Bool) -> Bool {
        // Method to check if the users answers are hits or blows
        
        // Reset arrays and counters
        used = [false, false, false, false]
        hits = [false, false, false, false]
        blows = [false, false, false, false]
        hitCounter = 0
        blowCounter = 0
        
        // Array of colour to check
        answerColors = []
        for circle in UserCircles {
            answerColors.append(circle.backgroundColor!)
        }
        
        // Compart user colours to answers for hits
        for i in 0...3 {
            if codeColors[i].accessibilityName == answerColors[i].accessibilityName {
                used[i] = true
                hits[i] = true
            }
        }
        
        // Compare user colours to answers for blows if it has not been used for a hit
        for i in 0...3 {
            if hits[i] == true {
                continue
            }
            for g in 0...3 {
                if used[g] == true {
                    continue
                }
                if answerColors[g].accessibilityName == codeColors[i].accessibilityName {
                    used[g] = true
                    blows[i] = true
                    break 
                }
            }
        }
        
        // Update hit and blow counters
        for i in 0...3 {
            if hits[i] == true {
                hitCounter += 1
            }
            if blows[i] == true {
                blowCounter += 1
            }
        }
        
        // Check for win condition
        if hitCounter == 4 {
            gameWon()
            return true
            
        // If not the last round
        } else if last == false {
            
            // Display hits and blows
            hitAndBlowLabels[currentRound-1].alpha = 1
            var hitAndBlowString = "\(hitCounter) hit"
            if hitCounter > 1 {
                hitAndBlowString.append("s")
            }
            hitAndBlowString.append("\n\(blowCounter) blow")
            if blowCounter > 1 {
                hitAndBlowString.append("s")
            }
            hitAndBlowLabels[currentRound-1].text = hitAndBlowString
            
            // Prep for next round
            currectRoundPrep(roundCircles, roundLabels[currentRound])
        }
        
        // Return that the user has not won
        return false
    }
    
    
    func gameLost() {
        // Method for when the player looses
        
        // Answer button image to reset image
        answerButton.setImage(UIImage(systemName: "chevron.left.2"), for: .normal)
        
        // Show user the answer
        revealCode()
        
        // Display game over text and images
        gameOverImage.alpha = 1
        resultLabel.alpha = 1
        resultLabel.textColor = .systemRed
        resultLabel.text = "Game Over.\nPress << to play again."
    }
    
    func gameWon() {
        // Method for when the player wins
        
        // Show user the answer
        revealCode()
        
        // Display victory text and images
        for victoryImage in victoryImages {
            victoryImage.alpha = 1
        }
        resultLabel.alpha = 1
        resultLabel.textColor = .systemGreen
        resultLabel.text = "Congratulations!!! You Win!!!\nPress << to play again."
        
        // Answer button image to reset image
        answerButton.setImage(UIImage(systemName: "chevron.left.2"), for: .normal)
        
        // Reset counters in prep for new game
        currentRound = -1
        currentCircle = 0
        
    }
    
    
    func revealCode() {
        // Method to show the user the answer
        
        var counter = 0
        for circle in AnswerCircles {
            circle.setTitle("", for: .normal)
            circle.backgroundColor = codeColors[counter]
            counter += 1
        }
    }
}

//MARK: - Audio Book Control

extension CodebreakerViewController {
    // Audio book navigation bar controls
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SpeechService.shared.renderStopButton() {
            bookStopButton.image = UIImage(systemName: "play.slash")
        } else {
            bookStopButton.image = nil
        }
    }

    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        bookStopButton.image = nil
    }
}
