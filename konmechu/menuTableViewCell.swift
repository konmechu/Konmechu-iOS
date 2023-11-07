//
//  menuTableViewCell.swift
//  konmechu
//
//  Created by 정재연 on 11/7/23.
//

import UIKit

class menuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var menuImgView: UIImageView!
    
    @IBOutlet weak var mealTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
