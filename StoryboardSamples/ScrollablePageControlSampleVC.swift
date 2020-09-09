//
//  ScrollablePageControlSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/09.
//

import UIKit

class ss: UIPageViewController {
    
}

class ScrollablePageControlSampleVC: UIViewController {

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

        // Do any additional setup after loading the view.
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


//extension ScrollablePageControlSampleViewController: UIPageViewControllerDelegate {
//    
//}
