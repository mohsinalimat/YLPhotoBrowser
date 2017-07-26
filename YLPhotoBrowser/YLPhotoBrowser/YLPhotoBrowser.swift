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
    
    private var transitionImgViewCenter = CGPoint.init(x: YLScreenW/2, y: YLScreenH/2)
    
    var imageView: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.delegate = nil
        disappearAnimatedTransition = nil
    }
    
    deinit {
        
        delegate?.navigationController?.delegate = nil
        delegate = nil
        appearAnimatedTransition = nil
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

        view.isUserInteractionEnabled = true
        
        view.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.imageViewPan(_:))))
    }
    
    func imageViewPan(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in:  pan.view)
        
        var scale = 1 - translation.y / YLScreenH
        
        scale = scale > 1 ? 1:scale
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

            imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            
            imageView.center = CGPoint.init(x: transitionImgViewCenter.x + translation.x * scale, y: transitionImgViewCenter.y + translation.y * scale)
            
            break
        case .failed,.cancelled,.ended:
            
            if translation.y <= 80 {
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
