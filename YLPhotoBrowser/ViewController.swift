//
//  ViewController.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var animatedTransition:YLAnimatedTransition = YLAnimatedTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 10, y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20))
        
        imageView.image = UIImage(named: "数组操作")
        
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ViewController.tapImageView(_:))))
        
        let imageView1 = UIImageView.init(frame: CGRect.init(x: YLScreenW / 2 + 10 , y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20))
        
        imageView1.image = UIImage(named: "数组操作")
        
        view.addSubview(imageView1)
        
    }

    func tapImageView(_ tap:UITapGestureRecognizer) {
    
        let imgView = tap.view as! UIImageView
        
        navigationController?.delegate = animatedTransition
        
        animatedTransition.setTransitionImgView(imgView)
        animatedTransition.setTransitionBeforeImgFrame(imgView.frame)
        animatedTransition.setTransitionAfterImgFrame(CGRect.init(x: 0, y: 84, width: YLScreenW, height: YLScreenW))
        
        navigationController?.pushViewController(YLPhotoBrowser(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

