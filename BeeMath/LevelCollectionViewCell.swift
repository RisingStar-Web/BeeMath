//
//  LevelCollectionViewCell.swift
//  BeeMath
//
//  Created by Денис Марков on 3/6/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.layer.cornerRadius = label.frame.height / 2
            label.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(level: Int) {
        label.text = "\(level)"
    }

}
