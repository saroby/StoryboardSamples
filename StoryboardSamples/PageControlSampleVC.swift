//
//  PageControlSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/09.
//

import UIKit

class PageControlSampleVC: UIViewController {

    var imageView: UIImageView!
    var pageControl: UIPageControl!
    
    var dataSource: [UIImage] = [
        UIImage(named: "twice")!,
        UIImage(named: "dog")!,
        UIImage(named: "red")!,
        UIImage(named: "background_ amusement_park")!,
        UIImage(named: "twice")!,
        UIImage(named: "dog")!,
        UIImage(named: "red")!,
        UIImage(named: "background_ amusement_park")!,
        UIImage(named: "twice")!,
        UIImage(named: "dog")!,
        UIImage(named: "red")!,
        UIImage(named: "background_ amusement_park")!,
        UIImage(named: "twice")!,
        UIImage(named: "dog")!,
        UIImage(named: "red")!,
        UIImage(named: "background_ amusement_park")!,
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = view.then {
            $0.backgroundColor = .red
        }
        
        imageView = UIImageView().then {
            $0.backgroundColor = .green
            $0.contentMode = .scaleToFill
            view.addSubview($0)
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            $0.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        }
        
        print(view.frame.height)
        pageControl = UIPageControl().then {
            $0.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
            $0.frame = CGRect(origin: CGPoint(x: 0, y: view.safeAreaLayoutGuide.layoutFrame.height-40), size: CGSize(width: view.frame.width, height: 40))
            
            $0.numberOfPages = dataSource.count
            $0.addTarget(self, action: #selector(valueChagned_pageControl), for: .valueChanged)
            
            $0.currentPage = 0
            
            // 잘 보이게 색 변경.
            $0.pageIndicatorTintColor = .lightGray
            $0.currentPageIndicatorTintColor = .black
            
            view.addSubview($0)
        }
        
        // 만약 뒤에 있으면 맨 앞으로 가져온다.
        view.bringSubviewToFront(pageControl)
        
        imageView.image = dataSource[pageControl.currentPage]
    }
    
    @objc func valueChagned_pageControl(_ sender: UIPageControl) {
        imageView.image = dataSource[sender.currentPage]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
