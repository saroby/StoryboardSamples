//
//  PageVCSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/09.
//

import UIKit

class PageVCSampleVC: UIViewController {
    // subPage의 view를 pageController에 subView하는 것이 기본 메커니즘이다.
    // (UI는 하나이기 때문에) view는 여러 parent view를 가질 수 없다. 따라서 마지막에 subview된 view에 붙는다.
    // 그런 이유로 하나의 화면에서 여러 pageController는 subPageViewController들을 공유할 수 없다.
    var scrollPageVCs: [SubPageViewController] = [
        SubPageViewController().then{ $0.imageName = "red" },
        SubPageViewController().then{ $0.imageName = "twice" },
        SubPageViewController().then{ $0.imageName = "dog" },
        SubPageViewController().then{ $0.imageName = "red" },
    ]

    var minPageVCs: [SubPageViewController] = [
        SubPageViewController().then{ $0.imageName = "red" },
        SubPageViewController().then{ $0.imageName = "twice" },
        SubPageViewController().then{ $0.imageName = "dog" },
        SubPageViewController().then{ $0.imageName = "red" },
    ]

    var midPageVCs: [SubPageViewController] = [
        SubPageViewController().then{ $0.imageName = "red" },
        SubPageViewController().then{ $0.imageName = "twice" },
        SubPageViewController().then{ $0.imageName = "dog" },
        SubPageViewController().then{ $0.imageName = "red" },
    ]
    
    var maxPageVCs: [SubPageViewController] = [
        SubPageViewController().then{ $0.imageName = "red" },
        SubPageViewController().then{ $0.imageName = "twice" },
        SubPageViewController().then{ $0.imageName = "dog" },
        SubPageViewController().then{ $0.imageName = "red" },
    ]

    var scroll: UIScrollView!
    var scrollPageVC: UIPageViewController!
    var minPageCurlPageVC: UIPageViewController!
    var midPageCurlPageVC: UIPageViewController!
    var maxPageCurlPageVC: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         let options: [UIPageViewController.OptionsKey : Any] = [
         // scroll 모드에서는 page 사이 간격이지만, pageCurl 모드에서는 아무런 영향을 주지 않는다.
         UIPageViewController.OptionsKey.interPageSpacing: 100,
         
         // spineLocation 옵션의 주의 할 점:
         // 인디케이터 메소드들(presentationCount, presentationIndex)을 선언하더라도, 인디케이터는 표시되지 않는다.
         // 옵션을 int값으로 바꿔서 넣지 않으면 에러.
         // min, mid, max는 각각 1,2,1 갯수에 맞춰 setViewControllers를 세팅해야 하며, 이를 지키지 않으면 에러가 발생한다.
         UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.min.rawValue,
         UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.mid.rawValue,
         UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.max.rawValue,
         ]
         */
        scroll = UIScrollView().then {
            $0.showsVerticalScrollIndicator = true
            $0.isScrollEnabled = true
            
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            $0.backgroundColor = .blue
        }
        
