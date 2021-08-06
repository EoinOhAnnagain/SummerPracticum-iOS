//
//  AboutUsCellTableViewCell.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 01/08/2021.
//

import UIKit

class AboutUsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        roundCorners(profileImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
