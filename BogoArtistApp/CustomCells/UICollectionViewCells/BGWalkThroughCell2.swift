//
//  BGWalkThroughCell2.swift
//  BogoArtistApp
//
//

import UIKit

class BGWalkThroughCell2: UICollectionViewCell {
    @IBOutlet var verticalAlignmentConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if kWindowWidth == 320 {
            verticalAlignmentConstant.constant = 40
        }
    }
}
