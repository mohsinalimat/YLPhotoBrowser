//
//  ViewController.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

let YLSW = UIScreen.main.bounds.width
let YLSH = UIScreen.main.bounds.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 20, y: 100, width: YLSW - 40, height: YLSW - 40))
        
        imageView.image = UIImage(named: "数组操作")
        
        view.addSubview(imageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

