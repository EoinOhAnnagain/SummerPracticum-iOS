//
//  AboutUsCellTableViewCell.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 01/08/2021.
//

import UIKit

class AboutUsCellTableViewCell: UITableViewCell {

    // IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // When called round the image corners
        
        roundCorners(profileImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
