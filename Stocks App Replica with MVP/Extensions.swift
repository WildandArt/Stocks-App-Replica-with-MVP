//
//  Extensions.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 07/12/2022.
//

import UIKit

extension UIView {
    func addSubviews(views: UIView...){
        for view in views{
            self.addSubview(view)
        }
    }
}

extension NumberFormatter{
    static var customNumberFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
