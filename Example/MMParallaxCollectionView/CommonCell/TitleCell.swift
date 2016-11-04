//
//  TitleCell.swift
//  owlpass-ios-app-v2
//
//  Created by Millman YANG on 2016/10/31.
//  Copyright © 2016年 Millman YANG. All rights reserved.
//

import UIKit

class TitleCell: UICollectionViewCell {

    @IBOutlet weak var labTitle:UILabel!
    
    func setCellWith(title:String,isSelect:Bool) {
        self.labTitle.text = title
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
