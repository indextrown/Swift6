//
//  TodoView.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

/*
  
 홈 - todolist
 온보딩 - 메인스택
 생성을 눌러서 새로운 뷰로 이동하는데 이게 2가지인데 todoview, memoview
 - 이 두개의 종속은 todolist가 아니라 최상위 onboarding에서 관리하겠다

 */

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        
        VStack {
            CustomNavigationBar(
                leftBtnAction: {
                    pathModel.paths.removeLast()    // 뒤로가기버튼 누르면 최상단의 todoView가 닫힌다
                },
                rightBtnAction: {
                    todoListViewModel.addTodo(
                        .init(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.day,
                            selected: false
                        )
                    )
                    pathModel.paths.removeLast()    // 생성버튼눌러도 뒤로 나와야함
                },
                rightBtnType: .create
            )
            
            // 타이틀 뷰
            TitleView()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            // 투두 타이틀 뷰(텍스트필드)
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            // 시간 선택
            SelectTimeView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            // 날짜 선택
            SelectDateView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("To do list를\n 추가해 보세요")
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - 투두 타이틀 뷰(제목 입력 뷰)
private struct TodoTitleView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요.", text: $todoViewModel.title)
    }
}

// MARK: - 시간 선택 뷰
private struct SelectTimeView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 날짜 선택 뷰
private struct SelectDateView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("날짜")
                    .foregroundColor(.customIconGray)
                
                Spacer()
            }
            
            HStack {
                Button {
                    todoViewModel.setIsDisplayCalendar(true)
                } label: {
                    Text("\(todoViewModel.day.formattedDay)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.customGreen)
                }
                .popover(isPresented: $todoViewModel.isDisplayCalendar) {
                    DatePicker(
                        "",
                        selection: $todoViewModel.day,
                        displayedComponents: .date
                    )
                    .labelsHidden() // 레이블 숨김
                    .datePickerStyle(GraphicalDatePickerStyle()) // 달력 형태
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    // selection 변경될때마다 캘린더 닫히도록
                    .onChange(of: todoViewModel.day) { _, _ in
                        todoViewModel.setIsDisplayCalendar(false)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TodoView()
}
