//
//  NutritionStatisticsViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import FSCalendar

class NutritionStatisticsViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Table view Data var
    
    var menuSections : [MenuSection] = []
        
    
    //MARK: - Calendar var
    
    
    @IBOutlet weak var calendarStackView: UIStackView!
    
    @IBOutlet weak var dayIdxBtn: UIButton!
    
    @IBOutlet weak var FSCalendarView: FSCalendar!
    
    private var dateFormatter : DateFormatter?
        
    
    //MARK: - Nutritioin info var
    
    
    @IBOutlet weak var nutritionBaseStackView: UIStackView!
    
    @IBOutlet weak var nutritionBaseView: UIView!
    
    
    
    @IBOutlet weak var nutritionAppendBtn: UIButton!
    
    @IBOutlet weak var nutritionAppendStatusLabel: UILabel!
    
    
    @IBOutlet weak var kcalView: UIView!
    
    @IBOutlet weak var carbohydrateView: UIView!
    
    @IBOutlet weak var proteinView: UIView!
    
    @IBOutlet weak var fatView: UIView!
    
    @IBOutlet weak var natriumView: UIView!
    
    
    @IBOutlet weak var isKcalProperLabel: UILabel!
    
    @IBOutlet weak var isCarboProperLabel: UILabel!
    
    @IBOutlet weak var isProteinProperLabel: UILabel!
    
    @IBOutlet weak var isFatProperLabel: UILabel!
    
    @IBOutlet weak var isNatriumProperLabel: UILabel!
    
    
    
    @IBOutlet weak var kcalLabel: UILabel!
    
    @IBOutlet weak var carbohydrateLabel: UILabel!
    
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var natriumLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var nutritionDetailView: UIView!
    
    
    @IBOutlet weak var cholesterolTitleLabel: UILabel!
    
    @IBOutlet weak var totalSaturatedFattyAcidsTitleLabel: UILabel!
    
    @IBOutlet weak var totalSugarsTitleLabel: UILabel!
    
    
    @IBOutlet weak var cholesterolLabel: UILabel!
    
    @IBOutlet weak var totalSaturatedFattyAcidsLabel: UILabel!
    
    @IBOutlet weak var totalSugarsLabel: UILabel!
    
    private var nutritionDetailViews: [UILabel] = []
    
    
    private var nutritionViews: [UIView] = []
    
    private var totalNutritionInfo : TotalNutritionResponseDto?
    
    
    var nutritionStatusManager: NutritionStatusManager?
        
    //MARK: - menu Recommendation View
    
    
    @IBOutlet weak var recommendationStackView: UIStackView!
    
    
    @IBOutlet weak var recoAppendBtn: UIButton!
    
    
    @IBOutlet weak var recoTextView: UITextView!
    
    
    @IBOutlet weak var recoAppendTextLabel: UILabel!
    
    
    private var recommendationSubViews: [UIView] = []
    
    
    //MARK: - menu list table view
    
    
    @IBOutlet weak var tableBaseView: UIStackView!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var menuTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuListAppendBtn: UIButton!
    
    @IBOutlet weak var menulistAppendTextLabel: UILabel!
    
    private var menuList : [MenuResponseDto] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTodayNutriInfo(for: Date(), completion: {_ in })

        
        setCalendar()
        setUI()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTodayNutriInfo(for: Date(), completion: {_ in })

        setTableViewHeight()
    }
    
    //MARK: - API function
    
    func getTodayNutriInfo(for date: Date, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        // URL 설정, 여기서는 예시 URL을 사용합니다.
        // 실제 요청할 서버의 URL로 교체해야 합니다.
        guard let endPointURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String else {
            return
        }
        
        let urlString = "\(endPointURL)/app/menus?startDate=\(dateString)&endDate=\(dateString)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL\(urlString)fuck")
            return
        }

        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        // URLSession을 사용한 HTTP 요청
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [self] data, response, error in
            // 에러 체크
            if let error = error {
                print("Error: \(error)")
                return
            }

            // 응답 체크
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let mimeType = httpResponse.mimeType,
                  mimeType == "application/json",
                  let data = data else {
                print("Error: invalid HTTP response")
                return
            }

            do {
                // JSON 데이터를 NutritionInfoResponse로 디코드
                let responseWrapper = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                    let nutritionInfo = responseWrapper.result
                
                //menuTableView 업데이트
                menuList = nutritionInfo.menuResponseDtos
                updateMenuTableView()
                print("서버로부터 오늘의 메뉴를 받아와 표시에 성공 했습니다.")
                
                //nutrition
                totalNutritionInfo = nutritionInfo.totalNutritionResponseDto
                updateNutritionInfo()
                print("서버로부터 오늘의 총 영양정보를 받아와 표시에 성공 했습니다.")

                
            } catch {
                print("Error: Decoding JSON failed: \(error)")
            }
        }
        // 요청 시작
        task.resume()
    }

    
    
    //MARK: - initial UI setting func
    
    func setUI() {
        
        edgesForExtendedLayout = [.bottom]
        
        dayIdxBtn.setTitle("오늘", for: .normal)
        
        setNutritionInfoViewUI()
        setRecommendationViewUI()
        setMenuTableViewUI()
        updateMenuTableView()
        
        self.view.bringSubviewToFront(calendarStackView)
    }
    
    //MARK: - Setting recommendation View
    private func setRecommendationViewUI() {
        
        recommendationStackView.backgroundColor = recommendationStackView.backgroundColor?.withAlphaComponent(0.2)
        
        recommendationStackView.layer.cornerRadius = 20
        
        recommendationStackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        recommendationStackView.layer.shadowOpacity = 0.7

        // API endpoint
        guard let endPointURL = Bundle.main.object(forInfoDictionaryKey: "AIServerURL") as? String else {
            print("Error: cannot find key ServerURL in info.plist")
            return
        }
        let urlString = "\(endPointURL)/food_recommendation" // 실제 엔드포인트 URL로 변경해야 합니다.
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }

        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let mimeType = httpResponse.mimeType,
                  mimeType == "application/json",
                  let data = data else {
                print("Error: invalid HTTP response")
                return
            }

            do {
                let responseData = try JSONDecoder().decode(Root.self, from: data)
                DispatchQueue.main.async {
                    self.recoTextView.text = responseData.recommendedFood.foodName
                }
            } catch {
                print("Error: Decoding JSON failed: \(error)")
            }
        }

        // 요청 시작
        task.resume()

        
    }
    
    //MARK: - menuTableView
    
    private func setTableViewHeight() {
        var tableViewHeight: CGFloat = 10

        for section in 0..<menuTableView.numberOfSections {
            if menuSections[section].menus.count == 0 {continue}
            tableViewHeight += 55
            for row in 0..<menuTableView.numberOfRows(inSection: section) {
                tableViewHeight += 100
            }
        }

        menuTableViewHeight.constant = tableViewHeight
    }
    
    private func setMenuTableViewUI() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        registerXib()
        
        tableBaseView.layer.cornerRadius = 20
        tableBaseView.backgroundColor = tableBaseView.backgroundColor?.withAlphaComponent(0.2)
    
        
        tableBaseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableBaseView.layer.shadowOpacity = 0.7
        
        menuTableView.separatorStyle = .none
    }

    
    //아침, 점심, 저녁 순으로 정렬되지 않는 문제가 있음
