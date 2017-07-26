//
//  YLPopAnimator.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPopAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    var transitionImage: UIImage?
    var transitionBeforeImgFrame: CGRect = CGRect.zero
    var transitionAfterImgFrame: CGRect = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 转场过渡的容器view
        let containerView = transitionContext.containerView
        
        // FromVC
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = fromViewController?.view
        fromView?.isHidden = true
        
        // ToVC
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = toViewController?.view
        containerView.addSubview(toView!)
        toView?.isHidden = false
        
        // 有渐变的黑色背景
        let bgView = UIView.init(frame: containerView.bounds)
        bgView.backgroundColor = PhotoBrowserBG
        bgView.alpha = 1
        containerView.addSubview(bgView)
        
        // 过渡的图片
        let transitionImgView = UIImageView.init(image: self.transitionImage)
        transitionImgView.frame = self.transitionAfterImgFrame
        containerView.addSubview(transitionImgView)
        
        if transitionImage == nil ||
            transitionBeforeImgFrame == CGRect.zero {
            
            bgView.removeFromSuperview()
            transitionImgView.removeFromSuperview()
            
            //  设置transitionContext通知系统动画执行完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            return
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] in
            
            transitionImgView.frame = (self?.transitionBeforeImgFrame)!
            bgView.alpha = 0
            
        }) { (finished:Bool) in
            
            bgView.removeFromSuperview()
            transitionImgView.removeFromSuperview()
            
            //  设置transitionContext通知系统动画执行完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
}
