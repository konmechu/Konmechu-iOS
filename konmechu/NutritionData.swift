//
//  NutritionData.swift
//  konmechu
//
//  Created by 정재연 on 11/8/23.
//

import UIKit

struct NutritionData {
    let caloties : Float?
    let protein : Float?
    let carborhydrate : Float?
    let fat : Float?
    let sugars : Float?
}

extension NutritionData {
    static var yesterdayNutritionData = NutritionData(caloties: 2890.0, protein: 130.5, carborhydrate: 500, fat: 30.4, sugars: 37.5)
    
    static var todayNutritionData = NutritionData(caloties: 420, protein: 83.2, carborhydrate: 130, fat: 15, sugars: 20)
}
