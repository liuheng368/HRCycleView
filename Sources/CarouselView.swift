//
//  CarouselView.swift
//  HRCycleView
//
//  Created by Henry on 2020/10/15.
//
/*
 
    4项页面结构
   | 4 | 1 | 2 | 3 | 4 | 1 |
 
 */

import UIKit
import Kingfisher
// MARK: - CarouselView常量
private struct CarouselViewConst {
    static let cellIdentifier = "HRCarouselViewCellId"        // Cell标识
    static let pageControlHeight: CGFloat = 6          // 指示器高度
    static let pageProcessWidth: CGFloat = 21          // 进度条宽度
    static let pageControlSpace: CGFloat = 6          // 指示器间隔
}

// MARK: - 指示器Location
public enum CarouselPageControlLocation {
    case LeftBottom(leading: CGFloat,bottom: CGFloat)
    case CenterBottom(bottom: CGFloat)
    case RightBottom(trailing: CGFloat,bottom: CGFloat)
}

// MARK: - CarouselView 代理方法
@objc public protocol CarouselViewDelegate: NSObjectProtocol {

    // 图片点击
    @objc optional func carouselView(carouselView: CarouselView, didSelectItemAt index: Int)
    
    // 自定义Cell
    @objc optional func carouselView(carouselView: CarouselView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, picture: String) -> UICollectionViewCell?
}

public class CarouselView: UIView {
    public weak var delegate: CarouselViewDelegate?
    // 指示器填充颜色
    public var pageIndicatorTintColor: UIColor = UIColor.blue {
        didSet{
            pageProcess.enumerated().forEach{(index, view) in
                view.progressTintColor = pageIndicatorTintColor
            }
        }
    }
    
    public init(_ frame: CGRect,
                _ images: [String],
                placeholderImage: UIImage,
                pageLocation: CarouselPageControlLocation = .CenterBottom(bottom: 12),
                autoScrollDelay: TimeInterval = 3) {
        self.images = images
        self.placeholderImage = placeholderImage
        self.pageLocation = pageLocation
        self.autoScrollDelay = autoScrollDelay
        super.init(frame: frame)
        
        initCollectionView()
        addSubview(collectionView)
        
        initPageControlView()
        addSubview(pageControlView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.isPaused = true
        timer.invalidate()
    }
    
    private func initCollectionView(){
        guard images.count > 0 else {return}
        collectionView.reloadData()
        collectionView.isScrollEnabled = images.count > 1
        // 滚动到中间位置
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        if images.count > 1 {
            timer.isPaused = false
        } else {
            timer.isPaused = true
            timer.invalidate()
        }
    }
    
    private func initPageControlView(){
        let width = CGFloat(images.count - 1) * CarouselViewConst.pageControlHeight + CarouselViewConst.pageProcessWidth + CarouselViewConst.pageProcessWidth
        pageControlView.frame = CGRect(x: 0, y: 0, width: width, height: CarouselViewConst.pageControlHeight)
        let screen = UIScreen.main.bounds
        switch pageLocation {
        case .LeftBottom(let leading,let bottom):
            pageControlView.center.x = width/2 + leading
            pageControlView.center.y = bounds.height - CarouselViewConst.pageControlHeight / 2 - bottom
        case .CenterBottom(let bottom):
            pageControlView.center.x = screen.width/2
            pageControlView.center.y = bounds.height - CarouselViewConst.pageControlHeight / 2 - bottom
        case .RightBottom( let trailing, let bottom):
            pageControlView.center.x = bounds.width - width/2 - trailing
            pageControlView.center.y = bounds.height - CarouselViewConst.pageControlHeight / 2 - bottom
        }
        
        for i in 0..<images.count {
            let proFrame : CGRect
            if i == 0 {
                proFrame = CGRect(x: 0, y: 0, width: CarouselViewConst.pageProcessWidth, height: CarouselViewConst.pageControlHeight)
            }else{
                let x = CGFloat(i-1) * (CarouselViewConst.pageControlHeight + CarouselViewConst.pageControlSpace) + CarouselViewConst.pageProcessWidth + CarouselViewConst.pageControlSpace
                proFrame = CGRect(x: x, y: 0, width: CarouselViewConst.pageControlHeight, height: CarouselViewConst.pageControlHeight)
            }
            let pro = CarouseProgressView(frame: proFrame, .trackFillet)
            pro.trackTintColor = .white
            pro.progress = 0
            pageControlView.addSubview(pro)
            pageProcess.append(pro)
        }
    }
    
    private let pageLocation: CarouselPageControlLocation
    private let images: [String]
    private let placeholderImage: UIImage
    private let autoScrollDelay: TimeInterval
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CarouselViewCell.self, forCellWithReuseIdentifier: CarouselViewConst.cellIdentifier)
        return collectionView
    }()

    private var pageControlView : UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = .clear
        return v
    }()
    private var pageProcess : [CarouseProgressView] = []
    
    private var isCustomCell = false    // 是否使用自定义Cell
    
    // 定时器
    private lazy var timer: CADisplayLink = {
        let timer = CADisplayLink(target: self, selector: #selector(updateAutoScrolling))
        timer.add(to: RunLoop.current, forMode: .common)
        return timer
    }()
    
    
    /// 当前位置
    private var currentIndex = 0
}

