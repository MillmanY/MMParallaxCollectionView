//
//  MMParallaxLayout.swift
//  Pods
//
//  Created by Millman YANG on 2016/11/2.
//
//

import UIKit

class MMHeaderLayoutAttributes: UICollectionViewLayoutAttributes {
    var style:HeaderStyle = .normal
    var offsetY:CGFloat = 0.0
    var originY:CGFloat = 0.0
    override func copy(with zone: NSZone? = nil) -> Any {
        let attribute = super.copy(with: zone) as! MMHeaderLayoutAttributes
        attribute.offsetY = offsetY
        attribute.originY = originY
        return attribute
    }
}

class MMParallaxLayout: UICollectionViewFlowLayout {
    fileprivate var headerY = [IndexPath:CGFloat]()
    var collectionStyle:HeaderStyle = .normal {
        didSet {
            headerY.removeAll()
            self.collectionView?.performBatchUpdates({ 
                self.collectionView?.reloadData()
            }, completion: nil)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resetAttributes = super.layoutAttributesForElements(in: rect)!.flatMap({ (attribute) -> UICollectionViewLayoutAttributes? in
            if attribute.representedElementKind == UICollectionElementKindSectionHeader {
                if headerY[attribute.indexPath] == nil {
                    headerY[attribute.indexPath] = attribute.frame.origin.y
                }
                return nil
            }
            attribute.zIndex = 0
            return attribute
        })
        
    
        let headerAttributes = headerY.enumerated().flatMap { (offset,element) -> UICollectionViewLayoutAttributes?  in
            if let attribute = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at:element.key){
                let top = self.collectionView!.contentInset.top
                
                let isOffsetNegative = self.collectionView!.contentOffset.y+top < CGFloat(0.0)
                let header:MMHeaderLayoutAttributes!
                switch collectionStyle {
                case .rear:
                    header = rear(attribute: attribute, isOffsetNegative: isOffsetNegative)
                case .front:
                    header = front(attribute: attribute, isOffsetNegative: isOffsetNegative)
                case .normal:
                    return attribute
                }
                header.style = collectionStyle
                header.originY = headerY[attribute.indexPath]!
                header.offsetY = self.collectionView!.contentOffset.y
                return header
            }
            return nil
        }
        resetAttributes += headerAttributes
        return resetAttributes
    }

    private func rear(attribute:UICollectionViewLayoutAttributes,isOffsetNegative:Bool) -> MMHeaderLayoutAttributes {
        let header = MMHeaderLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: attribute.indexPath)
        let attFrame = self.calculateAttFrame(att: attribute)
        header.zIndex = attribute.indexPath.section - headerY.count
        header.isHidden = (headerY[attribute.indexPath]!+attFrame.height < attFrame.origin.y)
        header.frame = attFrame
        return header
    }
    
    private func front(attribute:UICollectionViewLayoutAttributes,isOffsetNegative:Bool) -> MMHeaderLayoutAttributes {
        let attFrame = self.calculateAttFrame(att: attribute)
        let header = MMHeaderLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: attribute.indexPath)
        header.zIndex = attribute.indexPath.section + 2
        header.isHidden = false
        header.frame = attFrame
        return header
    }

    private func calculateAttFrame(att:UICollectionViewLayoutAttributes) -> CGRect{
        var attFrame = att.frame
        if let y = headerY[att.indexPath] ,
            (attFrame.origin.y >= y && self.collectionView!.contentOffset.y >= y) || (isOffsetNegative() && att.indexPath.section == 0)
        {
            let top = self.collectionView!.contentInset.top
            let shift = (isOffsetNegative()) ? y+top : 0
            attFrame.origin.y = shift + self.collectionView!.contentOffset.y
        }
        return attFrame
    }
    
    private func isOffsetNegative() -> Bool {
        let top = self.collectionView!.contentInset.top
        return self.collectionView!.contentOffset.y+top < CGFloat(0.0)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
