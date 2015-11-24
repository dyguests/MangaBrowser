//
//  ViewController.swift
//  MangaBrower
//
//  Created by 范鸿麟 on 15/10/14.
//  Copyright © 2015年 范鸿麟. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var bottomContainerBottomLayoutGuide: NSLayoutConstraint!
    
    //演示用图片
    var images = ["5.jpg","1.png","2.png","3.png","4.png"]
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //全屏切换
    @IBAction func onViewTapped(sender: UITapGestureRecognizer) {
        //        print("onViewTapped")
        
        let isFullScreen = !super.navigationController!.navigationBarHidden
        
        //导航栏
        super.navigationController?.setNavigationBarHidden(isFullScreen, animated: true)
        //        super.navigationController?.setToolbarHidden(isFullScreen, animated: true)
        
        //底部Slider
        bottomContainerBottomLayoutGuide.constant = isFullScreen ? -40 : 20
        UIView.animateWithDuration(0.25, animations: {self.bottomContainer.layoutIfNeeded()})
    }

    //不知道是做什么的
//    @IBAction func swipeLeft(sender: AnyObject) {
//        print("SWipe left")
//    }
//    
//    @IBAction func swiped(sender: AnyObject) {
//        self.pageViewController.view.removeFromSuperview()
//        self.pageViewController.removeFromParentViewController()
//        reset()
//    }
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: .Forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height /*- 30*/)
        self.addChildViewController(pageViewController)
        
        //        self.view.addSubview(pageViewController.view)
        self.contentView.addSubview(pageViewController.view)
        
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    //没用的
//    @IBAction func start(sender: AnyObject) {
//        let pageContentViewController = self.viewControllerAtIndex(0)
//        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        index++
        if(index == self.images.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        if(index == 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.images.count == 0) || (index >= self.images.count) || (index < 0)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        
        pageContentViewController.viewController = self//换页用
        pageContentViewController.imageName = self.images[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return images.count
    }

    //加了这个方法适配时iPhone4,5显示界面不全
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
    
    //#Custom
    
//    func changePage(direction:UIPageViewControllerNavigationDirection) {
//        var pageIndex = (pageViewController.viewControllers![0] as! PageContentViewController).pageIndex!
//        
//        if (direction == UIPageViewControllerNavigationDirection.Forward) {
//            pageIndex++
//        } else {
//            pageIndex--
//        }
//        
//        if let viewController = viewControllerAtIndex(pageIndex) {
//            self.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
//        }
//    }
}

