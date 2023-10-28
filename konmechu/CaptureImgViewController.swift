//
//  CaptureImgViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/28/23.
//

import UIKit

class CaptureImgViewController: UIViewController {
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBOutlet weak var capturedImgView: UIImageView!
    
    
    @IBOutlet weak var morningBtn: UIButton!
    
    
    @IBOutlet weak var lunchBtn: UIButton!
    
    
    @IBOutlet weak var dinnerBtn: UIButton!
    
    var buttons: [UIButton] = []

    var capturedImg : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    //MARK: - UI setting function
    func setUI() {
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
    
    //MARK: - Button action
    
    
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    

    
    
    
   

}