//    private func updateMenuTableView() {
//        
//        menuSections.removeAll()
//        
//        // MealTime.allCases 대신 실제 meal 문자열 값의 유니크한 리스트를 사용합니다.
//        let mealTimes = Set(menuList.map { $0.meal }).sorted()
//        
//        for mealTime in mealTimes {
//            // menuList에서 현재 mealTime 문자열과 일치하는 메뉴들만 필터링합니다.
//            let filteredMenus = menuList.filter { $0.meal == mealTime }
//            // MenuSection을 생성할 때 MealTime 대신 문자열을 직접 사용합니다.
//            let section = MenuSection(mealTime: mealTime, menus: filteredMenus)
//            menuSections.append(section)
//        }
//        
//        DispatchQueue.main.async {
//            self.menuTableView.reloadData()
//            self.setTableViewHeight()
//        }
//        
//    }
    
    private func updateMenuTableView() {
        menuSections.removeAll()
        
        // 식사 시간별로 정렬 우선순위를 정합니다.
        let mealOrder: [String: Int] = ["아침": 1, "점심": 2, "저녁": 3]

        // 식사 시간을 정렬 우선순위에 따라 정렬합니다.
        let mealTimes = Array(Set(menuList.map { $0.meal })).sorted {
            mealOrder[$0, default: 4] < mealOrder[$1, default: 4]
        }
        
        for mealTime in mealTimes {
            let filteredMenus = menuList.filter { $0.meal == mealTime }
            let section = MenuSection(mealTime: mealTime, menus: filteredMenus)
            menuSections.append(section)
        }
        
        DispatchQueue.main.async {
            self.menuTableView.reloadData()
            self.setTableViewHeight()
        }
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].menus.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! menuTableViewCell
        
        let target = menuSections[indexPath.section].menus[indexPath.row]
        
        
        let menuImgUrl = target.menuImageUrls.first ?? ""
        if let menuImgURL = URL(string: menuImgUrl) {
            
            // URLSession을 사용하여 이미지를 다운로드합니다.
            let task = URLSession.shared.dataTask(with: menuImgURL) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    
                    
                    DispatchQueue.main.async {
                        cell.menuImgView?.image = image
                        self.view.layoutIfNeeded()
                    }
                    
                } else {
                    print("메뉴의 이미지를 불러오는데 실패했습니다: \(String(describing: error))")
                    
                    DispatchQueue.main.async {
                        cell.menuImgView?.image = nil
                        self.view.layoutIfNeeded()
                    }
                    
                }
            }
            
            task.resume()
        }
        
        cell.mealTimeLabel?.text = target.food
        cell.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
                
        cell.selectionStyle = .none

               
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if menuSections[section].menus.count == 0 {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear// 배경색 설정
           
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16) // 글꼴 크기 설정
        headerLabel.textColor = UIColor.white // 글자색 설정
        
        let sectionTitle = menuSections[section].mealTime
        headerLabel.text = sectionTitle // 섹션 타이틀 설정
        
           headerLabel.textAlignment = .center // 텍스트 정렬 설정
           
           headerView.addSubview(headerLabel)
           
           return headerView
       }
       
    
    let cellName = "menuTableViewCell"
    let cellReuseIdentifier = "menuCell"
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        menuTableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
    }

    
    //MARK: - NutritionInfoView
    func setNutritionInfoViewUI() {
        
        nutritionAppendBtn.contentHorizontalAlignment = .left
        
        nutritionDetailViews.append(cholesterolLabel)
        nutritionDetailViews.append(totalSaturatedFattyAcidsLabel)
        nutritionDetailViews.append(totalSugarsLabel)
        
        nutritionDetailViews.append(cholesterolTitleLabel)
        nutritionDetailViews.append(totalSaturatedFattyAcidsTitleLabel)
        nutritionDetailViews.append(totalSugarsTitleLabel)
        
        for view in nutritionDetailViews {
            view.alpha = 0
        }


        
        nutritionBaseStackView.backgroundColor = nutritionBaseStackView.backgroundColor?.withAlphaComponent(0.2)
        
        nutritionBaseStackView.layer.cornerRadius = 20
        
        nutritionBaseStackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        nutritionBaseStackView.layer.shadowOpacity = 0.7
        
        nutritionBaseStackView.layer.cornerRadius = 20

        
        nutritionViews.append(kcalView)
        nutritionViews.append(carbohydrateView)
        nutritionViews.append(proteinView)
        nutritionViews.append(fatView)
        nutritionViews.append(natriumView)
        
        for view in nutritionViews {
            view.layer.cornerRadius = view.layer.bounds.width / 2
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.2)
            view.layer.borderWidth = 2
            view.layer.borderColor = view.backgroundColor?.withAlphaComponent(1).cgColor
        }


    }
    
    func updateNutritionInfo() {
        DispatchQueue.main.async {
            self.kcalLabel.text = "\(self.totalNutritionInfo!.totalCalories * 4)kcal"
            self.carbohydrateLabel.text = "\(String(format: "%.2f", self.totalNutritionInfo!.totalCarbs * 4))g"
            self.proteinLabel.text = "\(String(format: "%.2f", self.totalNutritionInfo!.totalProtein * 4))g"
            self.fatLabel.text = "\(String(format: "%.2f", self.totalNutritionInfo!.totalFat * 4))g"
            self.natriumLabel.text = "\(String(format: "%.2f", self.totalNutritionInfo!.totalNatrium * 4))g"
        }
        
        if let totalNutritionInfo = totalNutritionInfo {
                    nutritionStatusManager = NutritionStatusManager(
                        totalNutritionInfo: totalNutritionInfo,
                        kcalView: kcalView,
                        carbohydrateView: carbohydrateView,
                        proteinView: proteinView,
                        fatView: fatView,
                        sugarsView: natriumView,
                        isKcalProperLabel: isKcalProperLabel,
                        isCarboProperLabel: isCarboProperLabel,
                        isProteinProperLabel: isProteinProperLabel,
                        isFatProperLabel: isFatProperLabel,
                        isSugarsProperLabel: isNatriumProperLabel
                    )
        }
        
        nutritionStatusManager?.updateNutritionStatus()
        
    }

    
    //MARK: - calendar setting
    
    func setCalendar() {
        FSCalendarView.delegate = self
        FSCalendarView.dataSource = self
        
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "YYYY년 MM월 dd일"
        
        FSCalendarView.locale = Locale(identifier: "ko_KR")
        
        FSCalendarView.appearance.headerDateFormat = "YYYY년 MM월"
        
        FSCalendarView.appearance.headerTitleAlignment = .center

        FSCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        FSCalendarView.headerHeight = 45
        
        FSCalendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        FSCalendarView.appearance.headerTitleColor = .white

        FSCalendarView.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 14)
        FSCalendarView.appearance.weekdayTextColor = .white
        
        FSCalendarView.appearance.titleFont = UIFont.boldSystemFont(ofSize: 14)
        
        FSCalendarView.backgroundColor = FSCalendarView.backgroundColor?.withAlphaComponent(0.2)
        
        FSCalendarView.layer.cornerRadius = 30
        FSCalendarView.clipsToBounds = true
        
        FSCalendarView.layer.shadowOpacity = 0.5
        FSCalendarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        FSCalendarView.isHidden = true
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dayIdxBtn.setTitle(dateFormatter?.string(from: date), for: .normal)
        if date.compare(FSCalendarView.today!).rawValue == 0 {
            dayIdxBtn.setTitle("오늘", for: .normal)
            
            getTodayNutriInfo(for: date, completion: {_ in print("get Success \n\n\n")})
        } else {
            
            getTodayNutriInfo(for: date, completion: {_ in print("get Success \n\n\n")})
            
        }
        
    }
    
    //MARK: - btn acction func
    
    
    @IBAction func dayBtnDidTap(_ sender: Any) {

        if let overlayView = self.view.viewWithTag(100) {
                hideCalendarAndOverlay()
                return
            }

            // 새로운 오버레이 뷰를 생성합니다.
            let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor(named: "mainColor")?.withAlphaComponent(0.8) // 투명도를 50%로 설정
            overlayView.tag = 100 // 나중에 오버레이 뷰를 쉽게 찾기 위한 태그
            overlayView.alpha = 0 // 초기 알파 값을 0으로 설정하여 뷰가 보이지 않게 합니다.
            
            // 탭 제스처 인식기를 오버레이 뷰에 추가합니다.
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCalendarAndOverlay))
            overlayView.addGestureRecognizer(tapGesture)
            overlayView.isUserInteractionEnabled = true // 오버레이 뷰가 이벤트를 받도록 설정합니다.

            // 오버레이 뷰를 현재 뷰 컨트롤러의 뷰에 추가합니다.
            self.view.addSubview(overlayView)
            self.view.bringSubviewToFront(self.calendarStackView)

            // 애니메이션을 사용하여 오버레이 뷰와 캘린더 뷰를 서서히 표시합니다.
            UIView.animate(withDuration: 0.2) {
                self.FSCalendarView.isHidden = false
                self.FSCalendarView.alpha = 1
                overlayView.alpha = 0.8 // 오버레이 뷰를 투명도 50%로 설정하여 부분적으로 보이게 합니다.
            }
        
    }
    
    @objc func hideCalendarAndOverlay() {
        if let overlayView = self.view.viewWithTag(100) {
            UIView.animate(withDuration: 0.2, animations: {
                self.FSCalendarView.alpha = 0
                overlayView.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.FSCalendarView.isHidden = true
                    overlayView.removeFromSuperview()
                })
            }
        }
    }
    
    
    @IBAction func nutritionAppendBtnDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nutritionDetailView.isHidden = !self.nutritionDetailView.isHidden
        })
        
        if self.nutritionDetailView.isHidden {
            self.nutritionAppendStatusLabel.text = "상세보기"
            for view in self.nutritionDetailViews {
                view.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.9, animations: {
                self.nutritionAppendStatusLabel.text = "접기"
                for view in self.nutritionDetailViews {
                    view.alpha = 1
                }
            })
        }
        
    }
    
    
    @IBAction func recoAppendDidTap(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.recoTextView.isHidden = !self.recoTextView.isHidden
            if self.recoTextView.isHidden {
                self.recoAppendTextLabel.text = "펼치기"
            } else {
                self.setRecommendationViewUI()
                self.recoAppendTextLabel.text = "접기"
            }
        })
    }
    
    
    @IBAction func menuListBtnDidTap(_ sender: Any) {
       
            UIView.animate(withDuration: 0.2, animations: {
                    // 뷰가 현재 보이는 상태라면 페이드 아웃
                    if self.menuTableView.alpha == 1 {
                        self.menuTableView.alpha = 0
                        self.menulistAppendTextLabel.text = "펼치기"
                    } else { // 그렇지 않다면 페이드 인
                        self.getTodayNutriInfo(for: Date(), completion: {_ in })

                        self.menuTableView.isHidden = false
                        self.menuTableView.alpha = 1
                        self.menulistAppendTextLabel.text = "접기"
                    }
                }) { _ in
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        // 애니메이션이 완료되고 뷰가 페이드 아웃된 경우 숨김 처리
                        if self.menuTableView.alpha == 0 {
                            self.menuTableView.isHidden = true
                            self.menulistAppendTextLabel.text = "펼치기"
                        }
                    })
                    
                }

        
    }
    
    //MARK: - unwined Segue
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
        print("unwindToMainViewController\n\n\n\n\n")
        
        if let sourceViewController = segue.source as? NutritionResultViewController {
            
        }
    }

    
    
}
