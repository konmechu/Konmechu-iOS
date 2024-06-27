//
//  CustomButton.swift
//  konmechu
//
//  Created by 정재연 on 6/27/24.
//

import UIKit

class CustomButton: UIButton {

    var mealId: Int = 0
    var memberId: Int = 0
    var foodName: String = ""
    var isClicked: Bool = false
    
    init(mealId: Int, memberId: Int) {
        super.init(frame: CGRect())
        self.mealId = mealId
        self.memberId = memberId
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setRequestInform(mealId: Int, memberId: Int, foodName: String) {
        self.mealId = mealId
        self.memberId = memberId
        self.foodName = foodName
    }
}
