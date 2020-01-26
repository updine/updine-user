//
//  LoginViewController.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/26/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: ("login"))
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginToTabViews", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToTabViews" {
//            let vc = segue.destination as! HomeViewController
            
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let destinationVC = tabCtrl.viewControllers![0] as! HomeViewController
        }
    }

}
