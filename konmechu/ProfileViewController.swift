//
//  ProfileViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var smartlensBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUILayer()

    }
    

    //MARK: - initial UI setting func
    
    func setUILayer() {
        smartlensBtn.layer.cornerRadius = smartlensBtn.bounds.width / 2
    }
    
    //MARK: - btn acction func
    
    
    @IBAction func smartlensBtnDidTap(_ sender: Any) {
        
    }

}
