//
//  FoodSpot.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/26/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import Foundation
import UIKit

class FoodSpot {
    var image: UIImage
    var info: String?
    
   
   init(image: UIImage, info: String) {
       self.image = image
       self.info = info
   }
}

extension FoodSpot {
    static let f1 = FoodSpot(image: UIImage(named: "doner") ?? UIImage(), info: "")
    static let f2 = FoodSpot(image: UIImage(named: "nopork") ?? UIImage(), info: "")
    static let f3 = FoodSpot(image: UIImage(named: "soul") ?? UIImage(), info: "")
}
