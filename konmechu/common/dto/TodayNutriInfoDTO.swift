//
//  TodayNutriInfoDTO.swift
//  konmechu
//
//  Created by 정재연 on 11/14/23.
//

import Foundation

// Nutrition 정보를 위한 클래스
class TotalNutritionResponseDto: Codable {
    var totalCalories: Double
    var totalProtein: Double
    var totalFat: Double
    var totalCarbs: Double
    var totalNatrium: Double
    
    var totalCholesterol: Double
    var totalSaturatedFattyAcids: Double
    var totalSugars: Double
    
    enum CodingKeys: String, CodingKey {
        case totalCalories = "totalCalories"
        case totalProtein = "totalProtein"
        case totalFat = "totalFat"
        case totalCarbs = "totalCarbs"
        case totalNatrium = "totalNatrium"
        
        case totalCholesterol = "totalCholesterol"
        case totalSaturatedFattyAcids = "totalSaturatedFattyAcids"
        case totalSugars = "totalSugars"

    }
}

// 메뉴 정보를 위한 클래스
class MenuResponseDto: Codable {
    var menuId: Int
    var food: String
    var meal: String
    var menuImageUrls: [String]
    var isThumbsUp: Bool
    
    enum CodingKeys: String, CodingKey {
        case menuId = "menuId"
        case food = "food"
        case meal = "meal"
        case menuImageUrls = "menuImageUrls"
        case isThumbsUp = "isThumbsUp"
    }
}

// 전체 응답을 위한 클래스
class NutritionInfoResponse: Codable {
    var totalNutritionResponseDto: TotalNutritionResponseDto
    var menuResponseDtos: [MenuResponseDto]
    
    enum CodingKeys: String, CodingKey {
        case totalNutritionResponseDto = "totalNutritionResponseDto"
        case menuResponseDtos = "menuResponseDtos"
    }
}

struct ResponseWrapper: Codable {
    var result: NutritionInfoResponse
    // 필요한 경우 여기에 다른 최상위 레벨 키를 추가할 수 있습니다.
}
