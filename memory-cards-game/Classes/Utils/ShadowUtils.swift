//
//  ShadowUtils.swift
//  memory-cards-game
//
//  Created by Kristīne Kazakēviča on 05/05/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
}
