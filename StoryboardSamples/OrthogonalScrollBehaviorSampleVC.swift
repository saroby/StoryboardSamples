//
//  OrthogonalScrollBehaviorSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/10.
//

import UIKit

// 패딩: 컨텐츠 밖으로 넓히는 영역 (컨텐츠의 사이즈가 바뀜)
// 마진: 컨텐츠 안으로 줄이는 영역 (컨텐츠의 사이즈가 안바뀜)
// 결론: groupPagingCentered에선 패딩과 그룹거리는 사용하지 않는 것이 좋겠다 (확인 버전:Version 12.0 beta 6)

class OrthogonalScrollBehaviorSampleVC: UIViewController, UICollectionViewDelegate {

    var dataSource: UICollectionViewDiffableDataSource<Int/*SectionIdentifierType*/, Int/*ItemIdentifierType*/>!
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 화면 구성.
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCollectionViewLayout()).then {
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.backgroundColor = .systemBackground
            view.addSubview($0)
            
            $0.delegate = self
        }
        
        // "셀 등록" 생성과 함께 셀 핸들러를 연결
        let textCellRegisteration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "\(indexPath.section), \(identifier)"
            cell.contentView.backgroundColor = .yellow
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        // 데이터 스토리지 생성과 함께 privider연결.
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: textCellRegisteration, for: indexPath, item: identifier)
        })
        .then {
            let supplementaryRegistration = UICollectionView.SupplementaryRegistration
            <TitleSupplementaryView>(elementKind: "Header") { //TODO: init 파라미터로 elementKind를 넣는 이유를 모르겠다. 이 파라미터의 용도가 뭔지 알아봐야겠다.
                (supplementaryView, kind, indexPath) in
                supplementaryView.label.text = kind + " header"
            }

            $0.supplementaryViewProvider = { (collectionView, kind, indexPath) in
                if kind == "section_header" {
                    return collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
                } else {
                    return nil
                }
            }
        }
        
        // 더미데이터 추가
        var snapshot = NSDiffableDataSourceSnapshot<Int/*SectionIdentifierType*/, Int/*ItemIdentifierType*/>()
        snapshot.appendSections([ 0 ])
        
        //appendItems(<#T##identifiers: [Int]##[Int]#>)는 마지막 섹션에 아이템을 추가한다.
        //appendItems(<#T##identifiers: [Int]##[Int]#>, toSection: <#T##Int?#>)는 section identifier에 해당하는 section에 아이템을 추가한다.
        snapshot.appendItems(Array(0..<20))
        snapshot.appendSections([ 1 ])
        snapshot.appendItems(Array(20..<40)) // 마지막 섹션에 추가된다.

        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        UICollectionViewCompositionalLayout(sectionProvider: { (sectionIdx:Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))

            let innterGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 2)
                .then {
                    // 아이템 간 거리
                    $0.interItemSpacing = .fixed(10)
                }
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .fractionalHeight(0.5)),
                // NSCollectionLayoutGroup, NSCollectionLayoutItem를 subitems에 넣을 수 있다.
                subitems: [ innterGroup ])
                .then {
                    // 주의: groupPagingCentered 모드에서 좌우 edgeSpacing를 넣으면 가운데 정렬이 되지 않는다. (계산값이 잘못되는 버그인듯)
//                    $0.edgeSpacing = .init(leading: .fixed(5), top: .fixed(5), trailing: .fixed(5), bottom: .fixed(5))
                    
                    // 그룹 마진
                    $0.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                }
            
            let section = NSCollectionLayoutSection(group: group).then {
                // none: 스크롤을 사용하지 않음
                // continuous: 스냅없이 스크롤
                // continuousGroupLeadingBoundary: 스냅속도가 느린 것 빼고는 groupPaging과 다른점을 모르겠다.
                // paging: 화면 사이즈 만큼 paging 스크롤. (화면의 사이즈와 그룹사이즈가 같지 않으면 이상하게 보이지만, 애플이 제안하는 컨셉에 따라 움직이므로 이상한 건 아니다)
                // groupPaging: 그룹 스냅 왼쪽 정렬 스크롤
                // groupPagingCentered: 그룹 스냅 가운데 정렬 스크롤
                $0.orthogonalScrollingBehavior = .groupPaging
                
                // 그룹 간 거리.
                // 주의: groupPagingCentered 모드에서 interGroupSpacing를 넣으면 가운데 정렬이 되지 않는다. (계산값이 잘못되는 버그인듯)
//                $0.interGroupSpacing = 20
                
                // 섹션의 마진
                //$0.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                
                // 섹션 헤더 추가
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
                    elementKind: "section_header", // 이 SupplementaryItem의 종류. Provider 측에서 어떤 item을 사용할지 알아내는 일종의 identifier.
                    alignment: .top)
                $0.boundarySupplementaryItems = [header]
            }
            
            return section
        }, configuration: UICollectionViewCompositionalLayoutConfiguration().then {
            // 섹션 같 거리
            $0.interSectionSpacing = 30
        })
    }
    

    //MARK: UICollectionViewDelegate:
    //TODO
}

extension OrthogonalScrollBehaviorSampleVC {
    
    class TextCell: UICollectionViewCell {
        let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        required init?(coder: NSCoder) {
            fatalError("not implemnted")
        }

        func configure() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontForContentSizeCategory = true
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
    
    class TitleSupplementaryView: UICollectionReusableView {
        let label = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        func configure() {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontForContentSizeCategory = true
            let inset = CGFloat(10)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
                label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
            ])
            label.font = UIFont.preferredFont(forTextStyle: .title3)
        }
    }
    
}


// 많은 개발자가 UITableViwe보다 UICollectionView를 이용해 화면을 구성해도, 나는 swpipe액션 추가가 쉽다는 이유로 UITableView를 많이 사용해왔다.
// UITableView를 이용한 화면구성은 iPhone에는 적합할 지 몰라도, iPad같이 넓은 화면에서 하나의 cell이 한 줄을 모두 차지하는 것은 부적합해 보인다는 이유로 고민을 해왔다. (UICollectionView를 이용한다면, 동적인 넓이에 item수를 대응시킬 수 있어서 더 적합한 화면구성을 할 수 있다)
// https://developer.apple.com/videos/play/wwdc2020/10097
// https://medium.com/@idmarystar/%EC%9D%B4%EB%B2%88-wwdc%EC%97%90%EC%84%9C%EB%8A%94-uicollectionview%EC%9D%98-%EC%83%88%EB%A1%9C%EC%9A%B4-%EC%8A%A4%ED%83%80%EC%9D%BC%EC%9D%B4-%EC%86%8C%EA%B0%9C%EB%90%98%EC%97%88%EC%8A%B5%EB%8B%88%EB%8B%A4-c15f1abb5386
// 기사 내용중에 swipe 액션이 더이상 UITableView의 전유물이 아니다라고 이야기를 한다.
// 앞서가는 생각일 지 모르겠지만, UITableView를 사용할 이유가 익숙함 이외에는 더이상 없지 않을까?

// 애플에서 제안하는 모던 코딩스타일인 UICollectionViewDiffableDataSource을 보면, delegate 연결방식을 버리고, privider closure를 사용하고 있다는 걸 알 수 있다.
// SwiftUI 스타일에 더 유사하달까, 더 세련된 코딩스타일 임은 분명하다.
