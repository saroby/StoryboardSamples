//
//  SearchBarSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/10.
//

import UIKit

class SearchBarSampleVC: UIViewController, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, CellData/*ItemIdentifierType*/>!
    
    var cellDatas: [CellData] = [
        CellData(text: "a"),
        CellData(text: "ab"),
        CellData(text: "abc"),
        CellData(text: "abcd"),
        CellData(text: "abcde"),
        CellData(text: "abcdef"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = view.then {
            
            $0.backgroundColor = .systemBackground            
        }
        
        // NOTICE:
        // 사용자가 View에 addSubView로 UISearchBar 인스턴스를 넣으면 navigationBar에 들어가지 않는다.
        // navigationItem.searchController에 인스턴스를 할당하면 SearchBar View가 자동으로 생긴다.
        _ = UISearchController(searchResultsController: nil).then { //TODO: searchResultsController 파라미터를 넣는 샘플은 나중에 만들어야 한다.
            $0.delegate = self
            $0.searchResultsUpdater = self
            
//            $0.searchBar.delegate = self
            navigationItem.searchController = $0
            
            // (옵션) 검색 필드가 활성 상태일때는 검색바 이외의 뷰를 흐림바탕화면 처리한다. 기본값 true
            $0.obscuresBackgroundDuringPresentation = false
            // (옵션) 비어있을 때 텍스트
            $0.searchBar.placeholder = "검색"
            // (옵션) 스크롤 할 때 검색바 숨기기. 기본값 true
//            navigationItem.hidesSearchBarWhenScrolling = false
            
        }
        // modal의 presenter가 될 수 있는 viewController들은 definesPresentationContext = true인 것들이다.
        // TabbarController, NavigationController 등 외 ViewContorller등은 기본값이 false이므로 modal을 직접 띄우지 못한다.
        // 만약 프로퍼티를 true로 수정한다면, modal을 띄워야 할 때 현재 VC에서 표시한다.
        // 참고: https://magi82.github.io/ios-modal-presentation-style-01/
        // 참고: https://devmjun.github.io/archive/SearchController
//        definesPresentationContext = true
                
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2 // 넓이가 800이상이면 item 3개를 한 줄에 넣는다.
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }).then {
            
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.backgroundColor = .systemBackground
            view.addSubview($0)
            $0.delegate = self
        }
        
        let cellRegistration = UICollectionView.CellRegistration<TextCell, CellData> { (cell, indexPath, cellData) in
            
            cell.label.text = cellData.text
        }
        
        
        dataSource = UICollectionViewDiffableDataSource<Section, CellData>(collectionView: self.collectionView, cellProvider: { (view, indexPath, itemId) -> UICollectionViewCell? in
            
            view.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemId)
        }).then {
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
            snapshot.appendSections([.main])
            snapshot.appendItems(cellDatas)
            $0.apply(snapshot)
        }
        
    }
    
}

extension SearchBarSampleVC: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        let filteredCellDatas: [CellData]!
        if searchText.isEmpty {
            filteredCellDatas = cellDatas
        } else {
            filteredCellDatas = cellDatas.filter({ $0.text.lowercased().contains(searchText.lowercased()) })
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCellDatas)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
}

extension SearchBarSampleVC {
    
    enum Section: CaseIterable {
        case main
    }
    
    // Hashable 프로토콜은 Equatable를 상속하고 있어서, == 비교를 hashValue로 한다.
    // hashValue는 자동생성어 유저가 직접 넣어주지 않아도 된다. 단, 저장 프로퍼티들이 Hashable을 준수해야 한다. (int, stirng, float 등은 저장 변수들은 Hashable를 상속하진 않지만, 그 자체로 값을 가지므로 Hashable을 준수하는 것으로 보인다.)
    struct CellData: Hashable {
        var text: String
    }
    
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
            contentView.backgroundColor = .yellow
            contentView.layer.borderColor = UIColor.black.cgColor
            contentView.layer.borderWidth = 1
            contentView.layer.cornerRadius = 8

            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontForContentSizeCategory = true
            contentView.addSubview(label)
            label.textAlignment = .center
            label.font = UIFont.preferredFont(forTextStyle: .title1)
            
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
