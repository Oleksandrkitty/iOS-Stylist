//
//  BGUpcominCell.swift
//  BogoArtistApp
//
//

import UIKit

class BGUpcominCell: UITableViewCell {

    @IBOutlet var bookingTime: UILabel!
    @IBOutlet var clientName: UILabel!
    @IBOutlet var timeStatus: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var messageCount: UIButton!
    @IBOutlet var locationButton: IndexPathButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var clientProfile: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        let rectShape = CAShapeLayer()
        rectShape.bounds = timeLabel.frame
        rectShape.position = timeLabel.center
        rectShape.path = UIBezierPath(roundedRect: timeLabel.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        setShadowview(newView: containerView)
            timeLabel.layer.mask = rectShape
        
        clientProfile.layer.cornerRadius = 33
        clientProfile.layer.masksToBounds = true
        clientProfile.image = UIImage(named: "profile_default")
        clientProfile.contentMode = .scaleAspectFill
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
