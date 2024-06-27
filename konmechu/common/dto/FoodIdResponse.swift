//
//  FoodIdResponse.swift
//  konmechu
//
//  Created by 정재연 on 6/27/24.
//

import Foundation

struct FoodIdResponse: Decodable {
    let foodId: Int
    let foodName: String
    let calories: Float
    let protein: Float
    let fat: Float
    let carbohydrate: Float
    let sodium: Float
    let totalCholesterol: Float
    let totalSaturatedFat: Float
    let totalSugars: Float
    let servingUnit: Float
    
    enum CodingKeys: String, CodingKey {
        case foodId = "meun_id"
        case foodName = "matched_food_name"
        case calories = "calories"
        case protein = "protein"
        case fat = "fat"
        case carbohydrate = "carbohydrate"
        case sodium = "sodium"
        case totalCholesterol = "total_cholesterol"
        case totalSaturatedFat = "total_saturatedFat"
        case totalSugars = "total_sugars"
        case servingUnit = "serving_unit"
    }
}

let dummyFoodIdResponseJsonString = """
{
    "menu_id": 123,
    "matched_food_name": "비빔밥"
}
"""
