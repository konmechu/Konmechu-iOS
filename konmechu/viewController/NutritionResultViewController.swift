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
    
    @IBOutlet weak var natriumView: UIView!
    
    
    
    @IBOutlet weak var kcalLabel: UILabel!
    
    @IBOutlet weak var carbohydrateLabel: UILabel!
    
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var natritumLabel: UILabel!
    
    
    
    @IBOutlet weak var cholesterolTitleLabel: UILabel!
    
    @IBOutlet weak var totalSaturatedFattyAcidsTitleLabel: UILabel!
    
    @IBOutlet weak var totalSugarsTitleLabel: UILabel!
    
    @IBOutlet weak var servingSizeTitleLabel: UILabel!
    
    
    
    @IBOutlet weak var cholesterolLabel: UILabel!
    
    @IBOutlet weak var totalSaturatedFattyAcidsLabel: UILabel!
    
    @IBOutlet weak var totalSugarsLabel: UILabel!
    
    @IBOutlet weak var servingSizeLabel: UILabel!
    
    
    @IBOutlet weak var menuImgView: UIImageView!
    
    @IBOutlet weak var menuImgBaseView: UIView!
    
    @IBOutlet weak var menuNameLabel: UILabel!
    
    
    @IBOutlet weak var modifyFoodNameBtn: UIButton!
    
    @IBOutlet weak var textMainView: UIView!
    
    @IBOutlet weak var foodNameTextField: UITextField!
    
    
    public var menuImg : UIImage?
    
    public var captureType : CaptureType?
    
    public var mealTime : MealTime?
    
    private var nutritionViews: [UIView] = []
    
    
    var tempMenuData : MenuData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.hideKeyboardWhenTappedAround()

        setUI()
        modifyFoodNameBtn.addTarget(self, action: #selector(activateTextField), for: .touchUpInside)

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
        
        if captureType == CaptureType.FOODIMG {
            analysisFoodImage(image: menuImg!) { response in
                print(response ?? "No response received from Ai service server")
            }
        } else if captureType == CaptureType.OCR {
            analysisOCRImage(image: menuImg!) { response in
                    print(response ?? "No response received from GPT")
            }
        } else {
            //음식이름으로 영양성분 분석
        }
        
        
        
        nutritionViews.append(kcalView)
        nutritionViews.append(carbohydrateView)
        nutritionViews.append(proteinView)
        nutritionViews.append(fatView)
        nutritionViews.append(natriumView)
        
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
        
        guard let endPointURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String else {
            print("Error: cannot find key ServerURL in info.plist")
            return
        }
        
        let urlString = "\(String(describing: endPointURL))/app/foods/4" // 실제 엔드포인트 URL로 변경해야 합니다.
        print(urlString)
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
        body.append("Content-Disposition: form-data; name=\"mealImages\"; filename=\"menu.jpg\"\r\n".data(using: .utf8)!)
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
    
    @IBAction func modifyFoodNameBtnDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.textMainView.alpha = 0.8
            self.textMainView.isHidden = false
        })
    }
    
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        menuNameLabel.text = foodNameTextField.text
        UIView.animate(withDuration: 0.2, animations: {
            self.textMainView.alpha = 0
            self.textMainView.isHidden = true
        })
    }
    
    @IBAction func textViewDismissBtnDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.textMainView.alpha = 0
            self.textMainView.isHidden = true
        })
    }
    
    //MARK: - API function
    func analysisFoodImage(image: UIImage, completion: @escaping (String?) -> Void) {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GptKey") as? String else {
            print("Error: cannot find key GptKey in info.plist")
            return
        }
        
        guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "GptURL") as? String else {
            print("Error: cannot find key GptKey in info.plist")
            return
        }
                        
        let prompt = "사진의 식사명(음식명)을 json형태의 데이터로 나타내. '식품명' 이라는 키 값에 String형식의 value를 넣어 json 형태 데이터로 응답받을거야 키값은 항상 내가 적은 것과 동일해야해, json데이터 외에 다른 말은 하지 마"
        
        guard let base64Image = encodeImage(image: image) else {
            print("failed to encode image to base64")
            return
        }
        
    
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let payload: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "\(prompt)"
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 300
        ]

        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }
            
            if let foodName = self.parseContentFromFoonNameResponse(data) {
                DispatchQueue.main.async{
                    self.updateLabels(with: foodName)
                    
                }
                
                } else {
                    print("Failed to parse and update labels")
                    
                }
        }

        task.resume()