        let contentView = UIView().then {
            $0.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 2000))
            scroll.addSubview($0)
        }
        
        
        scrollPageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options:
                                                [UIPageViewController.OptionsKey.interPageSpacing: 20]).then {
            $0.setViewControllers([ scrollPageVCs.first! ], direction: .forward, animated: false, completion: nil)
            $0.delegate = self
            $0.dataSource = self
            
            //참고: https://www.hackingwithswift.com/example-code/uikit/how-to-use-view-controller-containment
            //참고: https://medium.com/@jang.wangsu/swift-containerview-%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC-ee2ed07ec4e8
            addChild($0)
            contentView.addSubview($0.view)
            $0.didMove(toParent: self)
            
            $0.view.translatesAutoresizingMaskIntoConstraints = false
            $0.view.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
            $0.view.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.view.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }
        
        minPageCurlPageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.min.rawValue,]
        ).then {
            $0.setViewControllers([ minPageVCs.first!, ], direction: .forward, animated: false, completion: nil)
            $0.delegate = self
            $0.dataSource = self

            addChild($0)
            contentView.addSubview($0.view)
            $0.didMove(toParent: self)

            $0.view.translatesAutoresizingMaskIntoConstraints = false
            $0.view.topAnchor.constraint(equalTo: scrollPageVC.view.bottomAnchor, constant: 20).isActive = true
            $0.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
            $0.view.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.view.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }
        

        midPageCurlPageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.mid.rawValue,]
        ).then {
            //$0.isDoubleSided = false //런타임 에러. 꼭 true여야 한다고 애플문서에 쓰여 있다.
            
            // mid는 page(ViewController)가 짝수가 아니면 런타임 에러.
            $0.setViewControllers([ midPageVCs.first!, midPageVCs[1] ], direction: .forward, animated: false, completion: nil)
            $0.delegate = self
            $0.dataSource = self

            addChild($0)
            contentView.addSubview($0.view)
            $0.didMove(toParent: self)

            $0.view.translatesAutoresizingMaskIntoConstraints = false
            $0.view.topAnchor.constraint(equalTo: minPageCurlPageVC.view.bottomAnchor, constant: 20).isActive = true
            $0.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
            $0.view.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.view.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }


        maxPageCurlPageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.max.rawValue,]
        ).then {
            $0.setViewControllers([ maxPageVCs.first!, ], direction: .forward, animated: false, completion: nil)
            $0.delegate = self
            $0.dataSource = self

            addChild($0)
            contentView.addSubview($0.view)
            $0.didMove(toParent: self)

            $0.view.translatesAutoresizingMaskIntoConstraints = false
            $0.view.topAnchor.constraint(equalTo: midPageCurlPageVC.view.bottomAnchor, constant: 20).isActive = true
            $0.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
            $0.view.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            $0.view.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //contentSize의 초기 사이즈는 zero이므로, 셋팅하지 않으면 스크롤되지 않는다.
        print("scroll.contentSize: \(scroll.contentSize)")

        // 적확한 scroll 사이즈를 계산하는 법.
        // 참고: https://stackoverflow.com/questions/2944294/how-do-i-auto-size-a-uiscrollview-to-fit-its-content
        let contentRect: CGRect = scroll.subviews.first!.subviews.reduce(into: .zero) { (rect, view) in
            print(rect)
            rect = rect.union(view.frame)
        }
        scroll.subviews.first!.frame = contentRect
        
        scroll.contentSize = contentRect.size
        print("scroll.contentSize: \(scroll.contentSize)")
    }
    
}

extension PageVCSampleVC: UIPageViewControllerDelegate {
    //TODO: 제스쳐나 폰반향 등이 바뀌어 spine 위치가 바뀌는 등에 사용 함.
}

extension PageVCSampleVC: UIPageViewControllerDataSource {
    
    //MARK: 필수 메소드
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let pageVCs: [SubPageViewController]!
        switch pageViewController {
        case scrollPageVC:
            pageVCs = scrollPageVCs
        case minPageCurlPageVC:
            pageVCs = minPageVCs
        case midPageCurlPageVC:
            pageVCs = midPageVCs
        case maxPageCurlPageVC:
            pageVCs = maxPageVCs
        default:
            return nil
        }
        
        let viewController = viewController as! SubPageViewController
        guard let idx = pageVCs.firstIndex(of: viewController) else {
            return nil
        }
        
        guard idx-1 >= 0 else {
            return nil
        }

        return pageVCs[idx-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pageVCs: [SubPageViewController]!
        switch pageViewController {
        case scrollPageVC:
            pageVCs = scrollPageVCs
        case minPageCurlPageVC:
            pageVCs = minPageVCs
        case midPageCurlPageVC:
            pageVCs = midPageVCs
        case maxPageCurlPageVC:
            pageVCs = maxPageVCs
        default:
            return nil
        }
        
        let viewController = viewController as! SubPageViewController
        guard let idx = pageVCs.firstIndex(of: viewController) else {
            return nil
        }
        
        guard idx+1 < pageVCs.count else {
            return nil
        }
        
        return pageVCs[idx+1]
    }
    
    //MARK: 아래 메소드를 추가하면, 기본셋팅 Indicator(page control)가 추가된다.
    // indicator를 커스텀하기 위해서는 아래 메소드를 삭제하고, 수동으로 page control instanc를 만들어서 추가해야 한다.
    // 참고: https://samwize.com/2016/03/08/using-uipageviewcontroller-with-custom-uipagecontrol
    
    // indicator page 수
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        switch pageViewController {
        case scrollPageVC:
            return scrollPageVCs.count
        case minPageCurlPageVC:
            return minPageVCs.count
        case midPageCurlPageVC:
            return midPageVCs.count
        case maxPageCurlPageVC:
            return maxPageVCs.count
        default:
            return 0
        }
        
    }
    
    // 초기 indicator idx
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}


extension PageVCSampleVC {
    
    class SubPageViewController: UIViewController {
        var imageName: String = ""
        
        var imageView: UIImageView!
        
        override func viewDidLoad() {
            
            imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true //외곽으로 삐져나온 부분들을 컷팅.
                
                $0.image = UIImage(named: imageName)
                
                view.addSubview($0)
                
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            }
        }
    }
    
}
