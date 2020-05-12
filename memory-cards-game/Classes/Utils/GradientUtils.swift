//
//  GradientUtils.swift
//  memory-cards-game
//
//  Created by Kristīne Kazakēviča on 05/05/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit

extension UIViewController {
    func addBackgroundGradient() {
         let gradient: CAGradientLayer = CAGradientLayer()

         gradient.colors = [UIColor.blue69BBF1.cgColor, UIColor.blue004C8D.cgColor]
         gradient.locations = [0, 1]
         gradient.startPoint = CGPoint(x: 0, y: 0)
         gradient.endPoint = CGPoint(x: 0, y: 1)
         gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)

         view.layer.insertSublayer(gradient, at: 0)
     }
}
