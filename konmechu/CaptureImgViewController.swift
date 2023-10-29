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
        print("wow\n\n\n\n")
        uploadImage(image: capturedImg!) { response in
            print(response ?? "No response received.")
        }
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
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion("Image data could not be converted to JPEG format.")
            return
        }
        
        let urlString = "https://98e4-121-130-156-219.ngrok.io/api/infer"
        guard let url = URL(string: urlString) else {
            completion("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Multipart/form-data boundary and header
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create multipart/form-data body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"uploaded_image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Attach body to request
        request.httpBody = body
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let foodName = json["Food Name"] as? String {
                        print(foodName)  // 출력: 보쌈
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
            
//            if let data = data, let responseString = String(data: data, encoding: .utf8) {
//                completion(responseString)
//            } else {
//                completion("Unknown error.")
//            }
        }
        task.resume()
    }
    
    

    //MARK: - Prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNutirtionSG" {
            let destinationVC = segue.destination as! NutritionResultViewController
            destinationVC.menuImg = capturedImg
        }
    }
    
    
   

}
