//
//  LoginExampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/13.
//

//import UIKit
//import RxSwift
//import RxCocoa
//
//class LoginExampleVC: UIViewController {
//
//    var emailTF: UITextField!
//    var pwTF: UITextField!
//    var emailLoginBtn: UIButton!
//    var fbLoginBtn: UIButton!
//    var googleLoginBtn: UIButton!
//
//
//    private let disposeBag = DisposeBag()
//    let emailValue: BehaviorRelay<String>()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        emailTF = UITextField().then {
//            $0.rx.text.orEmpty.bind(to: <#T##String...##String#>).d
//
//            $0.rx.text.orEmpty
//        }
//        pwTF = UITextField().then {
//            $0.rx.controlEvent(.editingChanged).subscribe().disposed(by: disposeBag)
//        }
//
//        fbLoginBtn = UIButton().then {
//            $0.rx.tap.bind { [weak self] _ in
//                guard let self = self else { return }
//
//            }
//
//        }
//
//        googleLoginBtn = UIButton().then {
//            $0.rx.tap.bind { [weak self] _ in
//                guard let self = self else { return }
//
//            }
//
//        }
//
//
//
//    }
//
//}
