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
    
    public var mealTime : MealTime?
    
    private var nutritionViews: [UIView] = []
    
    
    var tempMenuData : MenuData?
    
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
        tempMenuData = MenuData(title: "베이글", image: "nil", mealTime: mealTime!, uiImage: menuImg)
        
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
        // 데이터와 이미지를 서버에 업로드하는 코드 작성
            guard let imageData = menuImg?.jpegData(compressionQuality: 0.9),
                  let requestDto = createRequestDto() else {
                print("Invalid data or image")
                return
            }
            
            let endPointURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String
        let urlString = "\(String(describing: endPointURL))/app/menus" // 실제 엔드포인트 URL로 변경해야 합니다.
            guard let url = URL(string: urlString) else {
                print("Invalid URL.")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Multipart/form-data boundary and header 설정
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // Create multipart/form-data body
            var body = Data()
            
            // 이미지 부분
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"menuImages\"; filename=\"menu.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            
            // JSON 데이터 부분
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"requestDto\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(requestDto)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            // Attach body to request
            request.httpBody = body
            
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check for successful response, etc...
                // ...
            }
            task.resume()
    }
    
    
    
    //MARK: - API function
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion("Image data could not be converted to JPEG format.")
            return
        }
        

        guard let endPointURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String else {
            print("Error: cannot find key ServerURL in info.plist")
            return
        }
        
        let urlString = "\(endPointURL)/api/infer"

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
        kcalLabel.text = (json["열량(kcal)"]?.isEmpty ?? true) ? "0kcal" : json["열량(kcal)"]! + "Kcal"
        carbohydrateLabel.text = (json["탄수화물(g)"]?.isEmpty ?? true) ? "0g" : json["탄수화물(g)"]! + "g"
        proteinLabel.text = (json["단백질(g)"]?.isEmpty ?? true) ? "0g" : json["단백질(g)"]! + "g"
        fatLabel.text = (json["지방(g)"]?.isEmpty ?? true) ? "0g" : json["지방(g)"]! + "g"
        sugarsLabel.text = (json["당류(g)"]?.isEmpty ?? true) ? "0g" : json["당류(g)"]! + "g"
        
    }
    
    // app server 에 저장할 RequestDto JSON 데이터 생성
    func createRequestDto() -> Data? {
        // 라벨에서 텍스트를 추출하고 적절한 타입으로 변환합니다.
        let food = menuNameLabel.text ?? "Unknown"
        let meal = mealTime?.rawValue ?? "아침" // mealTime을 기반으로 "아침", "점심", "저녁" 중 하나를 설정해야 할 수도 있습니다.
        let calories = Float(kcalLabel.text?.replacingOccurrences(of: "kcal", with: "") ?? "0") ?? 0
        let protein = Float(proteinLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0
        let fat = Float(fatLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0
        let carbs = Float(carbohydrateLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0
        let fiber = Float(sugarsLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0
        
        // Dictionary로 메뉴 세부 정보 구성
        let menuDetails: [String: Any] = [
            "food": food,
            "meal": meal,
            "calories": calories,
            "protein": protein,
            "fat": fat,
            "carbs": carbs,
            "fiber": fiber
        ]
        
        // Dictionary를 JSON Data로 변환
        do {
            return try JSONSerialization.data(withJSONObject: menuDetails, options: [])
        } catch {
            print("Error creating JSON data: \(error)")
            return nil
        }
    }


}


