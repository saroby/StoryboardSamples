//
//  SafeAreaSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/09.
//

import UIKit

class SafeAreaSampleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
        print()
        
        
        // view가 navigationbar과 겹치지 않도록 함.
        //참고: https://www.hackingwithswift.com/example-code/uikit/how-to-stop-your-view-going-under-the-navigation-bar-using-edgesforextendedlayout
        if true {
            edgesForExtendedLayout = []
        }
        
        print("viewDidLoad()")
        print("view.frame: \(view.frame)")
        print("view.safeAreaLayoutGuide.layoutFrame: \(view.safeAreaLayoutGuide.layoutFrame)")
        print()
        
        view.backgroundColor = .red
        
        // 결론에 따르면, 이 시점에 view관련 사이즈들은 정확하지 않다. viewDidAppear이전에 frame을 셋팅하는 것은 원하지 않는 사이즈로 할당 될 수 있다.
        // frame 사이즈가 맞지 않으므로 autoresize도 원하는 모양으로 나오지 않는다.
        let _ = UIView().then {
            $0.frame = view.safeAreaLayoutGuide.layoutFrame
            $0.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
            $0.backgroundColor = .green
            view.addSubview($0)
        }

        // constraint를 이용하면 연결한 anchor가 변경될 때마다 자동으로 갱신하므로, viewDidAppear이전에 세팅하더라도 제대로 나온다.
        let _ = UIView().then {
            $0.backgroundColor = .yellow
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        print("viewWillAppear()")
        print("view.frame: \(view.frame)")
        print("view.safeAreaLayoutGuide.layoutFrame: \(view.safeAreaLayoutGuide.layoutFrame)")
        print()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear()")
        print("view.frame: \(view.frame)") // viewDidAppear 이후에 변경이 확인
        print("view.safeAreaLayoutGuide.layoutFrame: \(view.safeAreaLayoutGuide.layoutFrame)") // viewDidAppear 이후에 변경이 확인
        print()
        
        //결론: view의 frame과 safeAreaLayoutGuide은 viewDidApear이후가 정확한 값이다.
    }
    
}
