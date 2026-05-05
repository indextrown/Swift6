//
//  1. CustomCalendar.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/4/25.
//

import UIKit
import FSCalendar

final class CustomCalendarVC: UIViewController {
    
    // MARK: - UI Component
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        
        // 첫 열을 월요일로 설정
        calendar.firstWeekday = 2
        
        // week 또는 month 가능
        calendar.scope = .month
        
        calendar.scrollEnabled = true
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 현재 달의 날짜들만 표기하도록 설정
        // calendar.placeholderType = .none
        
        // 헤더뷰 설정
        calendar.headerHeight = 55
        calendar.appearance.headerDateFormat = "MM월"
        calendar.appearance.headerTitleColor = .black
        
        // 요일 UI 설정
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 17, weight: .light)
        calendar.appearance.weekdayTextColor = .black
        
        // 날짜별 UI 설정
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: .light)
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 10, weight: .light)
        calendar.appearance.subtitleTodayColor = .systemYellow
        calendar.appearance.todayColor = .gray
        
        // 일요일 라벨의 textColor는 red로 설정
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .red
        return calendar
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        constraints()
            // 뒤로가기 버튼 숨기기
            self.navigationItem.hidesBackButton = true
    
            // 탭 바 숨기기
            self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - UI Setting
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendarView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}

#Preview {
    CustomCalendarVC()
}
