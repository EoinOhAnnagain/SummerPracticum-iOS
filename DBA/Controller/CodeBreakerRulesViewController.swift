//
//  CodeBreakerRulesViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 26/07/2021.
//

import UIKit

class CodeBreakerRulesViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var tapCounter: UIButton!
    
    // Tap recogniser
    @IBOutlet var tap: UITapGestureRecognizer!
    
    // Variable to store the timer
    var timer: Timer?
    
    // String to display the rules
    let rules = "Welcome to CodeBreakers\n\n\nSETUP:\n\tThe computer has created a code consisting of four colours. Your goal is to figure out the code in eight turns or less.\n\n\nHOW TO PLAY:\n\tDuring each turn use the four colour circles at the bottom of the screen to take a guess at the code. Press the button to the right when you are ready to make your guess.\n\nIf you can reason the code you win, however after eight in correct guesses the game ends and you loose.\n\n\nHITS AND BLOWS:\n\tHits and blows are the only hit to the correct code that you will receive through the course of the game.\n\nEach hit means that you have a colour in the correct place and each blow means that you have a correct colour, but it is in the wrong place.\n\nNeither hits nor blows tell you which colour(s) they refer to.\n\n\nHINT\n* * * Tap the name of the game three times for a hint * * *"
    
    // Counter for the number of taps on the title
    var titleCounter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animate the title
        animateTitle()
        
        // Change button to display no text
        tapCounter.setTitle("", for: .normal)
        
        // Display the rules
        descriptionText.text = rules
    }
    

//MARK: - Taps
    
    @IBAction func tapper(_ sender: Any) {
        // Dismiss on tap
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func titleTapped(_ sender: UIButton) {
        
        // Increase counter
        titleCounter += 1
        
        // If the counter has not above three breifly display the number of taps
        if titleCounter <= 3 {
            
            timer?.invalidate()
            sender.setTitle(String(self.titleCounter), for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { Timer in
                UIView.transition(with: sender,
                                  duration: 0.25,
                                  options: [.transitionCrossDissolve],
                                  animations: {
                                    sender.setTitle("", for: .normal)
                                  }, completion: nil)
            }
        }
        
        // If the counter is three change the dispalyed text to the hint
        if titleCounter == 3 {
            UIView.transition(with: descriptionText,
                              duration: 3,
                              options: [.transitionCrossDissolve],
                              animations: {
                                self.descriptionText.text = "HINT:\n\tStart by guessing pairs of colours. This will help narrow down which colours are not present and quickly identify which colours to concentrate on. You should also be able to find a few hits fairly quickly this way.\n\nBe careful though...Colours can appear more than once and using this method can make it easy to miss three or more of the same colour appearing."
                              }, completion: nil)
        }
    }

    
    //MARK: - Title Animation
    
    func animateTitle() {
        // Method to animate the title image
        
        // Set animation settings
        titleImage.image = UIImage(named: "CodeBreaker-23")
        titleImage.animationImages = animateImage(for: "CodeBreaker-")
        titleImage.animationDuration = 19
        
        // Start animation
        titleImage.startAnimating()
    }
    
    func animateImage(for name: String) -> [UIImage] {
        // Method to start the title animation
        
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)\(i)") {
            images.append(image)
            i += 1
            if i == 30 {
                for _ in 0...115 {
                    images.append(UIImage(named: "CodeBreaker-30")!)
                }
            }
        }
        
        for _ in 0...120 {
            images.append(UIImage(named: "CodeBreaker-1")!)
        }
        
        return images
    }
}
