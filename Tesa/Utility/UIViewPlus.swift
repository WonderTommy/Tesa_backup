//
//  UIViewPlus.swift
//  Tesa
//
//  Created by Hao Li on 2022-08-06.
//

import Foundation
import UIKit

extension UIView {
    func neumorphism(shadowRadius: CGFloat, shadowOffset: CGFloat, cornerRadius: CGFloat) {
        self.layoutIfNeeded()
        self.layer.masksToBounds = false

        let darkShadow = CALayer()
        darkShadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        darkShadow.backgroundColor = self.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor.black.cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        darkShadow.shadowOpacity = 0.6
        darkShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(darkShadow, at: 1)

        let lightShadow = CALayer()
        lightShadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        lightShadow.backgroundColor = self.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowOffset, height: -shadowOffset)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(lightShadow, at: 0)
    }
}
