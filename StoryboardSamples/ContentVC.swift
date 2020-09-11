//
//  ContentVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/08.
//

import UIKit

class ContentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    var dataSource: [[UIViewController.Type]] = [
        [
            JsonSampleVC.self,
            MapKitSampleVC.self,
            NotificationSampleVC.self,
            OrthogonalScrollBehaviorSampleVC.self,
            PageControlSampleVC.self,
            PageVCSampleVC.self,
            SafeAreaSampleVC.self,
            SearchBarSampleVC.self,
            StackViewSampleVC.self,
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storyboard 샘플"
        
        // (옵션) 네비게이션바가 투명하지 않게 함. 기본값 true
//        navigationController?.navigationBar.isTranslucent = false
        
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        
        view.addSubview(tableView)
    }

    //MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableVCType = dataSource[indexPath.section][indexPath.row]
        let vc = tableVCType.init()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = String(describing: dataSource[indexPath.section][indexPath.row])
        
        return cell
    }
    
}

