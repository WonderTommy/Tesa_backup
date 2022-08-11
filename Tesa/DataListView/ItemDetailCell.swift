//
//  ItemDetailCell.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-19.
//

import Foundation
import UIKit

class ItemDetailCell: UITableViewCell, UITextFieldDelegate {
    public static let identifier = "ITEM_DETAIL_CELL_IDENTIFIER"
    
    enum CellType {
        case Input
        case Pick
        case Accessory
    }
    
    enum ID {
        case Label
        case Amount
        case Time
        case Date
        case Frequency
    }
    
    class CellModel {
        let id: ID
        let label: String
        let cellType: CellType
        
        let keyboardStyle: UIKeyboardType
        let datePickerMode: UIDatePicker.Mode
        
        var textField: String = ""
        var dateTime: Date = Date()
        var frequency: Frequency = Frequency.init(mode: .None)
        
        init(id: ID) {
            self.id = id
            switch id {
                case .Label:
                    self.label = "Label/Location"
                    self.cellType = .Input
                    self.keyboardStyle = .default
                    self.datePickerMode = .time
                    self.textField = ""
                    self.dateTime = Date()
                case .Amount:
                    self.label = "Amount"
                    self.cellType = .Input
                    self.keyboardStyle = .decimalPad
                    self.datePickerMode = .time
                    self.textField = ""
                    self.dateTime = Date()
                case .Time:
                    self.label = "Time"
                    self.cellType = .Pick
                    self.keyboardStyle = .default
                    self.datePickerMode = .time
                    self.textField = ""
                    self.dateTime = Date()
                case .Date:
                    self.label = "Date"
                    self.cellType = .Pick
                    self.keyboardStyle = .default
                    self.datePickerMode = .date
                    self.textField = ""
                    self.dateTime = Date()
                case .Frequency:
                    self.label = "Frequency"
                    self.cellType = .Accessory
                    self.keyboardStyle = .default
                    self.datePickerMode = .date
                    self.textField = ""
                    self.dateTime = Date()
            }
        }
        
        func populateExistingValue(dataModel: Expenditure?, specifyTime: Date?) {
            if let dataModel = dataModel {
                switch id {
                    case .Label:
                        textField = dataModel.title ?? ""
                    case .Amount:
                        textField = String(dataModel.amount)
                    case .Time:
                        dateTime = dataModel.dateTime ?? Date()
                        textField = ItemDetailCell.formatDateTime(date: dateTime, mode: .time)
                    case .Date:
                        dateTime = dataModel.dateTime ?? Date()
                        textField = ItemDetailCell.formatDateTime(date: dateTime, mode: .date)
                    case .Frequency:
                        frequency = Frequency(rawValue: Int(dataModel.frequencyMode))
                }
            } else {
                switch id {
                    case .Label:
                        textField = ""
                    case .Amount:
                        textField = ""
                    case .Time:
                        dateTime = specifyTime ?? Date()
                        textField = ItemDetailCell.formatDateTime(date: dateTime, mode: .time)
                    case .Date:
                        dateTime = specifyTime ?? Date()
                        textField = ItemDetailCell.formatDateTime(date: dateTime, mode: .date)
                    case .Frequency:
                        frequency = UserDefaults.getDefaultFrequency() //Frequency.init(mode: .None)
                }
            }
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var inputField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(updateTextField(textField:)), for: .editingChanged)
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if let cellModel = self.cellModel {
            datePicker.datePickerMode = cellModel.datePickerMode
        }
        datePicker.addTarget(self, action: #selector(onDateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    lazy var colorDot: UIView = {
        let colorDot = UIView()
        colorDot.backgroundColor = .red
        var frame = colorDot.frame
        frame.size.height = 10
        frame.size.width = 10
        colorDot.frame = frame
        colorDot.layer.cornerRadius = 5
        return colorDot
    }()

    var cellModel: CellModel?
    
    public func configureCellLayout(model: CellModel) {
        self.cellModel = model
        
        switch model.cellType {
            case .Input, .Pick:
                configLableTextFieldCellLayout()
            case .Accessory:
                configLableLabelColorCellLayout()
        }
    }
    
