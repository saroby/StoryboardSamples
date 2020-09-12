//
//  SwipePageExampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/13.
//

import UIKit

class SwipePageExampleVC: UIViewController {

    let pages = [
        "1",
        "2",
        "3",
        "4",
    ]
    
    var collectionView: UICollectionView!
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if layout.scrollDirection == .horizontal {
                let x = targetContentOffset.pointee.x
                pageControl.currentPage = Int(x / view.frame.width)
            } else if layout.scrollDirection == .vertical {
                let y = targetContentOffset.pointee.y
                pageControl.currentPage = Int(y / view.frame.width)
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 화면 구성.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout).then {
            $0.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
            $0.contentInsetAdjustmentBehavior = .never // 이 셋팅을 해주어야만 scrollToItem함수가 정상 작동한다.
            $0.isPagingEnabled = true
            $0.backgroundColor = .red
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            view.addSubview($0)
            $0.delegate = self
            $0.dataSource = self
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
        
        setupBottomControls()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            
            self.collectionView.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
            
        }
    }
    
}

extension SwipePageExampleVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell

        let page = pages[indexPath.item]
        cell.label.text = page
        return cell
    }
    
}

extension SwipePageExampleVC: UICollectionViewDelegate {
    
}

extension SwipePageExampleVC: UICollectionViewDelegateFlowLayout {
    
    // 특정 섹션에서의 아이템 간격
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        0
//    }
    
    // 아이템 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}

extension SwipePageExampleVC {
    
    class PageCell: UICollectionViewCell {
        
        let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        required init?(coder: NSCoder) {
            fatalError("not implemnted")
        }

        func configure() {
            contentView.backgroundColor = .yellow
            contentView.layer.borderColor = UIColor.black.cgColor
            contentView.layer.borderWidth = 1
            contentView.layer.cornerRadius = 8
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontForContentSizeCategory = true
            label.textAlignment = .center
            contentView.addSubview(label)
            label.font = UIFont.preferredFont(forTextStyle: .caption1)
            let inset = CGFloat(10)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
                label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
        }
    }
    
}
