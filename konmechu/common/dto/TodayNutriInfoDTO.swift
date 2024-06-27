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
    var totalSodium: Double
    
    var totalCholesterol: Double
    var totalSaturatedFat: Double
    var totalSugars: Double
    
    enum CodingKeys: String, CodingKey {
        case totalCalories = "totalCalories"
        case totalProtein = "totalProtein"
        case totalFat = "totalFat"
        case totalCarbs = "totalCarbohydrate"
        case totalSodium = "totalSodium"
        
        case totalCholesterol = "totalCholesterol"
        case totalSaturatedFat = "totalSaturatedFat"
        case totalSugars = "totalSugars"

    }
}

// 메뉴 정보를 위한 클래스
class MenuResponseDto: Codable {
    var menuId: Int
    var food: String
    var meal: String
    var mealImagesUrls: [String]
    var isThumbsUp: String
    
    enum CodingKeys: String, CodingKey {
        case menuId = "mealId"
        case food = "food"
        case meal = "meal"
        case mealImagesUrls = "mealImagesUrls"
        case isThumbsUp = "isThumbsUp"
    }
}

// 전체 응답을 위한 클래스
class NutritionInfoResponse: Codable {
    var totalNutritionResponseDto: TotalNutritionResponseDto
    var menuResponseDtos: [MenuResponseDto]
    
    enum CodingKeys: String, CodingKey {
        case totalNutritionResponseDto = "totalNutritionResponseDto"
        case menuResponseDtos = "mealResponseDtos"
    }
}

struct ResponseWrapper: Codable {
    var result: NutritionInfoResponse
    // 필요한 경우 여기에 다른 최상위 레벨 키를 추가할 수 있습니다.
}

let dummyNutritionJsonString = """
{
  "result": {
    "totalNutritionResponseDto": {
      "totalCalories": 1800,
      "totalProtein": 103.0,
      "totalFat": 50,
      "totalCarbs": 120,
      "totalSodium": 2,
      "totalCholesterol": 0.2,
      "totalSaturatedFat": 16.7,
      "totalSugars": 120
    },
    "menuResponseDtos": [
      {
        "menuId": 1,
        "food": "치킨샐러드",
        "meal": "점심",
        "mealImagesUrls": [
          "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTEyMjdfMTYx%2FMDAxNjQwNjEyNzU5NTcw.e52p3HPU4cLRtVpVVcCFaexgmxgKyChnCq9V1AzGJksg.VuN1RZm2G26dH3DJEzHLMB6Ccn49UZeDJMitiRI3xMog.JPEG.art_bunny%2Fpb06.jpg&type=sc960_832"
        ],
        "isThumbsUp": true
      },
      {
        "menuId": 2,
        "food": "사과",
        "meal": "아침",
        "mealImagesUrls": [
          "https://img.freepik.com/free-photo/delicious-red-apples-in-studio_23-2150811013.jpg"
        ],
        "isThumbsUp": false
      },
      {
        "menuId": 3,
        "food": "스테이크",
        "meal": "저녁",
        "mealImagesUrls": [
          "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDA0MjFfMjA4%2FMDAxNzEzNjI3MzI5NjQw.lYf84doHgHVdLQ9jxLcgWWQ7syi4PU1agx2Nu80gkbEg.ST2k54zlJX2S2pwPu7vyHaD8paRuPbAQGFI4rHYi4Hsg.JPEG%2FIMG_20240418_194458.jpg&type=sc960_832"
        ],
        "isThumbsUp": false
      },
      {
        "menuId": 4,
        "food": "펜케이크",
        "meal": "아침",
        "mealImagesUrls": [
          "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjEwMDZfMjI4%2FMDAxNjY1MDY3ODczNTI3.eObnxRYMsWly_gR-wzDS-jGsf5oLpBLKEyUplSmEkcYg.MxbBQhy77mPFJoSOvaDl6xxTdEiLmLlmsZEVDcxf9CEg.JPEG.ji2313go%2FScreenshot%25A3%25DF20221006%25A3%25AD233746%25A3%25DFChrome.jpg&type=sc960_832"
        ],
        "isThumbsUp": true
      }
    ]
  }
}
"""
