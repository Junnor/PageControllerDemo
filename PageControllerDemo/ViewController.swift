//
//  ViewController.swift
//  PageControllerDemo
//
//  Created by Ju on 16/7/11.
//  Copyright © 2016年 Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var pageViewController: ZZPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = ZZPageViewController()
        pageViewController.imagesName = ["login1", "login2", "login3"]
        pageViewController.pagesTitle = ["Page 0", "Page 1", "Page 2"]
                
        addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        view.addSubview(pageViewController.view)
    }
}

