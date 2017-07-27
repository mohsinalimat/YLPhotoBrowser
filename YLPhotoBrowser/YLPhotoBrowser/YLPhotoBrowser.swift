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
let ImageViewCenter = CGPoint.init(x: YLScreenW / 2, y: YLScreenH / 2)
let ImageViewTag = 1000

let YLScreenW = UIScreen.main.bounds.width
let YLScreenH = UIScreen.main.bounds.height

class YLPhotoBrowser: UIViewController {
    
    fileprivate var photos: [YLPhoto]? // 图片
    fileprivate var currentIndex: Int = 0 // 当前row
    
    fileprivate var appearAnimatedTransition:YLAnimatedTransition? // 进来的动画
    fileprivate var disappearAnimatedTransition:YLAnimatedTransition? // 出去的动画
    
    fileprivate var collectionView:UICollectionView!
    fileprivate var pageControl:UIPageControl?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearAnimatedTransition = nil
    }
    
    deinit {
        transitioningDelegate = nil
        appearAnimatedTransition = nil
    }
    
    // 初始化
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
    
    // 绘制 UI
    private func layoutUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: YLScreenW, height: YLScreenH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(YLPhotoCell.self, forCellWithReuseIdentifier: "cell")
        
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
        
        let currentImageView = getCurrentImageView()
        
        if currentImageView == nil {
            return
        }else if currentImageView?.image == nil {
            return
        }
        
        if currentImageView?.superview is UIScrollView {
            let scrollView = currentImageView?.superview as! UIScrollView
            if scrollView.zoomScale == 1 {
                
                let scale = YLScreenH / (currentImageView?.frame.size.height ?? YLScreenH)
                
                scrollView.setZoomScale(scale > 4 ? 4: scale, animated: true)
            }else {
                scrollView.setZoomScale(1, animated: true)
            }
        }
        
    }
    
    // 慢移手势
    func pan(_ pan: UIPanGestureRecognizer) {
        
        let currentImageView = getCurrentImageView()
        
        if currentImageView == nil {
            return
        }else if currentImageView?.image == nil {
            return
        }else if currentImageView?.superview is UIScrollView {
            
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
                
                currentImageView?.center = CGPoint.init(x: ImageViewCenter.x + translation.x * scale, y: ImageViewCenter.y + translation.y * scale)
                
                break
            case .failed,.cancelled,.ended:
                
                if translation.y <= 80 {
                    UIView.animate(withDuration: 0.2, animations: {
                    
                        currentImageView?.center = ImageViewCenter
                        currentImageView?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        }, completion: { (finished: Bool) in
                            
                            currentImageView?.transform = CGAffineTransform.identity
                            
                    })
                    
                    let cell = collectionView.cellForItem(at: IndexPath.init(row: currentIndex, section: 0))
                    scrollView.delegate = cell as! UIScrollViewDelegate?
                    
                }else {
                    
                    currentImageView?.isHidden = true
                    disappearAnimatedTransition?.currentImage = photos?[currentIndex].image
                    disappearAnimatedTransition?.currentImageViewFrame = currentImageView?.frame ?? CGRect.zero
                    disappearAnimatedTransition?.beforeImageViewFrame = photos?[currentIndex].frame ?? CGRect.zero
                }
                
                break
            }
        }
        
    }
    
    // 获取imageView frame
    class func getImageViewFrame(_ size: CGSize) -> CGRect {
        
        if size.width > YLScreenW {
            let height = YLScreenW * (size.height / size.width)
            let frame = CGRect.init(x: 0, y: YLScreenH/2 - height/2, width: YLScreenW, height: height)
            
            return frame
            
        }else {
            let frame = CGRect.init(x: YLScreenW/2 - size.width/2, y: YLScreenH/2 - size.height/2, width: size.width, height: size.height)
            return frame
        }
        
    }
    
    // 获取 currentImageView
    func getCurrentImageView() -> UIImageView? {
        
        if collectionView == nil {
            return nil
        }
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: currentIndex, section: 0))
        
        if let imgView = cell?.viewWithTag(ImageViewTag) {
            return imgView as? UIImageView
        }else {
            return nil
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
        
        let currentImageView = getCurrentImageView()
        
        var afterImgFrame = CGRect.zero
        if currentImageView != nil {
            afterImgFrame = (currentImageView?.frame)!
        }else if photo.image != nil {
            afterImgFrame = YLPhotoBrowser.getImageViewFrame((photo.image?.size)!)
        }else {
            afterImgFrame = YLPhotoBrowser.getImageViewFrame(CGSize.init(width: YLScreenW, height: YLScreenW))
        }
        
        appearAnimatedTransition = nil
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
        
        let cell: YLPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YLPhotoCell
        
        if let photo = photos?[indexPath.row] {
            cell.updatePhoto(photo)
        }
        
        return cell
        
    }
    
    // 已经停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            
            currentIndex = Int(scrollView.contentOffset.x / YLScreenW)
            pageControl?.currentPage = currentIndex
        }
    }
  
}
