//
//  YLPhoto.swift
//  YLPhotoBrowser
//
//  Created by 朱云龙 on 17/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLPhoto {
    
    var image: UIImage?
    var frame: CGRect?
    
    class func addImage(_ image: UIImage,frame: CGRect?) -> YLPhoto {
        let photo = YLPhoto()
        photo.image = image
        photo.frame = frame
        return photo
    }
    
    
}
