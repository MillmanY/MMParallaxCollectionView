//
//  ViewController.swift
//  ParallaxDemo
//
//  Created by Millman YANG on 2016/11/1.
//  Copyright © 2016年 Millman YANG. All rights reserved.
//

import UIKit
import MMParallaxCollectionView
class ParallaxViewController: BaseViewController {
    var data = [["Demo rear","Demo front"],["image1","image2","image3","image4","image5"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.register(UINib.init(nibName: "HeaderTitleView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderTitleView")
        self.collection.register(UINib.init(nibName: "TitleCell", bundle: nil), forCellWithReuseIdentifier: "TitleCell")
        
        self.collection.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collection.setHeaderStyle(style: .front)
        self.testParallax()
    }
        
    func testParallax() {
        let demo = ParallaxHeader.initWith(xib: "ParallaxHeader")
        collection.addParallax(view: demo,height: 180)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ParallaxViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collection.showNavigationBar(isShow: true, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "rear", sender: nil)
            case 1:
                self.performSegue(withIdentifier: "front", sender: nil)

            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 10, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        if indexPath.section == 0 {
            return CGSize.init(width: width, height: (width-12)/5)
        } else {
            return CGSize.init(width: width, height: 200)
        }
    }
}

extension ParallaxViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let info = data[indexPath.section][indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath) as? TitleCell,indexPath.section == 0{
            
            cell.setCellWith(title: info, isSelect: false)
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell, indexPath.section == 1 {
            cell.imgV.image = UIImage.init(named: info)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderTitleView", for: indexPath) as? HeaderTitleView {
            header.labTitle.text = "Section :\(indexPath.section)"
            return header
        }
        
        return UICollectionReusableView()
    }
}

