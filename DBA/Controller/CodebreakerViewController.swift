//
//  HitAndBlowViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 14/07/2021.
//

import UIKit

class CodebreakerViewController: UIViewController {
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    @IBOutlet weak var UC1: UIButton!
    @IBOutlet weak var UC2: UIButton!
    @IBOutlet weak var UC3: UIButton!
    @IBOutlet weak var UC4: UIButton!
    
    @IBOutlet var UserCircles: [UIButton]!
    @IBOutlet var AnswerCircles: [UIButton]!
    
    @IBOutlet var roundCircles: [UIButton]!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet var roundLabels: [UILabel]!
    
    @IBOutlet var hitAndBlowLabels: [UILabel]!
    
    let colors: [UIColor] = [.systemPurple, .systemGreen, .systemOrange, .systemGray, .systemRed, .systemTeal]
    
    var currentRound = 0
    var currentCircle = 0
    
    var codeColors: [UIColor] = []
    
    var answerColors: [UIColor] = []
    var hitCounter = 0
    var blowCounter = 0
    var used = [false, false, false, false]
    var hits = [false, false, false, false]
    var blows = [false, false, false, false]
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var gameOverImage: UIImageView!
    @IBOutlet var victoryImages: [UIImageView]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gameOverImage.alpha = 0
        resultLabel.alpha = 0
        for victoryImage in victoryImages {
            victoryImage.alpha = 0
        }
        
        
        answerButton.setImage(UIImage(systemName: "circle.grid.2x2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)), for: .normal)
        
        
        codeColors = []
        for _ in 1...4 {
            codeColors.append(colors[Int.random(in: 0...5)])
        }
        
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
        
        prepRoundCircles(roundCircles)
        prepRoundLabels()
        
        currectRoundPrep(roundCircles, roundLabels[0])
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func labelFont(_ labels: [UILabel]) {
        for label in labels {
            label.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    func prepRoundCircles(_ circles: [UIButton]) {
        for circle in circles {
            roundCorners(circle)
            circle.backgroundColor = .clear
            circle.layer.borderWidth = 0
        }
    }
    
    func prepRoundLabels() {
        for label in roundLabels {
            label.alpha = 0
        }
        for label in hitAndBlowLabels {
            label.alpha = 0
        }
    }
    
    func currectRoundPrep(_ circles: [UIButton],_ roundLabel: UILabel) {
        for i in currentCircle...currentCircle+3 {
            roundCircles[i].backgroundColor = .clear
            roundCircles[i].layer.borderWidth = 3
            roundCircles[i].layer.borderColor = UIColor.systemGray3.cgColor
        }
        roundLabel.text = "Round\n\(currentRound+1)"
        roundLabel.alpha = 1
    }
    
   
    
    
    
    func circleise (_ name: UIButton) {
        name.layer.cornerRadius = 0.5 * name.bounds.size.width
    }
    
    @IBAction func userButtonPressed(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag == 6 {
            sender.tag = 0
        }
        sender.backgroundColor = colors[sender.tag]
    }
    
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        if currentRound == -1 {
            currentRound += 1
            viewDidLoad()
        } else {
            
            currentRound += 1
            
            var userColors: [UIColor] = []
            for circle in UserCircles {
                userColors.append(circle.backgroundColor!)
            }
            
            
            
            for i in 0...3 {
                roundCircles[currentCircle].backgroundColor = userColors[i]
                currentCircle += 1
            }
            
            if currentRound == 8 {
                
                
                currentRound = -1
                currentCircle = 0
                
                if checkAnswers(true) == false {
                    gameLost()
                }
                
                
                
            } else {
                
                checkAnswers(false)
                
                
                
            }
        }
    }
    
    func checkAnswers(_ last: Bool) -> Bool {
        
        used = [false, false, false, false]
        hits = [false, false, false, false]
        blows = [false, false, false, false]
        hitCounter = 0
        blowCounter = 0
        
        answerColors = []
        for circle in UserCircles {
            answerColors.append(circle.backgroundColor!)
        }
        
        
        for i in 0...3 {
            if codeColors[i].accessibilityName == answerColors[i].accessibilityName {
                used[i] = true
                hits[i] = true
            }
        }
        
        
        
        
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
        
        
        for i in 0...3 {
            if hits[i] == true {
                hitCounter += 1
            }
            if blows[i] == true {
                blowCounter += 1
            }
        }
        
        if hitCounter == 4 {
            gameWon()
            return true
        } else if last == false {
            
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
            currectRoundPrep(roundCircles, roundLabels[currentRound])
        }
        return false
    }
    
    
    func gameLost() {
        answerButton.setImage(UIImage(systemName: "chevron.left.2"), for: .normal)
        
        revealCode()
        
        gameOverImage.alpha = 1
        resultLabel.alpha = 1
        resultLabel.textColor = .systemRed
        resultLabel.text = "Game Over.\nPress << to play again."
    }
    
    func gameWon() {
        
        revealCode()
        
        for victoryImage in victoryImages {
            victoryImage.alpha = 1
        }
        resultLabel.alpha = 1
        resultLabel.textColor = .systemGreen
        resultLabel.text = "Congratulations!!! You Win!!!\nPress << to play again."
        answerButton.setImage(UIImage(systemName: "chevron.left.2"), for: .normal)
        
        currentRound = -1
        currentCircle = 0
        
    }
    
    
    func revealCode() {
        var counter = 0
        for circle in AnswerCircles {
            circle.setTitle("", for: .normal)
            circle.backgroundColor = codeColors[counter]
            counter += 1
        }
    }
    
    //    func newGame() {
    //        answerButton.setImage(UIImage(systemName: "circle.grid.2x2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)), for: .normal)
    //
    //        for circle in roundCircles {
    //            circle.backgroundColor = .clear
    //            circle.layer.borderWidth = 0
    //        }
    //
    //        for circle in AnswerCircles {
    //            circle.backgroundColor = UIColor(named: K.color)
    //            circle.setTitle("..?..", for: .normal)
    //        }
    
    //for label in roundLabels {
    //    label.alpha = 0
    //}
    
    //viewDidLoad()
    
    
    
    // }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - Audio Book Control

extension CodebreakerViewController {
    
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
