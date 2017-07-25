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
    // 图片
    private var photos: [YLPhoto]?
    // 代理
    private var delegate: UIViewController?
    
    private var appearAnimatedTransition:YLAnimatedTransition? // 进来的动画
    private var disappearAnimatedTransition:YLAnimatedTransition? // 出去的动画
    
    private var transitionImgViewCenter = CGPoint.zero
    
    var imageView: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.delegate = nil
        delegate?.navigationController?.delegate = nil
        delegate = nil
        appearAnimatedTransition = nil
        disappearAnimatedTransition = nil
    }
    
    deinit {
        print("释放:\(self)")
    }
    
    convenience init(_ target:Any,photos: [YLPhoto],index: Int) {
        self.init()
        
        let photo = photos[index]
        
         let height = YLScreenW * ((photo.image?.size.height)! / (photo.image?.size.width)!)
        
        appearAnimatedTransition = nil
        appearAnimatedTransition = YLAnimatedTransition.init(photo.image!, beforeImgFrame: photo.frame!, afterImgFrame: CGRect.init(x: 0, y: YLScreenH/2 - height/2, width: YLScreenW, height: height))
        
        delegate = (target as! UIViewController)
        
        delegate?.navigationController?.delegate = appearAnimatedTransition
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
        
        let offsetY = (pan.view?.center.y)! - YLScreenH / 2
        
        var scale = 1 - fabs(offsetY / YLScreenH)
        
        scale = scale < 0 ? 0:scale
        
        switch pan.state {
        case .possible:
            break
        case .began:
            
            disappearAnimatedTransition = nil
            disappearAnimatedTransition = YLAnimatedTransition()
            disappearAnimatedTransition?.gestureRecognizer = pan
            navigationController?.delegate = disappearAnimatedTransition
            (self.navigationController)!.popViewController(animated: true)
            
            break
        case .changed:

            let ts =  pan.translation(in:  pan.view)
            let absX = fabs(ts.x)
            let absY = fabs(ts.y)
            
            if absY < 10 && absX > 10 {
                return
            }else
                if ts.y > 0 {
            
                imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                
                imageView.center = CGPoint.init(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
                pan.setTranslation(CGPoint.zero, in: pan.view?.superview)
                
            }
            
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
            
            disappearAnimatedTransition?.currentImage = imageView.image
            disappearAnimatedTransition?.currentImageViewFrame = imageView.frame
            disappearAnimatedTransition?.beforeImageViewFrame = CGRect.init(x: 10, y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20)
            
            break
        }
        
    }
    
}
