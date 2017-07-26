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
        
        appearAnimatedTransition = nil
        appearAnimatedTransition = YLAnimatedTransition.init(photo.image!, beforeImgFrame: photo.frame!, afterImgFrame: getImageViewFrame(photo.image!))
    
        self.transitioningDelegate = appearAnimatedTransition

    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = PhotoBrowserBG
        
        view.isUserInteractionEnabled = true

        view.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.pan(_:))))
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.tap)))
        
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
            pageControl?.currentPage = currentIndex
            pageControl?.pageIndicatorTintColor = UIColor.lightGray
            pageControl?.currentPageIndicatorTintColor = UIColor.white
            pageControl?.numberOfPages = (photos?.count)!
            pageControl?.backgroundColor = UIColor.clear
            
            view.addSubview(pageControl!)
            
        }
    }
    
    // 点击手势
    func tap() {
        if let photo = photos?[currentIndex],
            let imageView = currentImageView {
            appearAnimatedTransition = nil
            appearAnimatedTransition = YLAnimatedTransition.init(photo.image!, beforeImgFrame: photo.frame!, afterImgFrame: imageView.frame)
            self.transitioningDelegate = appearAnimatedTransition
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 慢移手势
    func pan(_ pan: UIPanGestureRecognizer) {
        
        if currentImageView == nil {
            return
        }
        
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
            }else {
                self.currentImageView?.isHidden = true
            }
            
            disappearAnimatedTransition?.currentImage = currentImageView?.image
            disappearAnimatedTransition?.currentImageViewFrame = currentImageView?.frame
            disappearAnimatedTransition?.beforeImageViewFrame = photos?[currentIndex].frame
            
            break
        }
    }
    
    // 获取imageView frame
    func getImageViewFrame(_ image: UIImage) -> CGRect {
        
        let height = YLScreenW * (image.size.height / image.size.width)
        let frame = CGRect.init(x: 0, y: YLScreenH/2 - height/2, width: YLScreenW, height: height)
        
        return frame
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
        
        let imageView = UIImageView.init(image: photo?.image)
        imageView.frame = getImageViewFrame((photo?.image)!)

        imageView.tag = 100
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit

        cell.addSubview(imageView)

        if indexPath.row == currentIndex {
            currentImageView = imageView
        }
        
        return cell
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / YLScreenW)
        
        pageControl?.currentPage = currentIndex
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: currentIndex, section: 0))
        
        if let imgView = cell?.viewWithTag(100) {
            currentImageView = imgView as? UIImageView
        }
    }
    
}
