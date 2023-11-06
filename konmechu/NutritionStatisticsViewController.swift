//
//  NutritionStatisticsViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import FSCalendar

class NutritionStatisticsViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var dayIdxBtn: UIButton!
    
    @IBOutlet weak var FSCalendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        setUILayer()

    }
    
    //MARK: - initial UI setting func
    
    func setUILayer() {
        
    }
    
    //MARK: - calendar initial setting
    func setCalendar() {
        FSCalendarView.delegate = self
        FSCalendarView.dataSource = self
        
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
    
    //MARK: - btn acction func
    
    
    @IBAction func dayIdxButtonDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.FSCalendarView.isHidden = !self.FSCalendarView.isHidden
            self.FSCalendarView.alpha = self.FSCalendarView.isHidden ? 0 : 1
        })
    }
    
    
}
