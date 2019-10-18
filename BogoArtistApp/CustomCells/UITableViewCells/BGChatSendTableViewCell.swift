//
//  BGChatSendTableViewCell.swift
//  BogoArtistApp
//
//

import UIKit

class BGChatSendTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var messageBodyLabel: UILabel!
    @IBOutlet var containerVew: UIView!
    @IBOutlet weak var timeLabelSend: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = 15
        self.profileImage.clipsToBounds = true
        setShadowview(newView: containerVew)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
