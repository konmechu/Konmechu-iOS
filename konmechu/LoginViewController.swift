//
//  LoginViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import KakaoSDKUser


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
        kakaoLoginBtn.layer.cornerRadius = 8
        
        emailLoginBtn.layer.cornerRadius = 8
        emailLoginBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        emailLoginBtn.backgroundColor = emailLoginBtn.backgroundColor?.withAlphaComponent(0.2)
    }
    
    //MARK: - button action func
    
    //test
    @IBAction func emailLoginBtnDidTap(_ sender: Any) {
        performSegue(withIdentifier: "LoginSuccessSG", sender: nil)
    }
    
    
    @IBAction func kakaoLoginBtnDidTap(_ sender: Any) {
        
        doKakaoSocialLogin()
    }
    
    //MARK: - kakao Social Login
    private func doKakaoSocialLogin() {

        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
            if let error = error {
                print(error)
                return
            }
            guard let strongSelf = self, let token = oauthToken?.accessToken else {
                print("Error: OAuth token is not available")
                return
            }

            // API endpoint
            let urlString = "https://d6f7-121-130-156-219.ngrok-free.app/app/oauth/kakao" // '???'를 실제 엔드포인트 주소로 대체해야 합니다.
            guard let url = URL(string: urlString) else {
                print("Error: cannot create URL")
                return
            }

            // 발급받은 access token
            let accessToken = AccessToken(accessToken: token)

            // URLRequest 생성
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // JSON으로 인코딩
            do {
                let jsonData = try JSONEncoder().encode(accessToken)
                request.httpBody = jsonData
            } catch {
                print("Error: Encoding error")
                return
            }

            // 컨텐트 타입을 application/json으로 설정
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 사용한 HTTP 요청
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                // 에러 체크
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                // 응답 처리
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                    if let data = data {
                        // 서버로부터 받은 응답 데이터 처리
                        let responseString = String(data: data, encoding: .utf8)
                        print("Response String: \(String(describing: responseString))")
                    }
                }
            }

            // 요청 시작
            task.resume()
            self!.performSegue(withIdentifier: "LoginSuccessSG", sender: nil)

        }
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else {
                print("me() success.")
                
                let emailAddress = user?.kakaoAccount?.email
                let fullName = user?.kakaoAccount?.name
                let profilePicUrl = user?.kakaoAccount?.profile?.profileImageUrl
                
                let defaults = UserDefaults.standard
                
                defaults.set(emailAddress, forKey: "emailAddress")
                defaults.set(profilePicUrl?.absoluteString, forKey: "profilePicUrl")
                defaults.set(fullName, forKey: "name")
                
            }}
        
    }
    
    struct AccessToken: Codable {
        let accessToken: String
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? LoginViewController {
           
        }
    }

}
