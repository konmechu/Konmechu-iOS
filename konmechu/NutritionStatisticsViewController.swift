//
//  NutritionStatisticsViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import FSCalendar

class NutritionStatisticsViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    //MARK: - Calendar var
    
    @IBOutlet weak var dayIdxBtn: UIButton!
    
    @IBOutlet weak var FSCalendarView: FSCalendar!
    
    private var dateFormatter : DateFormatter?
    
    
    //MARK: - Nutritioin info var
    
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
    
    private var nutritionViews: [UIView] = []

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        setUILayer()

    }
    
    //MARK: - initial UI setting func
    
    func setUILayer() {
        dayIdxBtn.setTitle(dateFormatter?.string(from: FSCalendarView.today!), for: .normal)
        
        setNutritionInfoView()
    }
    
    //MARK: -
    func setNutritionInfoView() {
        
        nutritionBaseView.layer.cornerRadius = 20
        
        nutritionBaseView.backgroundColor = nutritionBaseView.backgroundColor?.withAlphaComponent(0.2)
        
        nutritionBaseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        nutritionBaseView.layer.shadowOpacity = 0.7
        
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
        
        FSCalendarView.backgroundColor = FSCalendarView.backgroundColor?.withAlphaComponent(0.2)
        
        FSCalendarView.layer.cornerRadius = 30
        FSCalendarView.clipsToBounds = true
        
        FSCalendarView.layer.shadowOpacity = 0.5
        FSCalendarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        FSCalendarView.isHidden = true
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dayIdxBtn.setTitle(dateFormatter?.string(from: date), for: .normal)
    }
    
    //MARK: - btn acction func
    
    
    @IBAction func dayIdxButtonDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.FSCalendarView.isHidden = !self.FSCalendarView.isHidden
            self.FSCalendarView.alpha = self.FSCalendarView.isHidden ? 0 : 1
        })
    }
    
    
}
