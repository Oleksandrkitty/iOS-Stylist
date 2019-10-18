//
//  BGReviewCell.swift
//  BogoArtistApp
//
//

import UIKit
import HCSStarRatingView

class BGReviewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var rateBottomNameLabel: UILabel!
    @IBOutlet weak var rateLabel: HCSStarRatingView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
      //  self.rateLabel.value = CGFloat((self.profileData.rating as NSString).floatValue)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
