//
//  MMHeaderReuseView.swift
//  ParallaxDemo
//
//  Created by Millman YANG on 2016/11/1.
//  Copyright © 2016年 Millman YANG. All rights reserved.
//

import UIKit

open class MMHeaderReuseView: UICollectionReusableView {
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if  let att = layoutAttributes as? MMHeaderLayoutAttributes{
            self.layer.zPosition = CGFloat(att.zIndex)
            switch att.style {
                case .rear:
                    let shape = CAShapeLayer()
                    shape.frame = self.bounds
                    shape.fillColor  = UIColor.blue.cgColor
                    shape.path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height-(att.offsetY-att.originY))).cgPath
                    self.layer.mask = shape

                default:break
            }
        }
    }
}
