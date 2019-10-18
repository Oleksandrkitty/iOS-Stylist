//
//  BGSingleTextFieldCell.swift
//  BOGOArtistApp
//
//

import UIKit

class BGSingleTextFieldCell: UITableViewCell {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
