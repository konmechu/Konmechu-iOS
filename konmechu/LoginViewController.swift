//
//  LoginViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    
    
    @IBOutlet weak var emailLoginBtn: UIButton!
    
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var helpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUILayer()

    }
    
    //MARK: - initial UI setting func
    
    func setUILayer () {
        kakaoLoginBtn.layer.cornerRadius = kakaoLoginBtn.bounds.width / 2
        googleLoginBtn.layer.cornerRadius = googleLoginBtn.bounds.width / 2
        
        emailLoginBtn.layer.cornerRadius = 8
        emailLoginBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        emailLoginBtn.backgroundColor = emailLoginBtn.backgroundColor?.withAlphaComponent(0.2)
    }
    
    //MARK: - button action func
    
    //test
    @IBAction func emailLoginBtnDidTap(_ sender: Any) {
        performSegue(withIdentifier: "LoginSuccessSG", sender: nil)
    }
    
    
    //MARK: - Seague func

    

}
