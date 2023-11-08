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
    let uiImage: UIImage?
}

extension MenuData {
    static var yesterdayData = [
        MenuData(title: "햄버거", image: "hamburgur", mealTime: .breakfast, uiImage: nil),
        MenuData(title: "부침개", image: "buchim", mealTime: .breakfast, uiImage: nil),
        MenuData(title: "복숭아", image: "peech", mealTime: .lunch, uiImage: nil),
        MenuData(title: "치킨", image: "chicken", mealTime: .dinner, uiImage: nil),
        MenuData(title: "피자", image: "pizza", mealTime: .dinner, uiImage: nil)
    ]
    
    static var todayData = [
        MenuData(title: "토스트", image: "toast", mealTime: .breakfast, uiImage: nil)
    ]
}

struct MenuSection {
    var mealTime: MealTime
    var menus: [MenuData]
}
