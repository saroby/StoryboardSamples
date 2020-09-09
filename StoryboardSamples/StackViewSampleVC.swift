//
//  StackViewSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/09.
//

import UIKit

class StackViewSampleVC: UIViewController {

    var stack: UIStackView!
    
    var settingVC: SettingVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view가 navigationbar과 겹치지 않도록 함.
        edgesForExtendedLayout = []
        
        stack = UIStackView(frame: view.frame).then {
            $0.backgroundColor = .systemBackground
            
            $0.addArrangedSubview(UILabel().then {
                $0.text = "1"
                $0.backgroundColor = .red
                $0.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            })
            $0.addArrangedSubview(UILabel().then {
                $0.text = "22"
                $0.backgroundColor = .green
                
            })
            $0.addArrangedSubview(UILabel().then {
                $0.text = "333"
                $0.backgroundColor = .blue    
            })
            
            view.addSubview($0)
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            $0.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
        
        settingVC = SettingVC().then {
            $0.targetStack = stack
        }
        
        
        let showSettingBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchUpInside_showSettingBtn(_:)))
        navigationItem.setRightBarButtonItems([ showSettingBtn ], animated: true)
        
        
    }
    
    @objc func touchUpInside_showSettingBtn(_ sender: UIButton) {
        present(settingVC, animated: true, completion: nil)
    }

}

extension StackViewSampleVC {
    
    class SettingVC: UIViewController {
        var alignment: UIStackView.Alignment = .center
        
        var targetStack: UIStackView = UIStackView()
        
        var asixSegmentedControl: UISegmentedControl!
        
        var alignmentSegmentedControl: UISegmentedControl!
        
        var distributionSegmentedControl: UISegmentedControl!
        
        override func viewDidLoad() {
            super.viewDidLoad()
                        
            asixSegmentedControl = UISegmentedControl(items: ["horizontal", "vertical"])
            asixSegmentedControl.addTarget(self, action: #selector(valueChanged_segmentedControl), for: .valueChanged)
            asixSegmentedControl.selectedSegmentIndex = targetStack.axis.rawValue
            
            alignmentSegmentedControl = UISegmentedControl(items: ["fill", "leading", "firstBaseline", "center", "trailing", "lastBaseline"])
            alignmentSegmentedControl.addTarget(self, action: #selector(valueChanged_segmentedControl), for: .valueChanged)
            alignmentSegmentedControl.selectedSegmentIndex = targetStack.alignment.rawValue
            
//            fill: 나머지는 natural size이고 한 뷰는 가장 공간 많이 차지하게 (hugging priority 판단)
//            fill equally: 모든 뷰가 똑같은 넓이를 갖게 채움.
//            fill proportionally: 사이즈 비율만큼 커져서 채움 <-사이즈 비율의 기준은 무엇인가?
//            equal spacing: 뷰들 사이 간격을 균등하게
//            equal centering: 뷰들의 '센터'가 간격이 균등하게
            distributionSegmentedControl = UISegmentedControl(items: ["fill", "fillEqually", "fillProportionally", "equalSpacing", "equalCentering"])
            distributionSegmentedControl.addTarget(self, action: #selector(valueChanged_segmentedControl), for: .valueChanged)
            distributionSegmentedControl.selectedSegmentIndex = targetStack.distribution.rawValue
            
            let _ = UIStackView(arrangedSubviews: [asixSegmentedControl, alignmentSegmentedControl, distributionSegmentedControl]).then {
                $0.frame = view.frame
                $0.axis = .vertical
                $0.distribution = .fillProportionally
                $0.alignment = .center
                
                view.addSubview($0)
            }
        }
        
        @objc private func valueChanged_segmentedControl(_ sender: UISegmentedControl) {
            switch sender {
            case asixSegmentedControl:
                targetStack.axis = NSLayoutConstraint.Axis(rawValue: sender.selectedSegmentIndex)!
            case alignmentSegmentedControl:
                targetStack.alignment = UIStackView.Alignment(rawValue: sender.selectedSegmentIndex)!
            case distributionSegmentedControl:
                targetStack.distribution = UIStackView.Distribution(rawValue: sender.selectedSegmentIndex)!
            default:
                break
            }
        }
    }
    
}
