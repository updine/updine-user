//
//  OneCollectionViewCell.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/25/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit

class OneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setLabel(_ given: String){
        cellLabel.text = given
    }
    
    func setFoodSpot(diner: FoodSpot) {
        imageView.image = diner.image
    }
    
    
    
    
}
