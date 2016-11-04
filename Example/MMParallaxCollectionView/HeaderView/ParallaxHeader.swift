//
//  ParallaxHeader.swift
//  MMParallaxCollectionView
//
//  Created by Millman YANG on 2016/11/4.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class ParallaxHeader: UIView ,UIScrollViewDelegate{
    @IBOutlet weak var scorllView:UIScrollView!
    @IBOutlet weak var page:UIPageControl!
    static func initWith(xib:String) -> ParallaxHeader {
        return Bundle.main.loadNibNamed(xib, owner: self, options: nil)?.first as! ParallaxHeader
    }

    override func awakeFromNib() {
        self.demoScrollView()
    }
    
    func demoScrollView() {
        let width = UIScreen.main.bounds.width
        for i in 1...5{
            
            let img = UIImage.init(named: "image\(i)")
            let imgV = UIImageView.init(image: img)
            imgV.frame = CGRect.init(x: CGFloat(i-1)*width, y: 0, width: width, height: 180)
            scorllView.addSubview(imgV)
        }
        self.scorllView.contentSize = CGSize.init(width: width*CGFloat(5), height: 180)
        page.numberOfPages = 5
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        page.currentPage = Int(pageNumber)
    }
}
