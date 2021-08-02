//
//  ChatCell.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/07/2021.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var chatBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightSpeechBubble: UIImageView!
    @IBOutlet weak var leftSpeechBubble: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatBubble.layer.cornerRadius = chatBubble.frame.size.height / 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            UIView.animate(withDuration: 0.5) {
                self.contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
                self.rightSpeechBubble.image = UIImage(systemName: "arrow.left")
                self.leftSpeechBubble.image = UIImage(systemName: "arrow.right")
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.contentView.backgroundColor = UIColor.clear
                self.rightSpeechBubble.image = UIImage(systemName: "bubble.right")
                self.leftSpeechBubble.image = UIImage(systemName: "bubble.left.fill")
            }
        }

        // Configure the view for the selected state
    }
    
}
