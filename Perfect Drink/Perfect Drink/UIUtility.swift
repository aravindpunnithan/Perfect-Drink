//
//  UIUtility.swift
//  Perfect Drink
//
//  Created by Aravind P on 13/03/22.
//

import UIKit

public struct UIUtility {
    
    public func getLabel(with text: String,font: UIFont) -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.text = text
        label.font = font
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
}
