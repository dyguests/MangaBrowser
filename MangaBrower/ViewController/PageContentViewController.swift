//
//  PageContentViewController.swift
//  MangaBrower
//
//  Created by 范鸿麟 on 15/10/14.
//  Copyright © 2015年 范鸿麟. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController , UIGestureRecognizerDelegate{
    var SCALE_MAX:CGFloat = 3
    var SCALE_MIN:CGFloat = 1
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var imageView:UIImageView!
    
    var viewController:ViewController!//换页用
    var pageIndex: Int?
    var imageName : String!
    
    var mainFrame:CGRect!
    var lastScale:CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.userInteractionEnabled = true
        
//        print("parentViewController \(parentViewController)")
        
        panGesture.delegate = self
        
        let image = UIImage(named: imageName)!
        imageView = UIImageView(image: image)
        //        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        initImageView()
        
        self.view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        if (self.view.superview != nil) {
//            if (gestureRecognizer == self.panGesture) {
//                //以下部分判断 执行 平移图片(PanGesture) 还是 翻页(PageViewController)
//                let translate = panGesture.translationInView(self.view)
//                if isHoriSwipe(translate) {
//                    return false
//                }
//                
//                self.view.touchesBegan([touch], withEvent: nil)
//                return true // handle the touch
//            }
//        }
//        return true // handle the touch
//    }
    
    //关键代码 解决 PanGesture 与 PageViewController 的分发问题
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.panGesture) {
            let translate = panGesture.translationInView(self.view)
//            print("translate \(translate)")
            if isHoriSwipe(translate) {
                return true
            }
        }
        return false
    }
    

    
    @IBAction func onPinch(sender: UIPinchGestureRecognizer) {
        lastScale *= sender.scale
        
        //禁止过大过小
        if lastScale > SCALE_MAX {
            lastScale = SCALE_MAX
        }else if lastScale < SCALE_MIN {
            lastScale = SCALE_MIN
        }
        
        self.imageView.transform = CGAffineTransformScale(self.view.transform, lastScale,lastScale)
        sender.scale = 1
        
        //平移后的位置
        var centerX = imageView.center.x
        var centerY = imageView.center.y
        boundCenter(&centerX, centerY: &centerY)
        imageView.center = CGPoint(x:centerX,y:centerY)
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let translate = sender.translationInView(self.view)
        
//        if isHoriSwipe(translate) {
////            self.view.touchesEnded(sender.touch, withEvent: <#T##UIEvent?#>)
//            panGesture.enabled = false
//            panGesture.enabled = true
//            
//            if translate.x > 0 {
//                viewController.changePage(.Reverse)
//            }else if translate.x < 0 {
//                viewController.changePage(.Forward)
//            }
//        }
        
//        print("平移前(\(imageView.center.x),\(imageView.center.y)) 偏移值(\(translate.x),\(translate.y))")
        
        //平移后的位置
        var centerX = imageView.center.x + translate.x
        var centerY = imageView.center.y + translate.y
        boundCenter(&centerX, centerY: &centerY)
        imageView.center = CGPoint(x:centerX,y:centerY)
        
//        print("平移后(\(imageView.center.x),\(imageView.center.y))")

        sender.setTranslation(CGPointZero, inView: self.view)
    }
    
    func initImageView(){
        let image = imageView.image!
        
        //初始化imageView的大小
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let mainWidth = self.view.frame.width
        let mainHeight = self.view.frame.height
        
        //boundCenter() 取 mainFrame 值时,取不到正确的值,临时用这个替代方案
        mainFrame = self.view.frame
        
        var destX:CGFloat
        var destY:CGFloat
        var destWidth:CGFloat
        var destHeight:CGFloat
        
        if imageWidth * mainHeight > imageHeight * mainWidth {
            destWidth = mainWidth
            destHeight = imageHeight * mainWidth / imageWidth
            destX = 0
            destY = (mainHeight - destHeight)/2
        }else{
            destWidth = imageWidth * mainHeight / imageHeight
            destHeight = mainHeight
            destX = (mainWidth - destWidth)/2
            destY = 0
        }
        
        imageView.frame = CGRect(x: destX, y: destY, width: destWidth, height: destHeight)
        
//        print("self.view \(self.view)")
//        let mainFrame = self.view.frame
//        let imageFrame = imageView.frame
//        print("init mainFrame.size(\(mainFrame.width),\(mainFrame.height)) imageFrame.size(\(imageFrame.width),\(imageFrame.height))")
    }
    
    // 限制iamgeView中心的位置
    //当图片大于屏幕时,平移图片时防止平移过头
    func boundCenter(inout centerX:CGFloat,inout centerY:CGFloat){
        //boundCenter() 取 mainFrame 值时,取不到正确的值,临时用这个替代方案
//        let mainFrame = self.view.frame
        
        let imageFrame = imageView.frame
        
//        print("self.view \(self.view)")
//        print("mainFrame.size(\(mainFrame.width),\(mainFrame.height)) imageFrame.size(\(imageFrame.width),\(imageFrame.height))")
        
        if imageFrame.width <= mainFrame.width {
            centerX = mainFrame.width / 2
        }else{
            let xMin = mainFrame.width - imageFrame.size.width / 2
            let xMax = imageFrame.size.width / 2
            if centerX > xMax {
                centerX = xMax
            }else if centerX < xMin {
                centerX = xMin
            }
        }
        
        if imageFrame.height <= mainFrame.height {
            centerY = mainFrame.height / 2
        }else{
            let yMin = mainFrame.height - imageFrame.size.height / 2
            let yMax = imageFrame.size.height / 2
            if centerY > yMax {
                centerY = yMax
            }else if centerY < yMin {
                centerY = yMin
            }
        }
    }
    
    //以下部分判断 执行 平移图片(PanGesture) 还是 翻页(PageViewController)
    //只做水平方向的处理
    func isHoriSwipe(translate:CGPoint)->Bool {
        //平移后的位置
        let centerX = imageView.center.x + translate.x
//        let centerY = imageView.center.y + translate.y
        
        let imageFrame = imageView.frame
        
        if imageFrame.width <= mainFrame.width {
            return true
        }else{
            let xMin = mainFrame.width - imageFrame.size.width / 2
            let xMax = imageFrame.size.width / 2
            if centerX > xMax {
                return true
            }else if centerX < xMin {
                return true
            }
        }
        
        return false
    }
}
