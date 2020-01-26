//
//  ViewController.swift
//  verticalScroll
//
//  Created by Yasin Ehsan on 1/25/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var blackView: UIView!
    
     var animator: UIViewPropertyAnimator?

       func createBottomView() {
           guard let sub = storyboard!.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController else { return }
           self.addChild(sub)
           self.view.addSubview(sub.view)
           sub.didMove(toParent: self)
           sub.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
           sub.minimize(completion: nil)
       }

       func subViewGotPanned(_ percentage: Int) {
           guard let propAnimator = animator else {
               animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                   self.blackView.alpha = 1
//                   self.someView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: -20))
               })
               animator?.startAnimation()
               animator?.pauseAnimation()
               return
           }
           propAnimator.fractionComplete = CGFloat(percentage) / 100
       }

       func receiveNotification(_ notification: Notification) {
           guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
           subViewGotPanned(percentage)
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           createBottomView()

           let name = NSNotification.Name(rawValue: "BottomViewMoved")
           NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
       }


}

