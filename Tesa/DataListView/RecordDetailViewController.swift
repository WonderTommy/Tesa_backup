//
//  RecordDetailViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-17.
//

import Foundation
import UIKit

protocol RecordDetailDelegate {
    func addRecord(title: String, amount: Double, dateTime: Date, frequency: Frequency)
    func updateRecord(model: Expenditure, title: String, amount: Double, dateTime: Date, frequency: Frequency)
    func getDate() -> Date
}

class RecordDetailViewController: UIViewController {
    enum Mode {
        case NEW
        case EDIT
    }

    let numberOfSections: Int = 1
    
    var cellModels: [ItemDetailCell.CellModel] = [
        ItemDetailCell.CellModel(id: .Date),
        ItemDetailCell.CellModel(id: .Time),
        ItemDetailCell.CellModel(id: .Label),
        ItemDetailCell.CellModel(id: .Amount),
        ItemDetailCell.CellModel(id: .Frequency),
    ]
    
    var safeArea: UILayoutGuide!
    var mode: Mode?
    var delegate: RecordDetailDelegate?
    var dataModel: Expenditure?
    
    var selectedFrequency: ObservableObject<Frequency.Mode>?
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .insetGrouped)
        view.register(ItemDetailCell.self, forCellReuseIdentifier: ItemDetailCell.identifier)
        return view
    }()
    
    convenience init(mode: Mode, delegate: RecordDetailDelegate) {
        self.init(mode: mode, dataModel: nil, delegate: delegate)
    }
    
    init(mode: Mode, dataModel: Expenditure?, delegate: RecordDetailDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        self.dataModel = dataModel
        self.delegate = delegate
        selectedFrequency = ObservableObject(value: Frequency.Mode(rawValue: Int(dataModel?.frequencyMode ?? 0))!, listeners: [])
        
        for cellModel in cellModels {
            cellModel.populateExistingValue(dataModel: dataModel, specifyTime: delegate.getDate())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.safeArea = view.layoutMarginsGuide
        
        configNavBar()
        configSubviews()
    }
        
    private func configNavBar() {
        self.title = "Expenditure"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        
        if let mode = self.mode {
            switch mode {
            case .NEW:
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addItem))
            case .EDIT:
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateItem))
            default:
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addItem() {
        if let title = getCellModel(id: .Label)?.textField,
           let amountText = getCellModel(id: .Amount)?.textField,
           let date = getCellModel(id: .Date)?.dateTime,
           let time = getCellModel(id: .Time)?.dateTime,
           let frequency = getCellModel(id: .Frequency)?.frequency {
            if let amount = Double(amountText), title.count > 0 {
                delegate?.addRecord(title: title, amount: amount, dateTime: mergeDateTime(date: date, time: time), frequency: frequency)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateItem() {
        if let dataModel = self.dataModel {
            if let title = getCellModel(id: .Label)?.textField,
               let amountText = getCellModel(id: .Amount)?.textField,
               let date = getCellModel(id: .Date)?.dateTime,
               let time = getCellModel(id: .Time)?.dateTime,
               let frequency = getCellModel(id: .Frequency)?.frequency {
                if let amount = Double(amountText), title.count > 0 {
                    delegate?.updateRecord(model: dataModel, title: title, amount: amount, dateTime: mergeDateTime(date: date, time: time), frequency: frequency)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func mergeDateTime(date: Date, time: Date) -> Date {
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        var timeComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: time)
        timeComponent.year = dateComponent.year
        timeComponent.month = dateComponent.month
        timeComponent.day = dateComponent.day
        let dateTime = Calendar(identifier: .gregorian).date(from: timeComponent) ?? Date()
        return dateTime
    }
    
    private func configSubviews() {
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func getCellModel(id: ItemDetailCell.ID) -> ItemDetailCell.CellModel? {
        let result = self.cellModels.filter({ model in
            return model.id == id
        })
        if result.count > 0 {
            return result.first
        } else {
            return nil
        }
    }
}

extension RecordDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailCell.identifier, for: indexPath) as! ItemDetailCell

        cell.configureCellLayout(model: cellModels[indexPath.row])
        selectedFrequency?.addListener(cell)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
}

extension RecordDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ItemDetailCell,
           let cellModel = cell.cellModel {
            switch cellModel.id {
                case .Date, .Time, .Label, .Amount:
                    cell.focusOnField()
                case .Frequency:
                    navigationController?.pushViewController(FrequencyViewController(with: cellModel.frequency.mode, delegate: self), animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension RecordDetailViewController: FrequencyViewDelegate {
    func selectedFrequency(with mode: Frequency.Mode) {
        selectedFrequency?.setValue(newValue: mode)
    }
}
