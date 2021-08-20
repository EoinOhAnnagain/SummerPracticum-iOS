//
//  ChatCell.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/07/2021.
//

import UIKit

class ChatCell: UITableViewCell {

    // IBOutlets
    @IBOutlet weak var chatBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightSpeechBubble: UIImageView!
    @IBOutlet weak var leftSpeechBubble: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Code for when ChatCell created
        
        chatBubble.layer.cornerRadius = chatBubble.frame.size.height / 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // What to do when a ChatCell is selected
        
        if selected {
            // If the ChatCell is selected change its background colour to blue
            UIView.animate(withDuration: 0.5) {
                self.contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            }
        } else {
            // Otherwise set the background colour to the default colour
            UIView.animate(withDuration: 0.5) {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }
}
