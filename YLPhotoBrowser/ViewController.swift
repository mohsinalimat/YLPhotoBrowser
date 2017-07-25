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
        
        var photos = [YLPhoto]()
        photos.append(YLPhoto.addImage(imgView.image!, frame: imgView.frame))
        
        let photoBrowser = YLPhotoBrowser.init(self, photos: photos, index: 0)
        
        navigationController?.pushViewController(photoBrowser, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

