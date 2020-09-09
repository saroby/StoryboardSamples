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
            NotificationSampleVC.self,
            JsonSampleVC.self,
            StackViewSampleVC.self,
            PageControlSampleVC.self,
            SafeAreaSampleVC.self,
            PageVCSampleVC.self,
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storyboard 샘플"
        
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

