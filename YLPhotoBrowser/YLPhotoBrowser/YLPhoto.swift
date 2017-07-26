//
//  YLPhoto.swift
//  YLPhotoBrowser
//
//  Created by 朱云龙 on 17/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPhoto {
    
    var image: UIImage? // 图片
    var frame: CGRect?  // 在屏幕上的位置
    var imageUrl: String = ""    // 图片url
    
    class func addImage(_ image: UIImage?,imageUrl: String?,frame: CGRect?) -> YLPhoto {
        let photo = YLPhoto()
        photo.image = image
        photo.imageUrl = imageUrl ?? ""
        photo.frame = frame
        return photo
    }
}
