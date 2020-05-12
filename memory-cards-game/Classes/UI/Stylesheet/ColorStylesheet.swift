//
//  ColorStylesheet.swift
//  WorldDominator
//
//  Created by Maksims Puskels on 31/03/2018.
//  Copyright © 2018 Chili Labs. All rights reserved.
//

import UIKit

private let kColorMinComponent: Int = 30
private let kColorMaxComponent: Int = 214

// todo: Used allover CHI projects. Move to unite place.
extension UIColor {

    class var gray4A4A4A: UIColor {
        return self.color(with: 0x4A4A4A)
    }

    class var gray8E8E93: UIColor {
        return self.color(with: 0x8E8E93)
    }

    class var grayC5C5C5: UIColor {
        return self.color(with: 0xC5C5C5)
    }

    class var gray6E6E6E: UIColor {
        return self.color(with: 0x6E6E6E)
    }

    class var grayD8D8D8: UIColor {
        return self.color(with: 0xD8D8D8)
    }

    class var blue4A90E2: UIColor {
        return self.color(with: 0x4A90E2)
    }

    class var coinValue: UIColor {
        return self.color(with: 0x78BC1E)
    }

    class var mainTint: UIColor {
        return self.color(with: 0x4A90E2)
    }

    class var cellSelection: UIColor {
        return self.color(with: 0xF2F2F2)
    }

    class var disabledBubble: UIColor {
        return self.color(with: 0x9B9B9B)
    }

    class var cityCellLine: UIColor {
        return self.color(with: 0xF6F9FD)
    }

    class var cityCellLineDisabled: UIColor {
        return self.color(with: 0xF6F6F6)
    }

    class var green68A31A: UIColor {
        return self.color(with: 0x68A31A)
    }

    class var redF8333C: UIColor {
        return self.color(with: 0xF8333C)
    }

    class var greenEFF6F5: UIColor {
        return self.color(with: 0xEFF6F5)
    }

    class var green60A699: UIColor {
        return self.color(with: 0x60A699)
    }

    class var blueEDF4FD: UIColor {
        return self.color(with: 0xEDF4FD)
    }

    class var blue69BBF1: UIColor {
        return self.color(with: 0x69BBF1)
    }

    class var blue004C8D: UIColor {
        return self.color(with: 0x004C8D)
    }

    class var blue1B2330: UIColor {
        return self.color(with: 0x1B2330)
    }

    class var blueDAF1FF: UIColor {
        return self.color(with: 0xDAF1FF)
    }

    class var redFEEBEC: UIColor {
        return self.color(with: 0xFEEBEC)
    }

    class var redF8343D: UIColor {
        return self.color(with: 0xF8343D)
    }

    class func color(with hex: UInt) -> UIColor {
        let red = (CGFloat)((hex & 0xFF0000) >> 16) / (CGFloat)(255)
        let green = (CGFloat)((hex & 0xFF00) >> 8) / (CGFloat)(255)
        let blue = (CGFloat)(hex & 0xFF) / (CGFloat)(255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    class func colorFromString(colorString: String) -> UIColor {
        var rgbValue: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        let hex = UInt(rgbValue)
        return self.color(with: hex)
    }

    convenience init(string: String) {
        let hash: Int = string.hashValue

        let r: Int = (hash & 0xFF0000) >> 16
        let g: Int = (hash & 0x00FF00) >> 8
        let b: Int = (hash & 0x0000FF)

        let red = CGFloat(min(max(kColorMinComponent, r), kColorMaxComponent)) / 255.0
        let green = CGFloat(min(max(kColorMinComponent, g), kColorMaxComponent)) / 255.0
        let blue = CGFloat(min(max(kColorMinComponent, b), kColorMaxComponent)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
