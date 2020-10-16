//
//  CarouseProgressView.swift
//  HRCycleView
//
//  Created by Henry on 2020/10/15.
//

import UIKit

// MARK: - 指示器Location
public enum CarouseProgressStyle {
    case `default`  // 默认
    case trackFillet    // 轨道圆角(默认半圆)
    case allFillet  //进度与轨道都圆角
}


class CarouseProgressView: UIView {
    
    public init(frame: CGRect,_ progressViewStyle:CarouseProgressStyle = .default) {
        super.init(frame: frame)
        if progressViewStyle == .trackFillet{
            layer.masksToBounds = true
            layer.cornerRadius = frame.size.height / 2
        }else if progressViewStyle == .allFillet{
            layer.masksToBounds = true
            layer.cornerRadius = frame.size.height / 2
            progressView.layer.cornerRadius = frame.size.height / 2
        }
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height)
        self.addSubview(self.progressView)
    }
    
    /// 进度
    public var progress : CGFloat = 0 {
        didSet{
            progress = min(progress, 1.0)
            progressView.frame.size = CGSize(width: frame.size.width * progress, height: frame.size.height)
        }
    }
    
    /// 进度条颜色
    public var progressTintColor : UIColor = .blue {
        didSet{
            progressView.backgroundColor = progressTintColor
        }
    }
    
    /// 背景色
    public var trackTintColor : UIColor = .white {
        didSet{
            self.backgroundColor = trackTintColor
        }
    }
    
    let progressView = UIView()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
