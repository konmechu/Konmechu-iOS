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
    
    @IBOutlet weak var menuImgView: UIImageView!
    
    @IBOutlet weak var menuImgBaseView: UIView!
    
    @IBOutlet weak var menuNameLabel: UILabel!
    
    public var menuImg : UIImage?
    
    private var nutritionViews: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        
        menuImgBaseView.backgroundColor = menuImgBaseView.backgroundColor?.withAlphaComponent(0.2)
        menuImgBaseView.layer.cornerRadius = 20
        menuImgBaseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuImgBaseView.layer.shadowOpacity = 0.7
        
        
        nutritionBaseView.layer.cornerRadius = 20
        
        nutritionBaseView.backgroundColor = nutritionBaseView.backgroundColor?.withAlphaComponent(0.2)
        
        nutritionBaseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        nutritionBaseView.layer.shadowOpacity = 0.7
        
        menuImgView.layer.cornerRadius = 20
        menuImgView.contentMode = .scaleAspectFill
        menuImgView.image = menuImg
        
        
        nutritionViews.append(kcalView)
        nutritionViews.append(carbohydrateView)
        nutritionViews.append(proteinView)
        nutritionViews.append(fatView)
        nutritionViews.append(sugarsView)
        
        for view in nutritionViews {
            view.layer.cornerRadius = view.layer.bounds.width / 2
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.2)
            view.layer.borderWidth = 2
            view.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.8078431373, blue: 0.3647058824, alpha: 1)

        }
    }
    
    //MARK: - button Action function
    

    @IBAction func calcelBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func saveMealBtnDidTap(_ sender: Any) {
    }
    

}
