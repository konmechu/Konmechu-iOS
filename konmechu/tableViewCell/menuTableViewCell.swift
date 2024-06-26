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
    
    @IBOutlet weak var thumbsUpBtn: UIButton!
    
    @IBOutlet weak var menuImgCoverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuImgView.layer.cornerRadius = 20
        menuImgCoverView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
