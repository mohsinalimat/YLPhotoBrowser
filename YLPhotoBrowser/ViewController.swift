//
//  ViewController.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    fileprivate var collectionView:UICollectionView!
    fileprivate var dataArray = [String]()
    
    var imageView:UIImageView!
    var imageView1:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray += ["1","2","3"]
        dataArray += ["http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehvujq1j218g0p0qai.jpg",
                      "http://ww2.sinaimg.cn/bmiddle/e67669aagw1f1v6w3ya5vj20hk0qfq86.jpg",
                      "http://ww3.sinaimg.cn/bmiddle/61e36371gw1f1v6zegnezg207p06fqv6.gif",
                      "http://ww4.sinaimg.cn/bmiddle/7f02d774gw1f1dxhgmh3mj20cs1tdaiv.jpg"]
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: YLScreenW / 3 - 10, height: YLScreenW / 3 - 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView.init(frame: cell.bounds)
        imageView.tag = 100
        
        if indexPath.row <= 2 {
        
            let path = dataArray[indexPath.row]
            imageView.image = UIImage.init(named: path)
            
        }else {
            let url = dataArray[indexPath.row]
            imageView.kf.setImage(with: URL.init(string: url))
        }
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var photos = [YLPhoto]()
        
        for i in 0...dataArray.count - 1 {
            
            
            
            let window = UIApplication.shared.keyWindow
            
            let cell = collectionView.cellForItem(at: IndexPath.init(row: i, section: 0))
            
            let rect1 = cell?.convert(cell?.frame ?? CGRect.zero, from: collectionView)
            let rect2 = cell?.convert(rect1 ?? CGRect.zero, to: window)
            
            if indexPath.row <= 2 {
                let path = dataArray[i]
                photos.append(YLPhoto.addImage(UIImage.init(named: path), imageUrl: nil, frame: rect2))
                
            }else {
                // let imageView:UIImageView? = cell?.viewWithTag(100) as! UIImageView?
                // photos.append(YLPhoto.addImage(imageView?.image, imageUrl: url, frame: rect2))
                let url = dataArray[i]
                photos.append(YLPhoto.addImage(nil, imageUrl: url, frame: rect2))
            }
        }
        
        let photoBrowser = YLPhotoBrowser.init(photos, index: indexPath.row)
        
        present(photoBrowser, animated: true, completion: nil)
        
    }
}
