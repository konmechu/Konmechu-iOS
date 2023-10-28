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
    
    @IBAction func confirmBtnDidTap(_ sender: Any) {
        print("wow\n\n\n\n")
        uploadImage(image: capturedImg!) { response in
            print(response ?? "No response received.")
        }
    }
    
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true)
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
    
    

    
    
    
   

}
