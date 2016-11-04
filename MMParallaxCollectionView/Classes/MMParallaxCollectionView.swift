//
//  MMParallaxCollectionView.swift
//  Pods
//
//  Created by Millman YANG on 2016/11/2.
//
//

import UIKit

enum HeaderStyle {
    case rear
    case front
    case parallaxView(identifier:String,topBarIdentifier:String)
    case normal
}

class MMHeaderLayoutAttributes: UICollectionViewLayoutAttributes {
    var style:HeaderStyle = .rear
    var offsetY:CGFloat = 0.0
    var originY:CGFloat = 0.0
    override func copy(with zone: NSZone? = nil) -> Any {
        let attribute = super.copy(with: zone) as! MMHeaderLayoutAttributes
        attribute.offsetY = offsetY
        attribute.originY = originY
        return attribute
    }
}



class MMParallaxCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
