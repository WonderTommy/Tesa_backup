//
//  SettingsTableCell.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-23.
//

import Foundation
import UIKit

protocol SettingTableCellDelegate {
    func emptyBarSettingChanged(newValue: Bool)
}

class SettingsTableCell: UITableViewCell {
    public static let identifier = "SETTINGS_TABLE_CELL_IDENTIFIER"
    
    private var cellModel: CellModel?
    private var delegate: SettingTableCellDelegate?
    
    enum ID {
        case DefaultFrequency
        case ExcludeEmptyBar
        case DefaultGroup
        case DefaultFilter
    }
    
    class CellModel {
        let id: ID
        let label: String
        
        init(id: ID) {
            self.id = id
            
            switch id {
                case .DefaultFrequency:
                    self.label = "Default Frequency"
                case .ExcludeEmptyBar:
                    self.label = "Exclude Empty Bar"
                case .DefaultGroup:
                    self.label = "Default Group"
                case .DefaultFilter:
                    self.label = "Default Filter"
            }
        }
    }
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.textColor = .label
        return view
    }()
    
    var colorDot: UIView?
    var colorlabel: UILabel?
    
    public func configLayout(with model: CellModel, delegate: SettingTableCellDelegate) {
        self.cellModel = model
        self.delegate = delegate
        
        configLabel()
        switch model.id {
            case .DefaultFrequency:
                configColorSettingCell()
            case .ExcludeEmptyBar:
                configExcludeEmptyBarCell()
            case .DefaultGroup:
                configDefaultGroupCell()
            case .DefaultFilter:
                configDefaultFilterCell()
        }
    }
    
    private func configLabel() {
        if let cellModel = cellModel {
            self.label.text = cellModel.label
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        }
    }
    
    private func configColorSettingCell() {
        self.accessoryType = .disclosureIndicator
        
        if let cellModel = cellModel {
            let frequency = UserDefaults.getDefaultFrequency()
            
            let colorlabel = UILabel()
            self.colorlabel = colorlabel
            colorlabel.textColor = .secondaryLabel
            colorlabel.text = frequency.label
            contentView.addSubview(colorlabel)
            colorlabel.translatesAutoresizingMaskIntoConstraints = false
            colorlabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
            colorlabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            
            let colorDotContainer = UIView()
            contentView.addSubview(colorDotContainer)
            colorDotContainer.translatesAutoresizingMaskIntoConstraints = false
            colorDotContainer.rightAnchor.constraint(equalTo: colorlabel.leftAnchor, constant: -8).isActive = true
            colorDotContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
            colorDotContainer.widthAnchor.constraint(equalToConstant: 10).isActive = true
            
            let colorDot = UIView()
            self.colorDot = colorDot
            colorDot.layer.cornerRadius = 5
            colorDot.backgroundColor = frequency.color
            colorDotContainer.addSubview(colorDot)
            colorDot.translatesAutoresizingMaskIntoConstraints = false
            colorDot.heightAnchor.constraint(equalToConstant: 10).isActive = true
            colorDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
            colorDot.centerXAnchor.constraint(equalTo: colorDotContainer.centerXAnchor).isActive = true
            colorDot.centerYAnchor.constraint(equalTo: colorDotContainer.centerYAnchor).isActive = true
        }
    }
    
    private func configExcludeEmptyBarCell() {
        let switchButton = UISwitch()
        contentView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.isOn = UserDefaults.getExcludeEmptyBar()
        switchButton.addTarget(self, action: #selector(excludeEmptyBarChanged(_:)), for: .valueChanged)
    }
    
    private func configDefaultGroupCell() {
        
    }
    
    private func configDefaultFilterCell() {
        
    }
    
    @objc func excludeEmptyBarChanged(_ switchButton: UISwitch) {
        UserDefaults.setExcludeEmptyBar(switchButton.isOn)
        if let delegate = self.delegate {
            delegate.emptyBarSettingChanged(newValue: switchButton.isOn)
        }
    }
}

extension SettingsTableCell: ObservableObjectListener {
    func notify<V>(newValue: V) {
        if let frequency = newValue as? Frequency {
            self.colorDot?.backgroundColor = frequency.color
            self.colorlabel?.text = frequency.label
        }
    }
}