    private func configLableTextFieldCellLayout() {
        if let model = self.cellModel {
            contentView.addSubview(label)
            label.text = model.label
            
            contentView.addSubview(inputField)
            inputField.text = model.textField
            inputField.delegate = self
            
            if model.cellType == .Input {
                inputField.keyboardType = model.keyboardStyle
            } else if model.cellType == .Pick {
                datePicker.date = model.dateTime
                inputField.inputView = datePicker
            }
            
            inputField.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let views = ["input": inputField, "label": self.label]
            let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-[input]-|", options: [], metrics: nil, views: views)
            let verticalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[input]|", options: [], metrics: nil, views: views)
            let verticalConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
            self.contentView.addConstraints(horizontalConstraint)
            self.contentView.addConstraints(verticalConstraint1)
            self.contentView.addConstraints(verticalConstraint2)
            
        }
    }
    
    private func configLableLabelColorCellLayout() {
        if let model = self.cellModel {
            contentView.addSubview(label)
            label.text = model.label
            
            let rightView = UIView()
            contentView.addSubview(rightView)
//            rightView.backgroundColor = .red
//            valueLabel.text = model.frequency.label
            
            rightView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let views = ["label": self.label, "rightView": rightView]
            let horizontalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-[rightView]-|", options: [], metrics: nil, views: views)
            let verticalConstraint1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[rightView]|", options: [], metrics: nil, views: views)
            let verticalConstraint2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
            self.contentView.addConstraints(horizontalConstraint1)
            self.contentView.addConstraints(verticalConstraint1)
            self.contentView.addConstraints(verticalConstraint2)
            
            if (model.cellType == .Accessory) {
                self.accessoryType = .disclosureIndicator
                colorDot.backgroundColor = cellModel?.frequency.color
                valueLabel.text = cellModel?.frequency.label
            }
            
            rightView.addSubview(valueLabel)
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.rightAnchor.constraint(equalTo: rightView.rightAnchor).isActive = true
            valueLabel.centerYAnchor.constraint(equalTo: rightView.centerYAnchor).isActive = true
            
            let colorDotContainer = UIView()
            rightView.addSubview(colorDotContainer)
            colorDotContainer.translatesAutoresizingMaskIntoConstraints = false
            colorDotContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
            colorDotContainer.widthAnchor.constraint(equalToConstant: 10).isActive = true
            colorDotContainer.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -8).isActive = true

            colorDotContainer.addSubview(colorDot)
            colorDot.translatesAutoresizingMaskIntoConstraints = false
            colorDot.centerXAnchor.constraint(equalTo: colorDotContainer.centerXAnchor).isActive = true
            colorDot.centerYAnchor.constraint(equalTo: colorDotContainer.centerYAnchor).isActive = true
            colorDot.heightAnchor.constraint(equalToConstant: 10).isActive = true
            colorDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        }
    }
    
    public func focusOnField() {
        inputField.becomeFirstResponder()
        if cellModel?.cellType == .Pick {
            inputField.text = formatDateTime()
        }
    }
    
    @objc public func updateTextField(textField: UITextField) {
        self.cellModel?.textField = textField.text ?? ""
    }
    
    @objc public func onDateChange(datePicker: UIDatePicker) {
        inputField.text = formatDateTime()
        self.cellModel?.textField = inputField.text ?? ""
        self.cellModel?.dateTime = datePicker.date
    }
    
    private func formatDateTime() -> String {
        return ItemDetailCell.formatDateTime(date: datePicker.date, mode: datePicker.datePickerMode)
    }
    
    static func formatDateTime(date: Date, mode: UIDatePicker.Mode) -> String {
        let formatter = DateFormatter()
        switch mode {
            case .date:
                formatter.dateFormat = "MMMM dd, yyyy"
            case .time:
                formatter.dateFormat = "HH:mm"
            default:
                formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        <#code#>
//    }
}

extension ItemDetailCell: ObservableObjectListener {
    func notify<V>(newValue: V) {
        if let cellModel = self.cellModel,
           let value = newValue as? Frequency.Mode,
           cellModel.id == .Frequency {
            cellModel.frequency = Frequency(mode: value)
            colorDot.backgroundColor = cellModel.frequency.color
            valueLabel.text = cellModel.frequency.label
        }
    }
}
