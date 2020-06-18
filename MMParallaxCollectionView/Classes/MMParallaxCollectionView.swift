//
//  MMParallaxCollectionView.swift
//  Pods
//
//  Created by Millman YANG on 2016/11/2.
//
//

import UIKit

/**
 CollectionView header Style
 **/
public enum HeaderStyle {
    case rear
    case front
    case normal
}

/**
 Public function
 **/
open class MMParallaxCollectionView: UICollectionView {
    var topMargin:CGFloat = 0.0
    var collectionVC:UIViewController?
    var statusHeight = UIApplication.shared.statusBarFrame.height
    var originalNavHeight:CGFloat = 0.0
    var parallaxView:UIView?
    var parallaxLayout = MMParallaxLayout()
    var parallaxTopConstraint:NSLayoutConstraint?
    
    var navHiddenRate:((_ rate:CGFloat)->Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setUp()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
public func addParallax(view:UIView,height:CGFloat) {
  
        DispatchQueue.main.async {
            if let superV = self.superview {
                self.collectionVC = UIViewController.currentViewController()
//                self.originalNavHeight = (self.collectionVC!.navigationController != nil) ? self.collectionVC!.navigationController!.navigationBar.frame.height : 0
                self.originalNavHeight = 0.0

                view.layer.zPosition = -1
                self.backgroundColor = UIColor.clear
                superV.addSubview(view)
                superV.sendSubviewToBack(view)
//                self.topMargin = self.getCollectionMargin()
                self.topMargin = 0.0

                let addOffset = self.topMargin
                
                
//                UIView.animate(withDuration: 0.3, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: .curveEaseIn, animations: {
                    self.contentInset = UIEdgeInsets.init(top: height+self.originalNavHeight+addOffset, left: 0, bottom: 0, right: 0)
                    self.contentOffset = CGPoint.init(x: 0, y: -(height+self.originalNavHeight+addOffset))

//                }, completion: nil)

                view.translatesAutoresizingMaskIntoConstraints = false
                let left = NSLayoutConstraint.init(item: view, attribute: .left, relatedBy: .equal, toItem: superV, attribute: .left, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint.init(item: view, attribute: .right, relatedBy: .equal, toItem: superV, attribute: .right, multiplier: 1.0, constant: 0.0)
                self.parallaxTopConstraint = NSLayoutConstraint.init(item: view, attribute: .top, relatedBy: .equal, toItem: superV, attribute: .top, multiplier: 1.0, constant: 0)
                let height = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
                superV.addConstraints([left,right,self.parallaxTopConstraint!,height])
                self.parallaxView = view
                superV.layoutIfNeeded()
            }
        }
    }
        
    public func showNavigationBar(isShow:Bool,animated:Bool) {
        
        if let bar = self.collectionVC?.navigationController?.navigationBar{
            let alpha:CGFloat = isShow  ? 1.0 : 0.0
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    bar.frame.origin.y = (isShow) ? self.statusHeight : self.topMargin-self.originalNavHeight
                    self.barItemAlpha(alpha: alpha)
                })
            } else {
                bar.frame.origin.y = (isShow) ? self.statusHeight : self.topMargin-self.originalNavHeight
                self.barItemAlpha(alpha: alpha)
            }
        }
    }
    
    public func setHeaderStyle(style:HeaderStyle) {
        parallaxLayout.collectionStyle = style
    }
    
    public func getNavigationRate(rate:@escaping (CGFloat)->Void) {
        self.navHiddenRate = rate
    }
}

/**
 Override func,var
 **/
extension MMParallaxCollectionView {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if let nav = self.collectionVC?.navigationController ,self.contentOffset.y < 0 {
            let height = abs(self.contentOffset.y) - nav.navigationBar.frame.height
            let rect = CGRect.init(x: 0, y: nav.navigationBar.frame.height+self.contentOffset.y, width: self.frame.width, height: height)
            return !rect.contains(point)
        }
        return true
    }
    
    open override func didMoveToWindow() {
        DispatchQueue.main.async {
            let current = UIViewController.currentViewController()
            if let _ = current.navigationController?.navigationBar,
                current == self.collectionVC {
                UIView.animate(withDuration: 0.3, animations: {
                    self.shiftNavigationWith(scrollView: self, oldValue: .zero)
                    self.shiftParallax(scrollView: self, oldValue: .zero)
                })
            }
        }
    }
    
    override open var contentInset: UIEdgeInsets {
        didSet {
            let style = parallaxLayout.collectionStyle
            self.setHeaderStyle(style: style)
        }
    }
    
    override open var contentOffset: CGPoint {
        didSet {
            
            if self.contentOffset.y == oldValue.y {
                return
            }
            self.shiftParallax(scrollView: self, oldValue: oldValue)
            self.shiftNavigationWith(scrollView: self, oldValue: oldValue)
            if let parallax = parallaxView{
                self.drawMaskWith(parallax: parallax, scrollView: self,oldValue: oldValue)
            }
        }
    }
}

