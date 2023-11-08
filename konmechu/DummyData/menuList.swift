//
//  menuList.swift
//  konmechu
//
//  Created by 정재연 on 11/7/23.
//

import UIKit

struct MenuData {
    let title: String
    let image: String
    let time: String
}

extension MenuData {
    static var data = [
        MenuData(title: "햄버거", image: "menu1", time: "아침"),
        MenuData(title: "부침개", image: "menu2", time: "점심"),
        MenuData(title: "복숭아", image: "menu3", time: "점심"),
        MenuData(title: "치킨", image: "menu4", time: "저녁"),
        MenuData(title: "피자", image: "menu5", time: "저녁")
    ]
}
