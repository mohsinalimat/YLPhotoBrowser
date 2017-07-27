//
//  YLPhotoCell.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/27.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Kingfisher

class YLPhotoCell: UICollectionViewCell {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect.zero)
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.maximumZoomScale = 4.0
        sv.minimumZoomScale = 1.0
        return sv
    }()
    
    // 图片容器
    let imageView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.clear
        imgView.tag = ImageViewTag
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        return imgView
        
    }()
    
    // 进度条
    let progressView: YLPhotoProgressView = {
        let p = YLPhotoProgressView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        p.progress = 0
        p.isHidden = true
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        
        backgroundColor = UIColor.clear
        
        scrollView.frame = self.bounds
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        
        addSubview(progressView)
        progressView.center = scrollView.center
    }
    
    func updatePhoto(_ photo: YLPhoto) {
    
        if photo.imageUrl != "" {
            
            imageView.frame.size = CGSize.init(width: YLScreenW - 40, height: YLScreenW - 40)
            imageView.center = ImageViewCenter
            
            progressView.isHidden = false
            
            imageView.kf.setImage(with: URL(string: photo.imageUrl), placeholder: nil, options: [.transition(.fade(1))], progressBlock: { [weak self](receivedSize:Int64, totalSize:Int64) in
            
                self?.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                
            }, completionHandler: { [weak self] (image:Image?, _, _, _) in
            
                self?.progressView.isHidden = true
                
                guard let img = image else {
                    
                    return
                }
                self?.imageView.frame = YLPhotoBrowser.getImageViewFrame(img.size)
                self?.imageView.image = img
                photo.image = image
                
                self?.scrollView.contentSize = self?.imageView.frame.size ?? CGSize.zero
            })
            
        }else if let image = photo.image {
            
            imageView.frame = YLPhotoBrowser.getImageViewFrame(image.size)
            imageView.image = image
            scrollView.contentSize = imageView.frame.size
            
        }
    }
    
}

extension YLPhotoCell: UIScrollViewDelegate {
    
    // 设置UIScrollView中要缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 让UIImageView在UIScrollView缩放后居中显示
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let size = scrollView.bounds.size
        
        let offsetX = (size.width > scrollView.contentSize.width) ?
            (size.width - scrollView.contentSize.width) * 0.5 : 0.0
        
        let offsetY = (size.height > scrollView.contentSize.height) ?
            (size.height - scrollView.contentSize.height) * 0.5 : 0.0
        
        imageView.center = CGPoint.init(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
    
}
