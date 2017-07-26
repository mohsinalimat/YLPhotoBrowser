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
    
    var imageView:UIImageView!
    var imageView1:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView.init(frame: CGRect.init(x: 10, y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20))
        
        imageView.image = UIImage(named: "1")
        imageView.tag = 0
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ViewController.tapImageView(_:))))
        
        imageView1 = UIImageView.init(frame: CGRect.init(x: YLScreenW / 2 + 10 , y: 100, width: YLScreenW / 2 - 20, height: YLScreenW / 2 - 20))
        
        imageView1.image = UIImage(named: "2")
        imageView1.tag = 1
        view.addSubview(imageView1)
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ViewController.tapImageView(_:))))
        
    }

    func tapImageView(_ tap:UITapGestureRecognizer) {
    
        var photos = [YLPhoto]()
        photos.append(YLPhoto.addImage(imageView.image!, frame: imageView.frame))
        photos.append(YLPhoto.addImage(imageView1.image!, frame: imageView1.frame))
        
        let photoBrowser = YLPhotoBrowser.init(photos, index: (tap.view?.tag)!)
        
        present(photoBrowser, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

