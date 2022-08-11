//
//  DataListTableViewCell.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-16.
//

import Foundation
import UIKit

class DataListTableViewCell: UITableViewCell {
    public static let identifier = "DATA_LIST_TABLE_VIEW_CELL"
    
    lazy var titleLabel = {
        return UILabel()
    }()
    
    lazy var amountLabel = {
        return UILabel()
    }()
    
    public func configureCell(title: String, amount: String, color: UIColor) {
        amountLabel.text = amount
        
        let leftView = UIView()
        contentView.addSubview(leftView)
        contentView.addSubview(self.amountLabel)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["leftView": leftView, "amount": amountLabel]
        let horizontalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[leftView]-[amount]-|", options: [], metrics: nil, views: views)
        let verticalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftView]|", options: [], metrics: nil, views: views)
        let verticalConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[amount]|", options: [], metrics: nil, views: views)
        self.addConstraints(horizontalConstraint1)
        self.addConstraints(verticalConstraint1)
        self.addConstraints(verticalConstraint2)
        
        titleLabel.text = title
        
        let dotContainer = UIView()
        leftView.addSubview(dotContainer)
        dotContainer.translatesAutoresizingMaskIntoConstraints = false
        dotContainer.leftAnchor.constraint(equalTo: leftView.leftAnchor).isActive = true
        dotContainer.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dotContainer.heightAnchor.constraint(equalTo: leftView.heightAnchor).isActive = true
        
        let colorDot = UIView()
        dotContainer.addSubview(colorDot)
        colorDot.translatesAutoresizingMaskIntoConstraints = false
        colorDot.layer.cornerRadius = 5
        colorDot.heightAnchor.constraint(equalToConstant: 10).isActive = true
        colorDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        colorDot.centerXAnchor.constraint(equalTo: dotContainer.centerXAnchor).isActive = true
        colorDot.centerYAnchor.constraint(equalTo: dotContainer.centerYAnchor).isActive = true
        colorDot.backgroundColor = color
        
        leftView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: dotContainer.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        
    }
}
