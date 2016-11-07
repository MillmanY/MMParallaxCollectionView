//
//  FrontViewController.swift
//  MMParallaxCollectionView
//
//  Created by Millman YANG on 2016/11/4.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class FrontViewController: BaseViewController {
    var data = [["a","b","c","d","d"],["image1","image2","image3","image4","image5"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.setHeaderStyle(style: .front)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FrontViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 10, height: 50)
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

extension FrontViewController: UICollectionViewDataSource {
    
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

