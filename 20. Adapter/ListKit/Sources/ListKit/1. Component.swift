//
//  Component.swift
//  ListKit
//
//  Created by 김동현 on 5/13/26.
//
// https://0urtrees.tistory.com/127
// https://hyunsikwon.github.io/swift/Swift-AssociatedType/
// var viewData: Int = 0 ===> associatedtype ViewData == Int 자동 추론

import UIKit

public protocol Component {
    associatedtype ViewData: Equatable
    associatedtype Content: UIView
    associatedtype Coordinator = Void
    
    var viewData: ViewData { get }
    var reuseIdentifier: String { get }
    var layoutMode: ContentLayoutMode { get }
    
    @MainActor
    func makeView(coordinator: Coordinator) -> Content
    
    @MainActor
    func updateView(in content: Content, coordinator: Coordinator)
    
    @MainActor
    func layout(content: Content, in container: UIView)
    
    @MainActor
    func makeCoordinator() -> Coordinator
}

extension Component {
    public var reuseIdentifier: String {
        return String(reflecting: Self.self)
    }
}

extension Component where Coordinator == Void {
    @MainActor
    public func makeCoordinator() -> Coordinator {
        return ()
    }
}

extension Component where Content: UIView {
    @MainActor
    public func layout(content: Content, in container: UIView) {
        content.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: container.topAnchor),
            content.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            content.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            content.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])
        
    }
}
