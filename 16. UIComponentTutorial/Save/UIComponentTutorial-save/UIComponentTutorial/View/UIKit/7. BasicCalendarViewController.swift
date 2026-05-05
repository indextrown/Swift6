//
//  BasicCalendarViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/30/25.
//

import UIKit

final class BasicCalendarViewController: UIViewController {
    
    /// 현재 선택된 날짜
    var selectedDate: DateComponents? = nil
    
    // MARK: - UI Conponent
    /// 날짜별 데코레이션(점, 이모지 등)을 지원하는 캘린더 뷰
    private lazy var calendarView: UICalendarView = {
        let view = UICalendarView()
        view.locale = Locale(identifier: "ko_KR")
        view.translatesAutoresizingMaskIntoConstraints = false
        /// 점이나 뱃지 표시 등 달력 Custom 하기 위해 설정해야 하는 속성
        view.wantsDateDecorations = true
        return view
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeUI()
        self.constraints()
        self.setCalendar()
    }
    
    /// 캘린더 delegate 및 날짜 선택 동작 설정
    private func setCalendar() {
        self.calendarView.delegate = self
        
        /// 한 번에 한 날짜만 선택 가능
        let dateSection = UICalendarSelectionSingleDate(delegate: self)
        /// 선택 이벤트(날짜 선택 시 콜백)를 BasicCalendarViewController에서 직접 처리하겠다
        calendarView.selectionBehavior = dateSection
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(calendarView)
    }
    
    private func constraints() {
        let calendarViewConstraints = [
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(calendarViewConstraints)
    }
    
    /// 특정 날짜 셀만 데코레이션 새로고침(이모지 추가)
    private func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        calendarView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
}

// MARK: - 캘린더 Delegate
extension BasicCalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    /// 날짜별 데코레이션 표시 커스텀(필요시 구현)
    /// 선택된 날자의 셀에 이모지로 커스텀 데코레이션을 보여준다
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "🐶"
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }
    
    /// 날짜 선택 시 동작
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        /// selection 객체에 저장
        selection.setSelected(dateComponents, animated: true)
        /// selectedDate 프로퍼티를 업데이트
        selectedDate = dateComponents
        /// 선택한 날짜 셀의 데코레이션만 새로고침(🐶 이모지가 바로 반영되게)
        reloadDateView(date: Calendar.current.date(from: dateComponents!))
    }
}


#Preview {
    BasicCalendarViewController()
}
