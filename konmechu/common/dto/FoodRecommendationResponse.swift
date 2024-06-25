//
//  FoodRecommendationResponse.swift
//  konmechu
//
//  Created by 정재연 on 6/4/24.
//

import Foundation

// Ingredients 구조체 정의
struct Ingredients: Decodable {
    let foodName: String
    
    enum CodingKeys: String, CodingKey {
        case foodName = "식품명"
    }
}

// RecommendedFood 구조체 정의
struct RecommendedFood: Decodable {
    let foodName: String
    let ingredients: Ingredients
    
    enum CodingKeys: String, CodingKey {
        case foodName = "식품명"
        case ingredients
    }
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
    "식품명": "비빔밥",
    "ingredients": {
      "식품명": "비빔밥"
    }
  }
}
"""
