//
//  BGChatReceivedTableViewCell.swift
//  BogoArtistApp
//
//

import UIKit

class BGChatReceivedTableViewCell: UITableViewCell {

    @IBOutlet var messageBodyLabel: UILabel!
    @IBOutlet var conatinerRecieveView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var widthConstant: NSLayoutConstraint!
    override func awakeFromNib() {
       super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 15
        self.profileImageView.clipsToBounds = true
       setShadowview(newView: conatinerRecieveView)
        self.widthConstant.constant = kWindowWidth - 60
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
