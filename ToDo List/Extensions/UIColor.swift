//
//  UIColor.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        let validLengths = [6, 8]
        guard validLengths.contains(hexString.count) else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        if hexString.count == 8 {
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
            )
        } else {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha
            )
        }
    }
    
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
