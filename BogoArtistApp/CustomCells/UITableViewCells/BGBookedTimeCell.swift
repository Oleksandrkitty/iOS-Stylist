//
//  BGBookedTimeCell.swift
//  BogoArtistApp
//
//

import UIKit

class BGBookedTimeCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var crossAction: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var indicatorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let rectShape = CAShapeLayer()
        rectShape.bounds = indicatorLabel.frame
        rectShape.position = indicatorLabel.center
        rectShape.path = UIBezierPath(roundedRect: indicatorLabel.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        indicatorLabel.layer.mask = rectShape

        setShadowview(newView: containerView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
