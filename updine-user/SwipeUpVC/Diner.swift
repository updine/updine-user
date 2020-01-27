//
//  Diner.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/15/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import Foundation
import UIKit

class Diner {
    var image: UIImage
    var date: String?
    var day: String?
    
    init(image: UIImage, date: String, day: String) {
        self.image = image
        self.date = date
        self.day = day
    }
}

//dummy varaibles change the vars based on diner class instance variables
extension Diner {
    static let e1 = Diner(image: UIImage(named: "doner") ?? UIImage(), date: "8", day: "Sat")
    static let e2 = Diner(image: UIImage(named: "nopork") ?? UIImage(), date: "11", day: "Tue")
    static let e3 = Diner(image: UIImage(named: "soul") ?? UIImage(), date: "9", day: "Sun")
//    static let e4 = Diner(image: UIImage(named: "four") ?? UIImage(), date: "12", day: "Sat")
}