// MARK: - 自定义Cell方法
extension CarouselView {
    
    // 自定义 AnyClass cell
    public func register(_ cellClasss: [Swift.AnyClass?], identifiers: [String]) {
        isCustomCell = true
        for (index, identifier) in identifiers.enumerated() {
            collectionView.register(cellClasss[index], forCellWithReuseIdentifier: identifier)
        }
    }
    
    // 自定义 UINib cell
    public func register(_ nibs: [UINib?], identifiers: [String]) {
        isCustomCell = true
        for (index, identifier) in identifiers.enumerated() {
            collectionView.register(nibs[index], forCellWithReuseIdentifier: identifier)
        }
    }
}

// MARK: - 轮播核心
extension CarouselView {
    // 定时器方法，更新Cell位置
    @objc private func updateAutoScrolling() {
        pageProcess[currentIndex].progress += CGFloat((1.0/(autoScrollDelay*60.0)))
        if pageProcess[currentIndex].progress >= 1.0 {
            pageProcess[currentIndex].progress = 0
            timer.isPaused = true
            if let indexPath = collectionView.indexPathsForVisibleItems.last {
                let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            }
            timer.isPaused = false
        }
    }
    
    // 开始拖拽时,停止定时器
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.isPaused = true
    }
    
    // 结束拖拽时,恢复定时器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.isPaused = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / bounds.size.width)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        if scrollView.contentOffset.x < 1 {
            let indexPath = IndexPath(item: itemsCount-2, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }else if page == itemsCount - 1 {
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        let newPage = Int(scrollView.contentOffset.x / bounds.size.width)-1
        if newPage < 0 {    //第一项展示位最后一项
            currentIndex = images.count - 1
        }else{
            currentIndex = newPage
        }
        pageProcess.enumerated().forEach { (index,view) in
            view.progress = 0
            if index == newPage{
                view.frame.size = CGSize(width: CarouselViewConst.pageProcessWidth,
                                         height: CarouselViewConst.pageControlHeight)
            }else{
                view.frame.size = CGSize(width: CarouselViewConst.pageControlHeight,
                                         height: CarouselViewConst.pageControlHeight)
            }
            if index <= newPage{
                view.frame.origin = CGPoint(x: CGFloat(index) * (CarouselViewConst.pageControlHeight + CarouselViewConst.pageControlSpace), y: 0.0)
            }else{
                let x = CGFloat(index-1) * (CarouselViewConst.pageControlHeight + CarouselViewConst.pageControlSpace) + CarouselViewConst.pageProcessWidth + CarouselViewConst.pageControlSpace
                view.frame.origin = CGPoint(x: x, y: 0.0)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count+2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newIndexPath : IndexPath
        if indexPath.row == 0 { //第一项，展示最后一项图片
            newIndexPath = IndexPath(item: images.count-1, section: indexPath.section)
        }else if indexPath.row == images.count + 1{ //最后一项，展示第一项图片
            newIndexPath = IndexPath(item: 0, section: indexPath.section)
        }else{
            newIndexPath = IndexPath(item: indexPath.row-1, section: indexPath.section)
        }
        if isCustomCell {
            // 自定义Cell
            return delegate?.carouselView?(carouselView: self, collectionView: collectionView, cellForItemAt: newIndexPath, picture: images[newIndexPath.row]) ?? UICollectionViewCell()
        } else {
            // 默认Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselViewConst.cellIdentifier, for: newIndexPath) as! CarouselViewCell
            cell.configureCell(picture: images[newIndexPath.row], placeholderImage: placeholderImage, imgViewWidth: bounds.width)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView?(carouselView: self, didSelectItemAt: indexPath.row-1)
    }
    
}

// MARK: - 轮播图默认的Cell
fileprivate class CarouselViewCell: UICollectionViewCell {
    
    // 图片控件
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgViewWidth, height: bounds.height))
        return imgView
    }()
    
    /**
     - 图片宽度
     - 根据业务需要设置轮播图片的宽度，默认屏幕宽度
     */
    private var imgViewWidth: CGFloat = UIScreen.main.bounds.width {
        didSet {
            if imgViewWidth != UIScreen.main.bounds.width {
                imgView.frame.size.width = imgViewWidth
                imgView.center.x = bounds.width/2
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(imgView)
    }
    
    /**
     - 数据填充方法
     - picture: 需要展示的图片，根据是否以“http”开头判断网路图片还是本地图片
     - placeholderImage: 默认图片
     - imgViewWidth: 图片宽度
     */
    fileprivate func configureCell(picture: String, placeholderImage: UIImage? = nil, imgViewWidth: CGFloat = UIScreen.main.bounds.width) {
        
        if picture.hasPrefix("http") {
            imgView.kf.setImage(with: URL(string: picture), placeholder: placeholderImage)
        } else {
            imgView.image = UIImage(named: picture) ?? placeholderImage
        }
        
        self.imgViewWidth = imgViewWidth
    }
}
