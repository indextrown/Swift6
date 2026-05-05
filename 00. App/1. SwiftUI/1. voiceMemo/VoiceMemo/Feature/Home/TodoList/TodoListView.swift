//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/27/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        
        /*
        // 투두 셀 리스트
        VStack {
            // MARK: - 커스텀 네비게이션바(유무)
            if !todoListViewModel.todos.isEmpty {
                CustomNavigationBar(
                    isDisplayLeftBtn: false,
                    rightBtnAction: {
                        todoListViewModel.navigationRightBtnTapped()
                    },
                    rightBtnType: todoListViewModel.navigationBarRightBtnMode
                )
            } else {
                Spacer()
                    .frame(height: 30)
            }
            
            TitleView()
                .padding(.top, 20)
            
            // todos 가 비어있다면 AnnouncementView 그렇지 않으면 빈 공간
            if todoListViewModel.todos.isEmpty {
                AnnouncementView()
            } else {
                TodoListContentView()
                    .padding(.top, 20)
            }
        }
        // 1번방식
        //.modifier(WriteBtnViewModifier(action: { pathModel.paths.append(.todoView)}))
        
        // 2번방식
        .writeBtn {
            pathModel.paths.append(.todoView)
        }
         */
        
        // 3번방식
        WriteBtnView(content: {
            VStack {
                // MARK: - 커스텀 네비게이션바(유무)
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            todoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: todoListViewModel.navigationBarRightBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                // todos 가 비어있다면 AnnouncementView 그렇지 않으면 빈 공간
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
        }, action: {
            pathModel.paths.append(.todoView)
        })
        
        
        /*
        // 동그라미 버튼
        WriteTodoBtnView()
            .padding(.trailing, 20)
            .padding(.bottom, 50)
         */
        
        .alert(
            "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeBtnTapped()
            }
            
            Button("취소", role: .cancel) { }
        }
        // todos 추가되거나 삭제될때마다 반응
        .onChange(of: todoListViewModel.todos) { oldValue, newTodo in
            homeViewModel.setTodosCount(newTodo .count)
        }
    }
}

// MARK: - 하위뷰로 만들어주기
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do lsit \(todoListViewModel.todos.count)개가\n 있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template) // 색상을 텍스트와 함께 변화시키기 위함
            Text("\"매일 아침 5시 운동하자!\"")
            Text("\"내일 8시 수강 신청하자!\"")
            Text("\"1시 반 점심약속 리마인드 해보자!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        // TODO: - Todo 셀 뷰 todo 넣어서 뷰 호출
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}

// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false, 
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack {
            VStack(spacing: 20) {
                HStack {
                    if !todoListViewModel.isEditTodoMode {
                        Button {
                            todoListViewModel.selectedBoxTapped(todo)
                        } label: {
                            todo.selected ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(todo.title)
                            .font(.system(size: 16))
                            .foregroundColor(todo.selected ? .customIconGray : .customBlack)
                            .strikethrough(todo.selected)
                        
                        Text(todo.convertedDayAndTime)
                            .font(.system(size: 16))
                            .foregroundColor(.customIconGray)
                    }
                    
                    Spacer()
                    
                    // 현재 편집 모드라면
                    if todoListViewModel.isEditTodoMode {
                        Button {
                            isRemoveSelected.toggle()
                            todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                        } label: {
                            isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // 구분선
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - Todo 작성 버튼 뷰
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Image("writeBtn")
                }
            }
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
}

// 1:01;34
