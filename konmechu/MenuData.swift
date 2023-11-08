//
//  MenuData.swift
//  konmechu
//
//  Created by 정재연 on 11/7/23.
//

import UIKit

enum MealTime: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
}

struct MenuData {
    let title: String
    let image: String
    let mealTime: MealTime
}

extension MenuData {
    static var data = [
        MenuData(title: "햄버거", image: "hamburgur", mealTime: .breakfast),
        MenuData(title: "부침개", image: "buchim", mealTime: .breakfast),
        MenuData(title: "복숭아", image: "peech", mealTime: .lunch),
        MenuData(title: "치킨", image: "chicken", mealTime: .dinner),
        MenuData(title: "피자", image: "pizza", mealTime: .dinner)
    ]
}

struct MenuSection {
    var mealTime: MealTime
    var menus: [MenuData]
}
