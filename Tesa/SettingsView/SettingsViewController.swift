//
//  SettingsViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-23.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    private var viewModel: DataListViewModel!
    private let sectionTitle = ["Data", "Chart"]
    var safeArea: UILayoutGuide!
    
    var defaultFrequency: ObservableObject<Frequency>?
        
    let cellModels: [(title: String, models: [SettingsTableCell.CellModel])] = [
        (title: "Data", models: [
            SettingsTableCell.CellModel(id: .DefaultFrequency)
        ]),
        (title: "Chart", models: [
            SettingsTableCell.CellModel(id: .ExcludeEmptyBar),
//            SettingsTableCell.CellModel(id: .DefaultGroup),
//            SettingsTableCell.CellModel(id: .DefaultFilter)
        ])
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        return tableView
    }()
    
    init(viewModel: DataListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        defaultFrequency = ObservableObject(value: UserDefaults.getDefaultFrequency(), listeners: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.safeArea = view.layoutMarginsGuide
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configNavBar()
        configSubviews()
    }
    
    func configNavBar() {
        self.title = "Settings"
    }
    
    func configSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
//    func getCellModel(with id: SettingsTableCell.ID) -> SettingsTableCell.CellModel? {
//        let result = cellModels.filter({ model in
//            return model.id == id
//        })
//        return result.count > 0 ? result[0] : nil
//    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellModels[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels[section].models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier, for: indexPath)
        if let cell = cell as? SettingsTableCell {
            let cellModel = cellModels[indexPath.section].models[indexPath.row]
            viewModel.addDefaultFrequencyObserver(listener: cell)
            cell.configLayout(with: cellModel, delegate: self)
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = cellModels[indexPath.section].models[indexPath.row]
        if cellModel.id == .DefaultFrequency {
            self.navigationController?.pushViewController(FrequencyViewController(with: viewModel.defaultFrequency.getValue().mode, delegate: self), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: FrequencyViewDelegate {
    func selectedFrequency(with mode: Frequency.Mode) {
        UserDefaults.setDefaultFrequency(mode: mode)
        viewModel.defaultFrequency.setValue(newValue: Frequency(mode: mode))
    }
}

extension SettingsViewController: SettingTableCellDelegate {
    func emptyBarSettingChanged(newValue: Bool) {
        viewModel.emptyBarSetting.setValue(newValue: newValue)
    }
}
