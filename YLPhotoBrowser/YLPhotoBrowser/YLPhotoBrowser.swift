//
//  YLPhotoBrowser.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import Foundation
import UIKit

let PhotoBrowserBG = UIColor.black

let YLScreenW = UIScreen.main.bounds.width
let YLScreenH = UIScreen.main.bounds.height

class YLPhotoBrowser: UIViewController {
    
    private var animatedTransition:YLAnimatedTransition?
    
    private var transitionImgViewCenter = CGPoint.zero
    
    var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        animatedTransition = nil
        imageView = nil
    }
    
    convenience init() {
        self.init()
        
        
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = PhotoBrowserBG
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: YLScreenW, height: YLScreenH))
        
        imageView.image = UIImage(named: "数组操作")
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        view.addSubview(imageView)

        transitionImgViewCenter = imageView.center
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.imageViewPan(_:))))
    }
    
    func imageViewPan(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in:  pan.view?.superview)
        
        let offset = (pan.view?.center.y)! - YLScreenH / 2
        
        var scale = 1 - fabs(offset / YLScreenH)
        
        scale = scale < 0 ? 0:scale
        
        print("scale:\(scale)")
        
        switch pan.state {
        case .possible:
            break
        case .began:
            animatedTransition = nil
            animatedTransition = YLAnimatedTransition()
            navigationController?.delegate = animatedTransition
            animatedTransition?.gestureRecognizer = pan
            
            self.navigationController?.popViewController(animated: true)
            
            break
        case .changed:

            imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            
            imageView.center = CGPoint.init(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
            pan.setTranslation(CGPoint.zero, in: pan.view?.superview)
            
            break
        case .failed,.cancelled,.ended:
            
            if scale > 0.9 {
                UIView.animate(withDuration: 0.2, animations: {
                    [weak self] in
                    
                    self?.imageView.center = (self?.transitionImgViewCenter)!
                    self?.imageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    }, completion: { [weak self] (finished: Bool) in
                    
                        self?.imageView.transform = CGAffineTransform.identity
                        
                })
            }else {
                self.imageView.isHidden = true
            }
            
            animatedTransition?.currentImageView = imageView
            animatedTransition?.currentImageViewFrame = imageView.frame
            animatedTransition?.beforeImageViewFrame = CGRect.init(x: 10, y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20)
            
            break
        default:
            break
        }
        
    }
    
}