//        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
//            completion("Image data could not be converted to JPEG format.")
//            return
//        }
//        
//
//        guard let endPointURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String else {
//            print("Error: cannot find key ServerURL in info.plist")
//            return
//        }
//        
//        let urlString = "\(endPointURL)/api/infer"
//
//        guard let url = URL(string: urlString) else {
//            completion("Invalid URL.")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        // Multipart/form-data boundary and header
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        // Create multipart/form-data body
//        var body = Data()
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"uploaded_image.jpg\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        body.append(imageData)
//        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        // Attach body to request
//        request.httpBody = body
//        
//        // Send the request
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion("Error: \(error.localizedDescription)")
//                    return
//                }
//                
//                if let data = data {
//                    do {
//                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
//                            print(json)
//                            DispatchQueue.main.async {
//                                self.updateLabels(with: json)
//                            }
//                        }
//                    } catch {
//                        print("Error parsing JSON: \(error.localizedDescription)")
//                    }
//                }
//            }
//            task.resume()
        
    }
    
    
    func analysisOCRImage(image: UIImage, completion: @escaping (String?) -> Void) {
                
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GptKey") as? String else {
            print("Error: cannot find key GptKey in info.plist")
            return
        }
        
        guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "GptURL") as? String else {
            print("Error: cannot find key GptKey in info.plist")
            return
        }
                        
        let prompt = "영양성분표에 있는 영양성분을 json형태의 데이터로 나타내. 다음과 같은 키값에: 열량(kcal), 탄수화물(g), 단백질(g), 지방(g), 나트륨(mg), 콜레스테롤(mg), 총포화지방산(g), 총당류(g), 1회제공량(g) Float형식의 value를 넣어 json 형태 데이터로 응답받을거야 키값은 항상 내가 적은 것과 동일해야해 ()포함, 모든 영양성분과 열량(kcal)은 1회 제공량 기준이야. json데이터 외에 다른 말은 하지 마"
        
        guard let base64Image = encodeImage(image: image) else {
            print("failed to encode image to base64")
            return
        }
        
    
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let payload: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "\(prompt)"
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 300
        ]

        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }
            
            if let nutrientInfo = self.parseContentFromOCRResponse(data) {
                DispatchQueue.main.async{
                    self.updateLabels(with: nutrientInfo)
                    
                }
                
                } else {
                    print("Failed to parse and update labels")
                    
                }
        }

        task.resume()
    }
    //MARK: - util function
    
    @objc func activateTextField() {
            foodNameTextField.becomeFirstResponder()
        }
    
    //MARK: - util functions for api
    
    func encodeImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            print("Image data could not be converted to JPEG format.")
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    func parseContentFromOCRResponse(_ data: Data) -> [String: String]? {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = jsonObject["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                let jsonString = content
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let nutrientData = jsonString.data(using: .utf8),
                   let nutrientObject = try JSONSerialization.jsonObject(with: nutrientData, options: []) as? [String: Any] {
                    
                    var stringDictionary = [String: String]()
                    for (key, value) in nutrientObject {
                        stringDictionary[key] = "\(value)"
                    }
                    print(stringDictionary)
                    return stringDictionary
                }
            }
        } catch {
            print("Failed to parse JSON: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func parseContentFromFoonNameResponse(_ data: Data) -> [String: String]? {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = jsonObject["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                let jsonString = content
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let nutrientData = jsonString.data(using: .utf8),
                   let nutrientObject = try JSONSerialization.jsonObject(with: nutrientData, options: []) as? [String: Any] {
                    
                    var stringDictionary = [String: String]()
                    for (key, value) in nutrientObject {
                        stringDictionary[key] = "\(value)"
                    }
                    print(stringDictionary)
                    return stringDictionary
                }
            }
        } catch {
            print("Failed to parse JSON: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func updateLabels(with json: [String: String]) {
        
        menuNameLabel.text = json["식품명"] ?? "알수없음"
        kcalLabel.text = (json["열량(kcal)"]?.isEmpty ?? true) ? "0kcal" : json["열량(kcal)"]! + "Kcal"
        carbohydrateLabel.text = (json["탄수화물(g)"]?.isEmpty ?? true) ? "0g" : json["탄수화물(g)"]! + "g"
        proteinLabel.text = (json["단백질(g)"]?.isEmpty ?? true) ? "0g" : json["단백질(g)"]! + "g"
        fatLabel.text = (json["지방(g)"]?.isEmpty ?? true) ? "0g" : json["지방(g)"]! + "g"
        natritumLabel.text = (json["나트륨(mg)"]?.isEmpty ?? true) ? "0mg" : json["나트륨(mg)"]! + "mg"
        
        cholesterolLabel.text = (json["콜레스테롤(mg)"]?.isEmpty ?? true) ? "0mg" : json["콜레스테롤(mg)"]! + "mg"
        totalSaturatedFattyAcidsLabel.text = (json["총포화지방산(g)"]?.isEmpty ?? true) ? "0g" : json["총포화지방산(g)"]! + "g"
        totalSugarsLabel.text = (json["총당류(g)"]?.isEmpty ?? true) ? "0g" : json["총당류(g)"]! + "g"
        servingSizeLabel.text = (json["1회제공량(g)"]?.isEmpty ?? true) ? "0g" : json["1회제공량(g)"]! + "g"

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
        let natrium = Float(natritumLabel.text?.replacingOccurrences(of: "mg", with: "") ?? "0") ?? 0
        
        let cholesterol = Float(cholesterolLabel.text?.replacingOccurrences(of: "mg", with: "") ?? "0") ?? 0
        let totalSaturatedFattyAcids = Float(totalSaturatedFattyAcidsLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0
        let totalSugar = Float(totalSugarsLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0
        let servingSize = Float(servingSizeLabel.text?.replacingOccurrences(of: "g", with: "") ?? "0") ?? 0

        
        // Dictionary로 메뉴 세부 정보 구성
        let menuDetails: [String: Any] = [
            "name": food,
            "meal_time": meal,
            "calories": calories,
            "protein": protein,
            "fat": fat,
            "carbohydrate": carbs,
            "sodium": natrium,
            "total_cholesterol": cholesterol,
            "total_saturated_fat" : totalSaturatedFattyAcids,
            "total_sugar": totalSugar,
            "serving_unit": servingSize,
            "field": "OCR"
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


