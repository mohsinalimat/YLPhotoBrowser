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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = PhotoBrowserBG
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 84, width: YLScreenW, height: YLScreenW))
        
        imageView.image = UIImage(named: "数组操作")
        
        view.addSubview(imageView)

        transitionImgViewCenter = imageView.center
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.imageViewPan(_:))))
    }
    
    func imageViewPan(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in:  pan.view)
        var scale = 1 - fabs(translation.y / YLScreenH)
        scale = scale < 0 ? 0:scale
        
        print("second = \(scale)")
        
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
            imageView.center = CGPoint.init(x: transitionImgViewCenter.x + translation.x * scale, y: transitionImgViewCenter.y + translation.y)
            imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            animatedTransition?.beforeImageViewFrame = CGRect.init(x: 10, y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20)
            
            
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
            navigationController?.delegate = animatedTransition
            
            break
        default:
            break
        }
        
    }
    
}












