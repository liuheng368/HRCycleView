//
//  ViewController.swift
//  HRCycleView
//
//  Created by Henry on 2020/10/15.
//

import UIKit

class ViewController: UIViewController,CarouselViewDelegate {
    func carouselView(carouselView: CarouselView, didSelectItemAt index: Int) {
        print("\(index)巴拉巴拉")
    }
    
    // 自定义Cell
    func carouselView(carouselView: CarouselView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, picture: String) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.lable.text = "自定义Cell\n第 \(indexPath.item) 项"
        cell.image.kf.setImage(with: URL(string: picture))
        return cell
    }
    
    @IBOutlet var vMain: UIView!
    @IBOutlet var vMain2: UIView!
    @IBOutlet var vMain3: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 本地图片
        let carouselView = CarouselView(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vMain.frame.height),
                                        ["img1.jpg","img2.jpg","img3.jpg","img4.jpg"],
                                        placeholderImage: UIImage.creatImageWithColor(color: .black),
                                        pageLocation: .CenterBottom(bottom: 12),
                                        autoScrollDelay: 3)
        carouselView.pageIndicatorTintColor = .blue
        carouselView.delegate = self
        vMain.addSubview(carouselView)
        
        
        /// 网络图片
        let picUrl = ["https://t8.baidu.com/it/u=1484500186,1503043093&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1603435116&t=e842d7b2a85785afc5e3971ac0d3057b",
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602840396203&di=b08f88cdb74690e469bf20e6160cef70&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D2247852322%2C986532796%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D853",
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602840396202&di=b26b051e12b58dab95887816c17f996a&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D1307125826%2C3433407105%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D5760%26h%3D3240",
                      "https://t9.baidu.com/it/u=583874135,70653437&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1603435239&t=9f1786d0e0bfc6c41b47411acee19be9"]
        let carouselView2 = CarouselView(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vMain.frame.height),
                                         picUrl,
                                         placeholderImage: UIImage(named: "img1.jpg")!,
                                         pageLocation: .LeftBottom(leading: 15, bottom: 15),
                                         autoScrollDelay: 5)
        carouselView2.pageIndicatorTintColor = .orange
        carouselView2.delegate = self
        vMain2.addSubview(carouselView2)
        
        
        /// 自定义cell
        let carouselView3 = CarouselView(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vMain.frame.height),
                                         picUrl,
                                         placeholderImage: UIImage(named: "img1.jpg")!,
                                         pageLocation: .RightBottom(trailing: 15, bottom: 15),
                                         autoScrollDelay: 3)
        carouselView3.pageIndicatorTintColor = .green
        carouselView3.delegate = self
        carouselView3.register([UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)], identifiers: ["CustomCollectionViewCell"])
        vMain3.addSubview(carouselView3)
    }
}

extension UIImage {
    class func creatImageWithColor(color:UIColor)->UIImage{
           let rect = CGRect(x:0,y:0,width:1,height:1)
           UIGraphicsBeginImageContext(rect.size)
           let context = UIGraphicsGetCurrentContext()
           context?.setFillColor(color.cgColor)
           context!.fill(rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image!
    }
}
