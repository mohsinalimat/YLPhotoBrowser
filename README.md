# YLPhotoBrowser

    仿微信图片浏览器(定义转场动画、支持本地和网络gif、拖拽取消）                                     

    ![image](https://github.com/February12/YLPhotoBrowser/tree/master/READMEShow/动画.gif)

# 使用  简单易用,拖拽取消

    pod 'YLPhotoBrowser-Swift' 
    
    var photos = [YLPhoto]()  //创建数组              
    photos.append(YLPhoto.addImage(image, imageUrl: nil, frame: frame))            
    let photoBrowser = YLPhotoBrowser.init(photos, index: index)                                      
    present(photoBrowser, animated: true, completion: nil)

# 教程       

    #   YLPhoto                                      
    为了让动画效果最佳,最好有 image(原图/缩略图) 和 frame(图片初始位置)                                           
    public class func addImage(_ image: UIImage?,imageUrl: String?,frame: CGRect?) -> YLPhoto {
        let photo = YLPhoto()
        photo.image = image
        photo.imageUrl = imageUrl ?? ""
        photo.frame = frame
        return photo
    }

    #   YLPhotoBrowser                                                 
    初始化
    public convenience init(_ photos: [YLPhoto],index: Int) {
        self.init()
        
        self.photos = photos
        self.currentIndex = index
        
        let photo = photos[index]
        
        editTransitioningDelegate(photo)
    }

    #   YLGifImage
    // 获取本地gif name 带后缀 如  1.gif
    public class func yl_gifAnimated(_ name: String) -> UIImage?       
