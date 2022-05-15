//
//  UIView+Extension.swift
//  ScalioAssignment
//
//  Created by gnc on 14/05/2022.
//

import Foundation
import UIKit

extension UIView {
    func setBorder() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.borderColor = Constants.borderColor.cgColor
        self.layer.borderWidth = Constants.borderWidth
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width*0.8, height: 35))
        toastLabel.center = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height-100)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0;
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


    
}
