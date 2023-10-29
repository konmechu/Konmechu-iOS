//
//  NutritionResultViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/29/23.
//

import UIKit

class NutritionResultViewController: UIViewController {
    
    
    @IBOutlet weak var nutritionBaseView: UIView!
    
    @IBOutlet weak var kcalView: UIView!
    
    @IBOutlet weak var carbohydrateView: UIView!
    
    @IBOutlet weak var proteinView: UIView!
    
    @IBOutlet weak var fatView: UIView!
    
    @IBOutlet weak var sugarsView: UIView!
    
    private var nutritionViews: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        
        nutritionBaseView.layer.cornerRadius = 20
        
        nutritionViews.append(kcalView)
        nutritionViews.append(carbohydrateView)
        nutritionViews.append(proteinView)
        nutritionViews.append(fatView)
        nutritionViews.append(sugarsView)
        
        for view in nutritionViews {
            view.layer.cornerRadius = view.layer.bounds.width / 2
        }
    }

   

}
