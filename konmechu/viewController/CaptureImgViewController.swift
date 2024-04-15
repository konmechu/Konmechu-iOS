//
//  CaptureImgViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/28/23.
//

import UIKit

class CaptureImgViewController: UIViewController {
    
    
    @IBOutlet weak private var confirmBtn: UIButton!
    
    
    @IBOutlet weak private var cancelBtn: UIButton!
    
    
    @IBOutlet weak private var capturedImgView: UIImageView!
    
    
    @IBOutlet weak private var morningBtn: UIButton!
    
    
    @IBOutlet weak private var lunchBtn: UIButton!
    
    
    @IBOutlet weak private var dinnerBtn: UIButton!
    
    private var buttons: [UIButton] = []

    public var capturedImg : UIImage?
    
    private var mealTime : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        addAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("DidDismissCaptureImgViewController"), object: nil)
    }
    //MARK: - UI setting function
    private func setUI() {
        buttons.append(morningBtn)
        buttons.append(lunchBtn)
        buttons.append(dinnerBtn)
        
        for button in buttons {
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        }
        
        capturedImgView.layer.cornerRadius = 35
        
        capturedImgView.image = capturedImg
    }
    
    private func addAction() {
        for button in buttons {
            button.addTarget(self, action: #selector(mealBtnAction(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    
    //MARK: - Button action
    
    @IBAction private func confirmBtnDidTap(_ sender: Any) {
        
        performSegue(withIdentifier: "showNutirtionSG", sender: nil)
    }
    
    @IBAction private func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func mealBtnAction(sender: UIButton) {
        for button in buttons {
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.gray, for: .normal)
        }
        
        sender.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.4431372549, blue: 0.168627451, alpha: 1)
        sender.setTitleColor(UIColor.white, for: .normal)
        mealTime = sender.title(for: .normal)
    }
    
    //MARK: - Communication function
    
    
    

    //MARK: - Prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNutirtionSG" {
            let destinationVC = segue.destination as! NutritionResultViewController
            destinationVC.menuImg = capturedImg
            destinationVC.mealTime = MealTime(rawValue: mealTime!)
        }
    }
    
    
   

}
