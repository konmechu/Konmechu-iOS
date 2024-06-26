//
//  FoodRecommendationResponse.swift
//  konmechu
//
//  Created by 정재연 on 6/4/24.
//

import Foundation

// Ingredients 구조체 정의
struct FoodItem: Decodable {
    let name: String
    let reason: String
}

// RecommendedFood 구조체 정의
struct RecommendedFood: Decodable {
    let food1: FoodItem
    let food2: FoodItem
    let food3: FoodItem
}

// Root 구조체 정의
struct Root: Decodable {
    let recommendedFood: RecommendedFood
    
    enum CodingKeys: String, CodingKey {
        case recommendedFood = "recommended_food"
    }
}

let dummyRecoData = """
{
    "recommended_food": {
        "food1": {
            "name": "보꼬네불고기피자",
            "reason": "취향 유사도 상위 2.00%에 속하는 보꼬네불고기피자을(를) 추천드립니다. 지방(g)이(가) 목표치와 유사합니다. \n(음식: 9.00, 목표: 11.50)"
        },
        "food2": {
            "name": "솔티 파네토네 트러플",
            "reason": "취향 유사도 상위 4.00%에 속하는 솔티 파네토네 트러플을(를) 추천드립니다. 단백질(g)이(가) 목표치와 유사합니다. \n(음식: 6.50, 목표: 6.00)"
        },
        "food3": {
            "name": "5일동안 생들기름",
            "reason": "새로운 맛을 경험해보실 수 있는 5일동안 생들기름을(를) 추천드립니다. 지방(g)이(가) 목표치와 유사합니다. \n(음식: 8.22, 목표: 11.50)"
        }
    }
}
"""
