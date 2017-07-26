//
//  YLPhotoBrowser.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

let PhotoBrowserBG = UIColor.black

let YLScreenW = UIScreen.main.bounds.width
let YLScreenH = UIScreen.main.bounds.height

class YLPhotoBrowser: UIViewController {
    
    fileprivate var photos: [YLPhoto]? // 图片
    fileprivate var currentIndex: Int = 0 // 当前row
    fileprivate var currentImageView:UIImageView? // 当前图片

    fileprivate var appearAnimatedTransition:YLAnimatedTransition? // 进来的动画
    fileprivate var disappearAnimatedTransition:YLAnimatedTransition? // 出去的动画
    
    fileprivate var collectionView:UICollectionView!
    fileprivate var pageControl:UIPageControl?
    
    fileprivate var imageViewCenter = CGPoint.init(x: YLScreenW/2, y: YLScreenH/2)
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearAnimatedTransition = nil
    }
    
    deinit {
        transitioningDelegate = nil
        appearAnimatedTransition = nil
        print("释放:\(self)")
    }
    
    convenience init(_ photos: [YLPhoto],index: Int) {
        self.init()
        
        self.photos = photos
        self.currentIndex = index
        
        let photo = photos[index]
        
        editTransitioningDelegate(photo)
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = PhotoBrowserBG
        
        view.isUserInteractionEnabled = true

        view.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.pan(_:))))
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.singleTap))
        view.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        // 优先识别 双击
        singleTap.require(toFail: doubleTap)
        
        layoutUI()
        
        collectionView.contentOffset.x = YLScreenW * CGFloat(currentIndex)
    }
    
    private func layoutUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: YLScreenW, height: YLScreenH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        if (photos?.count)! > 1 {
            
            pageControl = UIPageControl()
            pageControl?.center = CGPoint(x: YLScreenW / 2 , y: YLScreenH - 30)
            pageControl?.pageIndicatorTintColor = UIColor.lightGray
            pageControl?.currentPageIndicatorTintColor = UIColor.white
            pageControl?.numberOfPages = (photos?.count)!
            pageControl?.currentPage = currentIndex
            pageControl?.backgroundColor = UIColor.clear
            
            view.addSubview(pageControl!)
            
        }
    }
    
    // 单击手势
    func singleTap() {
    
        if let photo = photos?[currentIndex]{
            editTransitioningDelegate(photo)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 双击手势
    func doubleTap() {
    
        if currentImageView?.superview is UIScrollView {
            let scrollView = currentImageView?.superview as! UIScrollView
            if scrollView.zoomScale == 1 {
                scrollView.setZoomScale(2, animated: true)
            }else {
                scrollView.setZoomScale(1, animated: true)
            }
        }
        
    }
    
    // 慢移手势
    func pan(_ pan: UIPanGestureRecognizer) {
        
        if currentImageView == nil {
            return
        }
        
        if currentImageView?.superview is UIScrollView {
            let scrollView = currentImageView?.superview as! UIScrollView
            if scrollView.zoomScale != 1 {
                return
            }
            
            scrollView.delegate = nil
            
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
                self.transitioningDelegate = disappearAnimatedTransition
                
                dismiss(animated: true, completion: nil)
                
                break
            case .changed:
                
                currentImageView?.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                
                currentImageView?.center = CGPoint.init(x: imageViewCenter.x + translation.x * scale, y: imageViewCenter.y + translation.y * scale)
                
                break
            case .failed,.cancelled,.ended:
                
                if translation.y <= 80 {
                    UIView.animate(withDuration: 0.2, animations: {
                        [weak self] in
                        
                        self?.currentImageView?.center = (self?.imageViewCenter)!
                        self?.currentImageView?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        }, completion: { [weak self] (finished: Bool) in
                            
                            self?.currentImageView?.transform = CGAffineTransform.identity
                            
                    })
                    scrollView.delegate = self
                }else {
                    self.currentImageView?.isHidden = true
                    disappearAnimatedTransition?.currentImage = photos?[currentIndex].image
                    disappearAnimatedTransition?.currentImageViewFrame = currentImageView?.frame ?? CGRect.zero
                    disappearAnimatedTransition?.beforeImageViewFrame = photos?[currentIndex].frame ?? CGRect.zero
                }
                
                break
            }
        }
        
    }
    
    // 获取imageView frame
    func getImageViewFrame(_ size: CGSize) -> CGRect {
        
        if size.width > YLScreenW {
            let height = YLScreenW * (size.height / size.width)
            let frame = CGRect.init(x: 0, y: YLScreenH/2 - height/2, width: YLScreenW, height: height)
            
            return frame

        }else {
            let frame = CGRect.init(x: YLScreenW/2 - size.width/2, y: YLScreenH/2 - size.height/2, width: size.width, height: size.height)
            return frame
        }
        
}
    
    // 修改 transitioningDelegate
    func editTransitioningDelegate(_ photo: YLPhoto) {
    
        if photo.image == nil {
            let url = SDWebImageManager.shared().cacheKey(for: URL.init(string: photo.imageUrl))
            if let image =  SDImageCache.shared().imageFromCache(forKey: url) {
                photo.image = image
            }
        }
        
        appearAnimatedTransition = nil
        var afterImgFrame = CGRect.zero
        if currentImageView != nil {
            afterImgFrame = (currentImageView?.frame)!
        }else if photo.image != nil {
            afterImgFrame = getImageViewFrame((photo.image?.size)!)
        }else {
            afterImgFrame = getImageViewFrame(CGSize.init(width: YLScreenW, height: YLScreenW))
        }
        
        appearAnimatedTransition = YLAnimatedTransition.init(photo.image, beforeImgFrame: photo.frame, afterImgFrame:afterImgFrame)
        
        self.transitioningDelegate = appearAnimatedTransition
        
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension YLPhotoBrowser:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = self.photos {
            return photos.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        let photo = photos?[indexPath.row]
        
        let scrollView: UIScrollView = {
            let sv = UIScrollView(frame: cell.bounds)
            sv.showsHorizontalScrollIndicator = false
            sv.showsVerticalScrollIndicator = false
            sv.maximumZoomScale = 4.0
            sv.minimumZoomScale = 1.0
            sv.delegate = self
            return sv
        }()
        
        cell.addSubview(scrollView)
        
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 0.1)
        
        if photo?.imageUrl != "" {
            
            imageView.frame.size = CGSize.init(width: YLScreenW, height: YLScreenW)
            imageView.center = imageViewCenter
            
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.white)
            
            var webImageOptions = SDWebImageOptions.retryFailed
            webImageOptions.formUnion(SDWebImageOptions.progressiveDownload)
            imageView.sd_setImage(with: URL(string: (photo?.imageUrl)!), placeholderImage: nil, options: webImageOptions, completed: { [weak self] (image:UIImage?, error:Error?, cacheType:SDImageCacheType, url:URL?) in
                guard let img = image else {
                    let image = UIImage.init(named: "load_error")
                    imageView.frame = self?.getImageViewFrame((image?.size)!) ?? CGRect.zero
                    imageView.image = image
                    
                    return
                }
                imageView.frame = (self?.getImageViewFrame(img.size))!
                imageView.image = img
                photo?.image = image
            })
        }else if photo?.image != nil {
            
            imageView.image = photo?.image
            imageView.frame = getImageViewFrame((photo?.image?.size)!)
            
        }
        
        imageView.tag = 100
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit

        scrollView.contentSize = imageView.frame.size
        scrollView.addSubview(imageView)

        if indexPath.row == currentIndex {
            currentImageView = imageView
        }
        
        return cell
        
    }

    // 已经停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            currentIndex = Int(scrollView.contentOffset.x / YLScreenW)
            print(scrollView.contentOffset.x / YLScreenW)
            pageControl?.currentPage = currentIndex
            
            let cell = collectionView.cellForItem(at: IndexPath.init(row: currentIndex, section: 0))
            
            if let imgView = cell?.viewWithTag(100) {
                currentImageView = imgView as? UIImageView
            }

        }
    }
    
    // 设置UIScrollView中要缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != collectionView {
            return scrollView.viewWithTag(100)
        }else {
            return nil
        }
    }
    
    // 让UIImageView在UIScrollView缩放后居中显示
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView != collectionView {
            
            let size = scrollView.bounds.size
            
            let offsetX = (size.width > scrollView.contentSize.width) ?
            (size.width - scrollView.contentSize.width) * 0.5 : 0.0
            
            let offsetY = (size.height > scrollView.contentSize.height) ?
            (size.height - scrollView.contentSize.height) * 0.5 : 0.0
            
            scrollView.viewWithTag(100)?.center = CGPoint.init(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
            
        }
    }
    
}
