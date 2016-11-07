//
//  BaseViewControllerViewController.swift
//  MMParallaxCollectionView
//
//  Created by Millman YANG on 2016/11/4.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MMParallaxCollectionView
class BaseViewController: UIViewController {
    @IBOutlet weak var collection:MMParallaxCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        self.collection.register(UINib.init(nibName: "HeaderTitleView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderTitleView")
        self.collection.register(UINib.init(nibName: "TitleCell", bundle: nil), forCellWithReuseIdentifier: "TitleCell")
        
        self.collection.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
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
