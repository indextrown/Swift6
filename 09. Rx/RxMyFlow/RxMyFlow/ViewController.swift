////
////  ViewController.swift
////  RxMyFlow
////
////  Created by 김동현 on 4/16/25.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//final class ViewController: UIViewController {
//
//    private let viewModel = ViewModel()
//    private let disposeBag = DisposeBag()
//
//    private let loginView = LoginView()
//    private let nicknameView = NicknameView()
//    private let birthdayView = BirthdayView()
//    private let homeView = HomeView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view = loginView
//
//        bind()
//    }
//
//    private func bind() {
//        let input = ViewModel.Input(
//            loginTapped: loginView.loginButton.rx.tap.asObservable(),
//            nicknameNextTapped: nicknameView.nextButton.rx.tap.asObservable(),
//            birthdayNextTapped: birthdayView.nextButton.rx.tap.asObservable()
//        )
//
//        let output = viewModel.transform(input: input)
//
//        output.moveToStep
//            .drive(onNext: { [weak self] step in
//                guard let self = self else { return }
//                switch step {
//                case .login:
//                    self.view = self.loginView
//                case .nickname:
//                    self.view = self.nicknameView
//                case .birthday:
//                    self.view = self.birthdayView
//                case .home:
//                    self.view = self.homeView
//                }
//                
//            })
//            .disposed(by: disposeBag)
//    }
//}
//final class ViewModel {
//    enum Step {
//        case login
//        case nickname
//        case birthday
//        case home
//    }
//
//    struct Input {
//        let loginTapped: Observable<Void>
//        let nicknameNextTapped: Observable<Void>
//        let birthdayNextTapped: Observable<Void>
//    }
//
//    struct Output {
//        let moveToStep: Driver<Step>
//    }
//
//    private let stepRelay = BehaviorRelay<Step>(value: .login)
//
//    func transform(input: Input) -> Output {
//        input.loginTapped
//            .subscribe(onNext: { [weak self] in self?.stepRelay.accept(.nickname) })
//            .disposed(by: disposeBag)
//
//        input.nicknameNextTapped
//            .subscribe(onNext: { [weak self] in self?.stepRelay.accept(.birthday) })
//            .disposed(by: disposeBag)
//
//        input.birthdayNextTapped
//            .subscribe(onNext: { [weak self] in self?.stepRelay.accept(.home) })
//            .disposed(by: disposeBag)
//
//        return Output(moveToStep: stepRelay.asDriver(onErrorDriveWith: .empty()))
//    }
//
//    private let disposeBag = DisposeBag()
//}
//
//
//final class LoginView: UIView {
//    let loginButton = UIButton(type: .system)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        loginButton.setTitle("로그인", for: .normal)
//        setup()
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    private func setup() {
//        addSubview(loginButton)
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            loginButton.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//}
//
//
//final class NicknameView: UIView {
//    let nextButton = UIButton(type: .system)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .blue
//        nextButton.setTitle("Next1", for: .normal)
//        setup()
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    private func setup() {
//        addSubview(nextButton)
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//}
//
//
//final class BirthdayView: UIView {
//    let nextButton = UIButton(type: .system)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .yellow
//        nextButton.setTitle("Next2", for: .normal)
//        setup()
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    private func setup() {
//        addSubview(nextButton)
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//}
//
//
//final class HomeView: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .green
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//}


import RxSwift
import RxCocoa

final class ViewModel {
    enum Step {
        case nickname
        case birthday
        case home
    }

    struct Input {
        let loginTapped: Observable<Void>
        let nicknameNextTapped: Observable<Void>
        let birthdayNextTapped: Observable<Void>
    }

    struct Output {
        let moveToStep: Driver<Step>
    }

    private let stepRelay = PublishRelay<Step>()

    func transform(input: Input) -> Output {
        input.loginTapped
            .map { Step.nickname }
            .bind(to: stepRelay)
            .disposed(by: disposeBag)

        input.nicknameNextTapped
            .map { Step.birthday }
            .bind(to: stepRelay)
            .disposed(by: disposeBag)

        input.birthdayNextTapped
            .map { Step.home }
            .bind(to: stepRelay)
            .disposed(by: disposeBag)

        return Output(moveToStep: stepRelay.asDriver(onErrorDriveWith: .empty()))
    }

    private let disposeBag = DisposeBag()
}

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

    private let loginButton = UIButton(type: .system)
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .white
        setupUI()
        bind()
    }

    private func setupUI() {
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bind() {
        let input = ViewModel.Input(
            loginTapped: loginButton.rx.tap.asObservable(),
            nicknameNextTapped: .never(),
            birthdayNextTapped: .never()
        )

        let output = viewModel.transform(input: input)

        output.moveToStep
            .drive(onNext: { [weak self] step in
                guard let self = self else { return }

                if step == .nickname {
                    let nicknameVC = NicknameViewController(viewModel: self.viewModel)
                    //self.navigationController?.pushViewController(nicknameVC, animated: true)
                    self.navigationController?.setViewControllers([nicknameVC], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

final class NicknameViewController: UIViewController {

    private let nextButton = UIButton(type: .system)
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nickname"
        view.backgroundColor = .blue
        setupUI()
        bind()
    }

    private func setupUI() {
        nextButton.setTitle("Next1", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bind() {
        let input = ViewModel.Input(
            loginTapped: .never(),
            nicknameNextTapped: nextButton.rx.tap.asObservable(),
            birthdayNextTapped: .never()
        )

        let output = viewModel.transform(input: input)

        output.moveToStep
            .drive(onNext: { [weak self] step in
                guard let self = self else { return }

                if step == .birthday {
                    let birthdayVC = BirthdayViewController(viewModel: self.viewModel)
                    self.navigationController?.pushViewController(birthdayVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

final class BirthdayViewController: UIViewController {

    private let nextButton = UIButton(type: .system)
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Birthday"
        view.backgroundColor = .yellow
        setupUI()
        bind()
    }

    private func setupUI() {
        nextButton.setTitle("Next2", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bind() {
        let input = ViewModel.Input(
            loginTapped: .never(),
            nicknameNextTapped: .never(),
            birthdayNextTapped: nextButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.moveToStep
            .drive(onNext: { [weak self] step in
                guard let self = self else { return }

                if step == .home {
                    let homeVC = HomeViewController()
                    //self.navigationController?.pushViewController(homeVC, animated: true)
                    self.navigationController?.setViewControllers([homeVC], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .green

        let label = UILabel()
        label.text = "🏠 홈 화면입니다!"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
