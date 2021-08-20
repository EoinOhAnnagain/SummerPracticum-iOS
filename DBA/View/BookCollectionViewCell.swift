//
//  BookCollectionViewCell.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 17/07/2021.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    // IBOutlets
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image: UIImage) {
        // Set the imageView to the passed image
        
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.bookCell, bundle: nil)
    }

}
