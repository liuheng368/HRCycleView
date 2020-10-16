### swift版本的带进度的无限轮播头部bar。
HRCycleView基于UICollectionView来实现。

![](https://upload-images.jianshu.io/upload_images/6333164-f0d0054e46cc3ece.gif?imageMogr2/auto-orient/strip)

### 功能包含：
* 支持单张图片
* 支持持续时间自定义
* 支持带进度条样式
* 支持本地图片显示，网路图显示，本地图片和网路图混合显示
* 支持自定义图片展示Cell（纯代码和Xib创建都支持）
* 支持UIPageControl具体位置设置
* 支持UIPageControl显示颜色设置
* 支持图片点击回调

### 本地图片滚动视图
![](https://upload-images.jianshu.io/upload_images/6333164-624541ddfe33edef.gif?imageMogr2/auto-orient/strip)

```swift
/// 本地图片
        let carouselView = CarouselView(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vMain.frame.height),
                                        ["img1.jpg","img2.jpg","img3.jpg","img4.jpg"],
                                        placeholderImage: UIImage.creatImageWithColor(color: .black),
                                        pageLocation: .CenterBottom(bottom: 12),
                                        autoScrollDelay: 3)
        carouselView.pageIndicatorTintColor = .blue
        carouselView.delegate = self
        vMain.addSubview(carouselView)
```

### 网络图片滚动视图
![](https://upload-images.jianshu.io/upload_images/6333164-8c5620d882224cfe.gif?imageMogr2/auto-orient/strip)

```swift
let carouselView2 = CarouselView(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vMain.frame.height),
                                         picUrl,
                                         placeholderImage: UIImage(named: "img1.jpg")!,
                                         pageLocation: .LeftBottom(leading: 15, bottom: 15),
                                         autoScrollDelay: 5)
        carouselView2.pageIndicatorTintColor = .orange
        carouselView2.delegate = self
        vMain2.addSubview(carouselView2)
```

### 自定义cell滚动视图

![](https://upload-images.jianshu.io/upload_images/6333164-3d1c347d84680afb.gif?imageMogr2/auto-orient/strip)

```swift
let carouselView3 = CarouselView(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vMain.frame.height),
                                         picUrl,
                                         placeholderImage: UIImage(named: "img1.jpg")!,
                                         pageLocation: .RightBottom(trailing: 15, bottom: 15),
                                         autoScrollDelay: 3)
        carouselView3.pageIndicatorTintColor = .green
        carouselView3.delegate = self
        carouselView3.register([UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)], identifiers: ["CustomCollectionViewCell"])
        vMain3.addSubview(carouselView3)

// 自定义Cell-Delegate-(纯代码和Xib创建都支持)
![](https://upload-images.jianshu.io/upload_images/6333164-2e5d2a3db83e1d29.gif?imageMogr2/auto-orient/strip)

    func carouselView(carouselView: CarouselView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, picture: String) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.lable.text = "自定义Cell\n第 \(indexPath.item) 项"
        cell.image.kf.setImage(with: URL(string: picture))
        return cell
    }
```

### 点击代理回调
```swift
func carouselView(carouselView: CarouselView, didSelectItemAt index: Int) {
        print("\(index)巴拉巴拉")
    }
```

