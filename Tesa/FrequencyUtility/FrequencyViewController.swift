//
//  FrequencyViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-21.
//

import Foundation
import UIKit

protocol FrequencyViewDelegate {
    func selectedFrequency(with mode: Frequency.Mode)
}

class FrequencyViewController: UIViewController {
    var numberOfSctions: Int = 1
    var safeArea: UILayoutGuide!
    
    var cellModels: [Frequency] = []
    var selectedFrequency: Frequency.Mode
    var delegate: FrequencyViewDelegate
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .insetGrouped)
        view.register(FrequencyTableCell.self, forCellReuseIdentifier: FrequencyTableCell.identifier)
        return view
    }()
    
    init(with mode: Frequency.Mode, delegate: FrequencyViewDelegate) {
        self.selectedFrequency = mode
        self.delegate = delegate
        for mode in Frequency.Mode.allCases {
            cellModels.append(Frequency(mode: mode))
        }
        super.init(nibName: nil, bundle: nil)
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
        self.title = "Frequency"
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
//
//        if let mode = self.mode {
//            switch mode {
//            case .NEW:
//                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addItem))
//            case .EDIT:
//                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateItem))
//            default:
//                navigationItem.rightBarButtonItem = nil
//            }
//        }
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
}

extension FrequencyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSctions
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FrequencyTableCell.identifier, for: indexPath) as! FrequencyTableCell
        cell.configureCellLayout(with: self.cellModels[indexPath.row], selectedFrequency: self.selectedFrequency)
        
        return cell
    }
}

extension FrequencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectedFrequency(with: cellModels[indexPath.row].mode)
        self.navigationController?.popViewController(animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
