//
//  ZZPageViewController.swift
//  PageT
//
//  Created by Ju on 16/7/11.
//  Copyright © 2016年 Ju. All rights reserved.
//

import UIKit

class ZZPageViewController: UIViewController {
    
    // MARK: - Public Properties
    
    // ------------------------------------------------------------------------------
    // Configure when initializer
    var imagesName: [String]!
    
    // ------------------------------------------------------------------------------
    
    // Optinal
    var pagesTitle: [String]?
    
    // All have default setted
    var allowedRecursive: Bool = false
    var hidePageController: Bool = false
    
    // Indicator color
    var pageIndicatorTintColor: UIColor = UIColor.grayColor()
    var currentPageIndicatorTintColor: UIColor = UIColor.blackColor()
    
    // Y position
    lazy var pageControllerY: CGFloat = { [weak self] in
        if let strongSelf = self {
            return strongSelf.view.bounds.size.height - 100
        }
        return 0.0
    }()
    
    lazy var titleY: CGFloat = {
        return 100
    }()
    // ------------------------------------------------------------------------------

    // MARK: - Private Properties

    // Frame of title label & page controller
    private let titleLabelHeight: CGFloat = 30
    private lazy var titleFrame: CGRect = { [weak self] in
        if let strongSelf = self {
            if strongSelf.pagesTitle == nil {
                return CGRectZero
            }
            let x: CGFloat = 0
            let y: CGFloat = strongSelf.titleY - strongSelf.titleLabelHeight
            let width: CGFloat = strongSelf.view.bounds.size.width
            let heigth: CGFloat = strongSelf.titleLabelHeight
            return CGRectMake(x, y, width, heigth)
        }
        return CGRectZero
    }()
    
    private let pageControllerHeight: CGFloat = 50
    private lazy var pageControllerFrame: CGRect = { [weak self] in
        if let strongSelf = self {
            let x: CGFloat = 0
            let y: CGFloat = strongSelf.pageControllerY - strongSelf.pageControllerHeight
            let width = strongSelf.view.bounds.size.width
            let height: CGFloat = strongSelf.pageControllerHeight
            return CGRectMake(x, y, width, height)
        }
        return CGRectZero
    }()
    
    // Page container
    private var pageViewController: UIPageViewController!
    
    // Custom pageController
    private var pageController: UIPageControl!
    
    // Track the index of pageController
    private var lastPageIndex = 0
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pagesTitle != nil && pagesTitle?.count != imagesName.count {
            print("Warning: If you set titles, then titles count must equal images count")
            abort()
        }
        
        setPageViewController()
        setPageController()
    }
    
    // MARK: - Helper
    
    @objc private func setPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startingContentViewController = viewControllerAtIndex(0)
        let viewControllers = [startingContentViewController!]
        pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        pageViewController.view.frame = view.bounds
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }

    @objc private func setPageController() {
        pageController = UIPageControl(frame: pageControllerFrame)
        pageController.numberOfPages = imagesName.count
        pageController.pageIndicatorTintColor = pageIndicatorTintColor
        pageController.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageController.addTarget(self, action: #selector(ZZPageViewController.valueChangeAction), forControlEvents: .ValueChanged)
        view.addSubview(pageController)
        view.bringSubviewToFront(pageController)
        
        // Hide? pageViewController
        pageController.hidden = hidePageController
    }
    
    @objc private func valueChangeAction() {
        let vc = viewControllerAtIndex(pageController.currentPage)
        let viewControllers = [vc!]
        let direction: UIPageViewControllerNavigationDirection = pageController.currentPage > lastPageIndex ? .Forward : .Reverse
        lastPageIndex = pageController.currentPage
        
        pageViewController.setViewControllers(viewControllers, direction: direction, animated: true, completion: nil)
    }
    
    @objc private func viewControllerAtIndex(index: Int) -> UIViewController? {
        if imagesName.count == 0 || index >= imagesName.count {
            return nil
        }
        let pageContentViewControllr = ZZPageContentViewController()
        if pagesTitle != nil {
            pageContentViewControllr.pageTitle = pagesTitle![index]
        }
        pageContentViewControllr.labelFrame = titleFrame
        pageContentViewControllr.imageFile = imagesName[index]
        pageContentViewControllr.pageIndex = index

        return pageContentViewControllr
    }
}


// MARK: - Page View DataSource

extension ZZPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let pageContentViewController = viewController as! ZZPageContentViewController
        var index = pageContentViewController.pageIndex
        
        if index == NSNotFound { return nil }
        
        if allowedRecursive {
            if index == 0 {
                index = imagesName.count - 1
                return viewControllerAtIndex(index)
            }
        } else {
            if index == 0 { return nil }
        }
        
        index = index - 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let pageContentViewController = viewController as! ZZPageContentViewController
        var index = pageContentViewController.pageIndex
        if index == NSNotFound { return nil }
        index = index + 1
        
        if allowedRecursive {
            if index == imagesName.count {
                index = 0
                return viewControllerAtIndex(index)
            }
        } else {
            if index == imagesName.count {
                // MARK: TO-DO [Add action, if you want]
                return nil
            }
        }
        
        return viewControllerAtIndex(index)
    }
}

// MARK: - Page View Delegate

extension ZZPageViewController: UIPageViewControllerDelegate {
    
    // For the custom pageController
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let firstPageContentViewController = pendingViewControllers.first! as! ZZPageContentViewController
        pageController.currentPage = firstPageContentViewController.pageIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        lastPageIndex = pageController.currentPage
    }
    
}


