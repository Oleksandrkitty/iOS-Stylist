//
//  BGSummaryTVCell.swift
//  BogoArtistApp
//
//

import UIKit

class BGSummaryTVCell: UITableViewCell {

    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