/**
 Private function
 **/
extension MMParallaxCollectionView {
    
    fileprivate func setUp() {
        self.showsVerticalScrollIndicator = false
        parallaxLayout.minimumInteritemSpacing = 0
        parallaxLayout.minimumLineSpacing = 0
        
        self.setCollectionViewLayout(parallaxLayout, animated: true)
        
        DispatchQueue.main.async {
            self.collectionVC = UIViewController.currentViewController()
            
            if let nav = self.collectionVC?.navigationController {
                self.originalNavHeight = nav.navigationBar.frame.height
            } else {
                self.originalNavHeight = 0
            }
            self.topMargin = self.getCollectionMargin()
            self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            let addOffset = self.topMargin
            self.contentOffset = CGPoint.init(x: 0, y: -(self.originalNavHeight+addOffset))

        }
    }
    
    public func drawMaskWith(parallax:UIView,scrollView:UIScrollView,oldValue:CGPoint) {
        let realOffsetY = scrollView.contentOffset.y+scrollView.contentInset.top
        let topHeight = self.originalNavHeight
        let constantAdd = (parallaxTopConstraint != nil) ? ( topHeight-parallaxTopConstraint!.constant) : 0
        let rect = CGRect.init(x: 0, y: 0, width: parallax.frame.width, height: parallax.frame.height-realOffsetY+constantAdd)
        
        let shape = CAShapeLayer()
        shape.frame = parallax.bounds
        shape.fillColor  = UIColor.blue.cgColor
        shape.path = UIBezierPath.init(rect: rect).cgPath
        parallax.layer.mask = shape
        
        let layer = CAShapeLayer()
        let mask = (realOffsetY < 0) ? realOffsetY : 0
        layer.path = UIBezierPath.init(rect: CGRect.init(x: 0, y: mask, width: self.frame.width, height: self.contentSize.height)).cgPath
        self.layer.mask = layer
    }
    
    public func shiftNavigationWith(scrollView:UIScrollView,oldValue:CGPoint) {
        if let bar = self.collectionVC?.navigationController?.navigationBar{
            let total = originalNavHeight - topMargin

            if self.contentOffset.y >= -total && self.contentOffset.y < 0 {
                let value = abs(self.contentOffset.y)
                bar.frame.origin.y = value - originalNavHeight + topMargin
                let minY = (originalNavHeight)
                let alphaPercent = (bar.frame.origin.y-minY)/originalNavHeight
                self.barItemAlpha(alpha: alphaPercent)
            } else if self.contentOffset.y <= -total {
                self.showNavigationBar(isShow: true, animated: false)
            } else if self.isBarNeedHidden(){
                self.showNavigationBar(isShow: false, animated: false)
            }
        }
    }
    
    public func shiftParallax(scrollView:UIScrollView,oldValue:CGPoint) {
        
        if let bar = self.collectionVC?.navigationController?.navigationBar,
           let p = parallaxTopConstraint{
            // - up + down
            let shiftValue = oldValue.y-scrollView.contentOffset.y
            let willShiftY = p.constant+(shiftValue/2)
            let realOffsetY = scrollView.contentOffset.y+scrollView.contentInset.top
            let total = (bar.isTranslucent) ? originalNavHeight : 0.0
            
            let translcentHeight:CGFloat = (bar.isTranslucent) ? 0 : -(originalNavHeight)
            if realOffsetY < 0 {
                p.constant = total
            } else if willShiftY > topMargin+translcentHeight && willShiftY < total{
                p.constant = willShiftY
            } else if willShiftY < topMargin+translcentHeight {
                p.constant = topMargin + translcentHeight
            } else if willShiftY > total {
                p.constant =  total
            }
        }
    }
    
    public func isBarNeedHidden () -> Bool {
        if let _ = collectionVC?.navigationController?.navigationBar {
            return self.contentOffset.y >= 20
        }
        return false
    }
    
    public func getCollectionMargin () -> CGFloat {
        for c in self.superview!.constraints {
            if let _ = c.firstItem as? MMParallaxCollectionView , c.firstAttribute == . top {
                return originalNavHeight + c.constant
            }
        }
        return 0.0
    }
    
    public func barItemAlpha(alpha:CGFloat) {
        if let rate = self.navHiddenRate {
            rate(alpha)
        }
    }

}
