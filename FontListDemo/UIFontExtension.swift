//
//  UIFontExtension.swift
//  FontListDemo
//
//  Created by Alexandre Malkov on 12/02/2018.
//  Copyright © 2018 iosSolutionBox. All rights reserved.
//

import UIKit

extension UIFont {
    
    /*
     This function return list of all fonts regardless of font family group
     **/
    static func getFullFontList() -> [String] {
        var results = [String]()
        for fontFamilyName in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
                results.append(fontName)
            }
        }
        return results
    }
}
