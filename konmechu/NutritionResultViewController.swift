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
    
    
    
    @IBOutlet weak var kcalLabel: UILabel!
    
    @IBOutlet weak var carbohydrateLabel: UILabel!
    
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var sugarsLabel: UILabel!
    
    
    
    
    
    
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
        
        uploadImage(image: menuImg!) { response in
            print(response ?? "No response received.")
        }
        
        
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
    
    //MARK: - API function
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion("Image data could not be converted to JPEG format.")
            return
        }
        
        let urlString = "https://107c-163-152-3-179.ngrok.io/api/infer"
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
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                            print(json)
                            DispatchQueue.main.async {
                                self.updateLabels(with: json)
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
    }
    
    func updateLabels(with json: [String: String]) {
        menuNameLabel.text = json["식품명"] ?? "알수없음"
        kcalLabel.text = (json["열량(kcal)"]?.isEmpty ?? true) ? "0Kcal" : json["열량(kcal)"]! + "kcal"
        carbohydrateLabel.text = (json["탄수화물(g)"]?.isEmpty ?? true) ? "0g" : json["탄수화물(g)"]! + "g"
        proteinLabel.text = (json["단백질(g)"]?.isEmpty ?? true) ? "0g" : json["단백질(g)"]! + "g"
        fatLabel.text = (json["지방(g)"]?.isEmpty ?? true) ? "0g" : json["지방(g)"]! + "g"
        sugarsLabel.text = (json["당류(g)"]?.isEmpty ?? true) ? "0g" : json["당류(g)"]! + "g"
    }


}
