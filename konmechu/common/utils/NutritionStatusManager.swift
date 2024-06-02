//
//  NutritionStatusManager.swift
//  konmechu
//
//  Created by 정재연 on 11/14/23.
//

import UIKit

class NutritionStatusManager {

    //탄:130, 단:70, 지"51 -> 성인 70kg 적정섭취
    private struct NutritionLimits {
        static let caloriesProper = (2080.0...3120.0) // 80-120% of 2600
        static let carbsProper = (104.0...140.0)      // 80-120% of 55-65% of daily intake
        static let proteinProper = (56.0...90.0)     // 80-120% of 10-20% of daily intake
        static let fatProper = (41.0...61.0)      // 80-120% of 20-30% of daily intake
        static let sugarsProper = (0.0...65.0)       // Up to 10% of daily intake
    }
    
    private var totalNutritionInfo: TotalNutritionResponseDto
    
    // Define the outlets
    private var kcalView: UIView
    private var carbohydrateView: UIView
    private var proteinView: UIView
    private var fatView: UIView
    private var sugarsView: UIView
    
    private var isKcalProperLabel: UILabel
    private var isCarboProperLabel: UILabel
    private var isProteinProperLabel: UILabel
    private var isFatProperLabel: UILabel
    private var isSugarsProperLabel: UILabel
    
    // Initialize with outlets
    init(totalNutritionInfo: TotalNutritionResponseDto, kcalView: UIView, carbohydrateView: UIView, proteinView: UIView, fatView: UIView, sugarsView: UIView, isKcalProperLabel: UILabel, isCarboProperLabel: UILabel, isProteinProperLabel: UILabel, isFatProperLabel: UILabel, isSugarsProperLabel: UILabel) {
        self.totalNutritionInfo = totalNutritionInfo
        self.kcalView = kcalView
        self.carbohydrateView = carbohydrateView
        self.proteinView = proteinView
        self.fatView = fatView
        self.sugarsView = sugarsView
        self.isKcalProperLabel = isKcalProperLabel
        self.isCarboProperLabel = isCarboProperLabel
        self.isProteinProperLabel = isProteinProperLabel
        self.isFatProperLabel = isFatProperLabel
        self.isSugarsProperLabel = isSugarsProperLabel
    }
    
    // Function to update the UI
    func updateNutritionStatus() {
        DispatchQueue.main.async {
            // Update the views and labels based on the nutritional info
            self.updateView(self.kcalView, andLabel: self.isKcalProperLabel, withValue: self.totalNutritionInfo.totalCalories * 4, properRange: NutritionLimits.caloriesProper)
            self.updateView(self.carbohydrateView, andLabel: self.isCarboProperLabel, withValue: self.totalNutritionInfo.totalCarbs * 4, properRange: NutritionLimits.carbsProper)
            self.updateView(self.proteinView, andLabel: self.isProteinProperLabel, withValue: self.totalNutritionInfo.totalProtein * 4, properRange: NutritionLimits.proteinProper)
            self.updateView(self.fatView, andLabel: self.isFatProperLabel, withValue: self.totalNutritionInfo.totalFat * 4, properRange: NutritionLimits.fatProper)
            self.updateView(self.sugarsView, andLabel: self.isSugarsProperLabel, withValue: self.totalNutritionInfo.totalNatrium * 4, properRange: NutritionLimits.sugarsProper)
        }
    }
    
    // Helper function to update the view and label colors based on the value and range
    private func updateView(_ view: UIView, andLabel label: UILabel, withValue value: Double, properRange: ClosedRange<Double>) {
        let color: UIColor
        let text: String
        if properRange.contains(value) {
            color = UIColor(hex: "#51CE5D") // Green for proper
            text = "적절"
        } else if value < properRange.lowerBound {
            color = UIColor(hex: "#FFE815") // Yellow for deficient
            text = "부족"
        } else {
            color = UIColor(hex: "#FF8B8B") // Red for excess
            text = "과잉"
        }
        
        view.layer.borderColor = color.cgColor
        view.backgroundColor = color.withAlphaComponent(0.2)
        label.textColor = color
        label.text = text
    }
}

// Extension to handle hex color creation
extension UIColor {
   convenience init(hex: String) {
       let scanner = Scanner(string: hex)
       scanner.scanLocation = 1  // bypass '#' character
       var rgbValue: UInt64 = 0
       scanner.scanHexInt64(&rgbValue)
       let r = (rgbValue & 0xff0000) >> 16
       let g = (rgbValue & 0xff00) >> 8
       let b = rgbValue & 0xff
       self.init(
           red: CGFloat(r) / 0xff,
           green: CGFloat(g) / 0xff,
           blue: CGFloat(b) / 0xff, alpha: 1
       )
   }
}

