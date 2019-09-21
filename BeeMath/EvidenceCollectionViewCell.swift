//
//  EvidenceCollectionViewCell.swift
//  BeeMath
//
//  Created by Денис Марков on 3/5/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import UIKit

class EvidenceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var red: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUp(evidence: Evidence) {
        label.text = evidence.text
        imageView.image = evidence.isLeft ? #imageLiteral(resourceName: "upSotaLeft") : #imageLiteral(resourceName: "upSota")
        red.isHidden = !evidence.wrong
    }

}
