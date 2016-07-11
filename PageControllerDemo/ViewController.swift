//
//  ViewController.swift
//  PageControllerDemo
//
//  Created by Ju on 16/7/11.
//  Copyright © 2016年 Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var pageViewController: ZZPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = ZZPageViewController()
        pageViewController.images = ["login1", "login2", "login3"]
//        pageViewController.titles = ["Page 0", "Page 1", "Page 2"]
        
        pageViewController.pageControllerY = view.bounds.size.height / 2
        
        addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        view.addSubview(pageViewController.view)
    }
}

