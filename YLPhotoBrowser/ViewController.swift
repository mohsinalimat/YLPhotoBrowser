//
//  ViewController.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var collectionView:UICollectionView!
    fileprivate var dataArray = [String]()
    
    var imageView:UIImageView!
    var imageView1:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray += ["1","2","1","2"]
        
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
        
        let imageName = dataArray[indexPath.row]
        
        let imageView = UIImageView.init(frame: cell.bounds)
        
        imageView.image = UIImage(named: imageName)
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var photos = [YLPhoto]()
        
        for i in 0...dataArray.count - 1 {
            
            let imageName = dataArray[i]
            
            let window = UIApplication.shared.keyWindow
            
            let cell = collectionView.cellForItem(at: IndexPath.init(row: i, section: 0))
            
            let rect1 = cell?.convert(cell?.frame ?? CGRect.zero, from: collectionView)
            let rect2 = cell?.convert(rect1 ?? CGRect.zero, to: window)
            
            // 有图片位置的
            photos.append(YLPhoto.addImage(UIImage.init(named: imageName), imageUrl: nil, frame: rect2))
            
        }
        
        // 没有图片位置的
        photos.append(YLPhoto.addImage(nil, imageUrl: "http://f1.diyitui.com/e0/d8/18/1e/2b/3c/ef/39/64/e4/00/7c/d2/c6/f3/df.jpg", frame: nil))
        photos.append(YLPhoto.addImage(nil, imageUrl: "http://photo.l99.com/bigger/6be/1453181740508_ksepb0.jpg", frame: nil))
        photos.append(YLPhoto.addImage(nil, imageUrl: "http://img.meimi.cc/meinv/20170608/lugudlsxna117230.jpg", frame: nil))
        
        
        
        let photoBrowser = YLPhotoBrowser.init(photos, index: indexPath.row)
        
        present(photoBrowser, animated: true, completion: nil)
        
    }
}
