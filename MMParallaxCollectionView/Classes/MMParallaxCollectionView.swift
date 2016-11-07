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
    fileprivate var topMargin:CGFloat = 0.0
    fileprivate var collectionVC:UIViewController?
    fileprivate var statusHeight = UIApplication.shared.statusBarFrame.height
    fileprivate var originalNavHeight:CGFloat = 0.0
    fileprivate var parallaxView:UIView?
    fileprivate var parallaxLayout = MMParallaxLayout()
    fileprivate var parallaxTopConstraint:NSLayoutConstraint?
    
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
                self.originalNavHeight = (self.collectionVC!.navigationController != nil) ? self.collectionVC!.navigationController!.navigationBar.frame.height : 0
                
                let topHeight = self.statusHeight + self.originalNavHeight
                view.layer.zPosition = -1
                self.backgroundColor = UIColor.clear
                superV.addSubview(view)
                superV.sendSubview(toBack: view)
                self.topMargin = self.getCollectionMargin()
                let addOffset = self.statusHeight - self.topMargin
                self.contentInset = UIEdgeInsets.init(top: height + self.originalNavHeight+addOffset, left: 0, bottom: 0, right: 0)
                self.contentOffset = CGPoint.init(x: 0, y: -(height + self.originalNavHeight+addOffset))

                view.translatesAutoresizingMaskIntoConstraints = false
                let left = NSLayoutConstraint.init(item: view, attribute: .left, relatedBy: .equal, toItem: superV, attribute: .left, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint.init(item: view, attribute: .right, relatedBy: .equal, toItem: superV, attribute: .right, multiplier: 1.0, constant: 0.0)
                self.parallaxTopConstraint = NSLayoutConstraint.init(item: view, attribute: .top, relatedBy: .equal, toItem: superV, attribute: .top, multiplier: 1.0, constant: 0)
                let height = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
                superV.addConstraints([left,right,self.parallaxTopConstraint!,height])
                self.parallaxView = view
                UIView.animate(withDuration: 0.3, animations: {
                    superV.layoutIfNeeded()
                })
            }
        }
    }
    
    public func showNavigationBar(isShow:Bool,animated:Bool) {
        
        if let bar = self.collectionVC?.navigationController?.navigationBar{
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    bar.frame.origin.y = (isShow) ? self.statusHeight : -self.originalNavHeight
                })
            } else {
                bar.frame.origin.y = (isShow) ? self.statusHeight : -self.originalNavHeight
            }
        }
    }
    
    public func setHeaderStyle(style:HeaderStyle) {
        parallaxLayout.collectionStyle = style
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
            self.originalNavHeight = (self.collectionVC!.navigationController != nil) ? self.collectionVC!.navigationController!.navigationBar.frame.height : 0
            self.topMargin = self.getCollectionMargin()
            self.contentInset = UIEdgeInsets.init(top: self.originalNavHeight + self.statusHeight-self.topMargin, left: 0, bottom: 0, right: 0)
            let addOffset = self.statusHeight - self.topMargin
            self.contentOffset = CGPoint.init(x: 0, y: -(self.originalNavHeight+addOffset))

        }
    }
    
    fileprivate func drawMaskWith(parallax:UIView,scrollView:UIScrollView,oldValue:CGPoint) {
        let realOffsetY = scrollView.contentOffset.y+scrollView.contentInset.top
        let topHeight = self.statusHeight + self.originalNavHeight
        let constantAdd = (parallaxTopConstraint != nil) ? ( topHeight-parallaxTopConstraint!.constant) : 0
        let rect = CGRect.init(x: 0, y: 0, width: parallax.frame.width, height: parallax.frame.height-realOffsetY+constantAdd)
        
        let shape = CAShapeLayer()
        shape.frame = parallax.bounds
        shape.fillColor  = UIColor.blue.cgColor
        shape.path = UIBezierPath.init(rect: rect).cgPath
        parallax.layer.mask = shape
    }
    
    fileprivate func shiftNavigationWith(scrollView:UIScrollView,oldValue:CGPoint) {
        let realOffsetY = scrollView.contentOffset.y+scrollView.contentInset.top
        if let bar = self.collectionVC?.navigationController?.navigationBar{
            let total = originalNavHeight + statusHeight - topMargin
            let translcentHeight:CGFloat = (bar.isTranslucent) ? 0 : (originalNavHeight + statusHeight)

            if self.contentOffset.y >= -total && self.contentOffset.y <= 0 {
                let value = abs(self.contentOffset.y)
                bar.frame.origin.y = self.contentOffset.y < 0 ? value - originalNavHeight + topMargin : -(originalNavHeight)
            } else if self.contentOffset.y <= -total {
                bar.frame.origin.y = statusHeight
            } else if self.isBarNeedHidden(){
                self.showNavigationBar(isShow: false, animated: false)
            }
        }
    }
    
    fileprivate func shiftParallax(scrollView:UIScrollView,oldValue:CGPoint) {
        
        if let bar = self.collectionVC?.navigationController?.navigationBar,
           let p = parallaxTopConstraint{
            // - up + down
            let shiftValue = oldValue.y-scrollView.contentOffset.y
            let willShiftY = p.constant+(shiftValue/2)
            let realOffsetY = scrollView.contentOffset.y+scrollView.contentInset.top
            let total = (bar.isTranslucent) ? originalNavHeight + statusHeight : 0.0
            
            let translcentHeight:CGFloat = (bar.isTranslucent) ? 0 : -(originalNavHeight + statusHeight)
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
    
    fileprivate func isBarNeedHidden () -> Bool {
        if let _ = collectionVC?.navigationController?.navigationBar {
            return self.contentOffset.y >= 0
        }
        return false
    }
    
    fileprivate func getCollectionMargin () -> CGFloat {
        for c in self.superview!.constraints {
            if let _ = c.firstItem as? MMParallaxCollectionView , c.firstAttribute == . top {
                return originalNavHeight + statusHeight + c.constant
            }
        }
        return 0.0
    }
}
