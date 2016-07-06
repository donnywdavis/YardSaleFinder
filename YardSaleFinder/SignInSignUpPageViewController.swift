//
//  SignInSignUpPageViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 7/6/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class SignInSignUpPageViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: Properties
    
    var currentPage = 0
    var pageViewController: UIPageViewController!
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.delegate = self
        pageViewController.dataSource = self
        let startingViewController = viewControllerAtIndex(0)
        pageViewController.setViewControllers([startingViewController!], direction: .Forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = currentPage
        
        self.addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index: Int) ->  UIViewController? {
        switch index {
        case 0:
            return storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        case 1:
            return storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        default:
            return nil
        }
    }

}

// MARK: Navigation

extension SignInSignUpPageViewController {
    
    @IBAction func unwindToPageViewController(segue: UIStoryboardSegue) {
        currentPage = 1
        pageControl.currentPage = currentPage
        let viewController = viewControllerAtIndex(1)
        pageViewController.setViewControllers([viewController!], direction: .Forward, animated: true, completion: nil)
    }
    
}

// MARK: Page View Controller Delegate and Data Source

extension SignInSignUpPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = currentPage - 1
        
        if index < 0 {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = currentPage + 1
        
        if index == pageControl.numberOfPages {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            pageControl.currentPage = currentPage
        } else {
            switch previousViewControllers[0] {
            case is SignInViewController:
                currentPage += 1
            case is SignUpViewController:
                currentPage -= 1
            default:
                currentPage = 0
            }
            
            pageControl.currentPage = currentPage
        }
    }
    
}
