//
//  ZZPageContentViewController.swift
//  ZZPageViewController
//
//  Created by Ju on 16/7/11.
//  Copyright © 2016年 Ju. All rights reserved.
//

import UIKit

class ZZPageContentViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var pageIndex: Int!
    
    var imageFile: String?
    var pageTitle: String?
    
    var labelFrame: CGRect!
    

    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageView()
        setPageTitle()
    }
    
    // MARK: - Helper
    
    fileprivate func setImageView() {
        let imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        if imageFile != nil {
            imageView.image = UIImage(named: imageFile!)
        }
    }
    
    fileprivate func setPageTitle() {
        let titleLabel = UILabel(frame: labelFrame)
        titleLabel.text = pageTitle
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }

}
