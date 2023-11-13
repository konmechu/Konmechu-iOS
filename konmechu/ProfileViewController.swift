//
//  ProfileViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userGenderButton: UIButton!
    
    @IBOutlet weak var userNameButton: UIButton!
    
    @IBOutlet weak var userHeightButton: UIButton!
    
    @IBOutlet weak var userWeightButton: UIButton!

    
    @IBOutlet weak var userProfileStackView: UIStackView!
    
    
    @IBOutlet weak var logoutBaseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUILayer()

    }
    

    //MARK: - initial UI setting func
    
    func setUILayer() {
        
        logoutBaseView.backgroundColor = .clear
        
        for subView in userProfileStackView.subviews {
            subView.layer.cornerRadius = 10
            subView.backgroundColor = .clear
        }
        
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.width / 2
        
        
        
        let defaults = UserDefaults.standard
        
        if let userProfilePicURLString = defaults.string(forKey: "profilePicUrl") {
            
            // URL로 변환하여 사용할 수 있습니다.
            if let userProfilePicURL = URL(string: userProfilePicURLString) {
                
                // URLSession을 사용하여 이미지를 다운로드합니다.
                let task = URLSession.shared.dataTask(with: userProfilePicURL) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        
//                        let imageSize = CGSize(width: 100, height: 100)
//                        let resizedImage = image.resize(targetSize: imageSize)
                        
                        DispatchQueue.main.async {
                            self.profileImageView.image = image
                            self.view.layoutIfNeeded()
                        }
                        
                    } else {
                        print("Error downloading image: \(String(describing: error))")
                    }
                }
                
                task.resume()
            }
        }
        
        if let userEmailAddress = defaults.string(forKey: "emailAddress") {
            DispatchQueue.main.async {
                self.userEmailLabel.text = userEmailAddress
                self.view.layoutIfNeeded()
            }
        }
        
        if let userName = defaults.string(forKey: "name") {
            DispatchQueue.main.async {
                self.userNameButton.setTitle(userName, for: .normal)
                self.view.layoutIfNeeded()
            }
        }
        
        
    }
    
    //MARK: - btn acction func
    
    
    @IBAction func loggoutBtnDidTap(_ sender: Any) {
        
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
        
        
        
    }
    
    
}
