//
//  FrequencyTableCell.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-21.
//

import Foundation
import UIKit

class FrequencyTableCell: UITableViewCell {
    public static let identifier = "FREQUENCY_CELL_IDENTIFIER"
    
    var cellModel: Frequency?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    func configureCellLayout(with cellModel: Frequency, selectedFrequency: Frequency.Mode) {
        self.cellModel = cellModel
        self.accessoryType = cellModel.mode == selectedFrequency ? .checkmark : .none
        
        let dotRadius = 5
        
        let colorDotContainer = UIView()
        contentView.addSubview(colorDotContainer)
        colorDotContainer.translatesAutoresizingMaskIntoConstraints = false
        colorDotContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        colorDotContainer.widthAnchor.constraint(equalToConstant: CGFloat(2*dotRadius)).isActive = true
        colorDotContainer.heightAnchor.constraint(equalTo:contentView.heightAnchor).isActive = true
        
        let colorDot = UIView()
        colorDot.layer.cornerRadius = CGFloat(dotRadius)
        colorDot.backgroundColor = cellModel.color
        colorDotContainer.addSubview(colorDot)
        colorDot.translatesAutoresizingMaskIntoConstraints = false
        colorDot.heightAnchor.constraint(equalToConstant: CGFloat(2*dotRadius)).isActive = true
        colorDot.widthAnchor.constraint(equalToConstant: CGFloat(2*dotRadius)).isActive = true
        colorDot.centerXAnchor.constraint(equalTo: colorDotContainer.centerXAnchor).isActive = true
        colorDot.centerYAnchor.constraint(equalTo: colorDotContainer.centerYAnchor).isActive = true
        
        
        contentView.addSubview(label)
        label.text = cellModel.label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: colorDotContainer.rightAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
