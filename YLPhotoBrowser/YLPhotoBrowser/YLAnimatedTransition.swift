//
//  YLAnimatedTransition.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLAnimatedTransition: NSObject,UINavigationControllerDelegate {
    
    var beforeImageViewFrame: CGRect! {
        didSet {
            percentIntractive.beforeImageViewFrame = beforeImageViewFrame
        }
    }
    var currentImageViewFrame: CGRect! {
        didSet {
            percentIntractive.currentImageViewFrame = currentImageViewFrame
        }
    }
    var currentImage: UIImage! {
        didSet {
            percentIntractive.currentImage = currentImage
        }
    }
    var gestureRecognizer: UIPanGestureRecognizer! {
        didSet {
            percentIntractive.gestureRecognizer = gestureRecognizer 
        }
    }
    
    private var customPush:YLPushAnimator = YLPushAnimator()
    private var customPop:YLPopAnimator = YLPopAnimator()
    private var percentIntractive:YLDrivenInteractive = YLDrivenInteractive()
    
    deinit {
        print("释放:\(self)")
    }
    
    convenience init(_ image: UIImage,beforeImgFrame: CGRect ,afterImgFrame: CGRect) {
        self.init()
        
        setTransitionImage(image)
        setTransitionBeforeImgFrame(beforeImgFrame)
        setTransitionAfterImgFrame(afterImgFrame)
    }
    
    // 转场过渡的图片
    private func setTransitionImage(_ transitionImage: UIImage) {
        customPush.transitionImage = transitionImage
        customPop.transitionImage = transitionImage
    }
    
    // 转场前的图片frame
    private func setTransitionBeforeImgFrame(_ frame: CGRect) {
        customPush.transitionBeforeImgFrame = frame
        customPop.transitionBeforeImgFrame = frame
        percentIntractive.beforeImageViewFrame = frame
    }
    
    // 转场后的图片frame
    private func setTransitionAfterImgFrame(_ frame: CGRect) {
        customPush.transitionAfterImgFrame = frame
        customPop.transitionAfterImgFrame = frame
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            return customPush
        }else if operation == UINavigationControllerOperation.pop {
            return customPop
        }else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if gestureRecognizer != nil {
            return percentIntractive
        }else {
            return nil
        }
    }
}
