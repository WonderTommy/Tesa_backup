//
//  DataListViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-16.
//

import Foundation
import UIKit
import Charts

class DataListViewController: UIViewController {
    public static let dataListTableViewCell = "DATA_LIST_TABLE_VIEW_CELL"
    var safeArea: UILayoutGuide!
    
    private var viewModel: DataListViewModel!
    private var dataList: [Expenditure]?
    
    var dateFilter: String?
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .insetGrouped)
        view.register(DataListTableViewCell.self, forCellReuseIdentifier: DataListTableViewCell.identifier)
        return view
    }()
    
    
    init(viewModel: DataListViewModel, dataList: [Expenditure]?, dateFilter: String?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        viewModel.addDataListListener(listener: self)
        self.dataList = dataList
        self.dateFilter = dateFilter
    }
    
    convenience init(viewModel: DataListViewModel) {
        self.init(viewModel: viewModel, dataList: nil, dateFilter:nil)
    }
    
    convenience init(viewModel: DataListViewModel, dateFilter: String) {
        self.init(viewModel: viewModel, dataList: nil, dateFilter: dateFilter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.safeArea = view.layoutMarginsGuide
        
        addTestData()
        
        configNavBar()
        configSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configNavBar() {
        self.title = "Records"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddRecordViewController))
    }
    
    @objc func presentAddRecordViewController() {
        let addVC = RecordDetailViewController(mode: .NEW, delegate: self)
        present(UINavigationController(rootViewController: addVC), animated: true, completion: nil)
    }
    
    func presentUpdateRecordViewController(index: Int) {
        let updateVC = RecordDetailViewController(mode: .EDIT, dataModel: getExpenditure(at: index), delegate: self)
        present(UINavigationController(rootViewController: updateVC), animated: true, completion: nil)
    }
    
    private func configSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func getExpenditure(at index: Int) -> Expenditure {
        return getExpendicures()[index]
    }
    
    func getExpendicures() -> [Expenditure] {
//        if let dataList = self.dataList {
//            return dataList
//        } else {
//            self.dataList = viewModel.getDataList().sorted(by: { (a, b) in
//                return a.dateTime! > b.dateTime!
//            })
//            return self.dataList!
//        }
        var rawList = viewModel.getDataList()
        if let filter = self.dateFilter {
            rawList = rawList.filter({ (item) in
                if let date = item.dateTime {
                    return date.getComponent(with: "yyyy-MM-dd").contains(filter)
                } else {
                    return false
                }
            })
        }
        rawList = rawList.sorted(by: { (a, b) in
            return a.dateTime! > b.dateTime!
        })
        return rawList
    }
    
    func setDateFilter(with filter: String) {
        self.dateFilter = filter
    }
    
    // add data for testing
    private func addTestData() {
        if viewModel.getDataList().count == 0 {
            self.addRecord(title: "Test1", amount: 1.0, dateTime: Date.getDate(at: "2021/07/20 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test2", amount: 5.3, dateTime: Date.getDate(at: "2021/07/20 13:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/07/21 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test4", amount: 2.6, dateTime: Date.getDate(at: "2021/07/23 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test5", amount: 15.1, dateTime: Date.getDate(at: "2021/07/23 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test6", amount: 13.2, dateTime: Date.getDate(at: "2021/07/25 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test6", amount: 13.2, dateTime: Date.getDate(at: "2021/07/25 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test6", amount: 13.2, dateTime: Date.getDate(at: "2021/07/25 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test6", amount: 13.2, dateTime: Date.getDate(at: "2021/07/25 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test7", amount: 4.2, dateTime: Date.getDate(at: "2021/07/28 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/07/28 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/07/28 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/08/02 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/08/05 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 6.2, dateTime: Date.getDate(at: "2021/08/06 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 34.5, dateTime: Date.getDate(at: "2021/08/07 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 41.2, dateTime: Date.getDate(at: "2021/08/08 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/08/10 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2021/08/12 10:10"), frequency: Frequency(mode: .Daily))
            self.addRecord(title: "Test3", amount: 4.2, dateTime: Date.getDate(at: "2022/08/05 10:10"), frequency: Frequency(mode: .Daily))
        }
    }
}

extension DataListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getExpendicures().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataListTableViewCell.identifier, for: indexPath) as! DataListTableViewCell
        
        let expenditure = getExpenditure(at: indexPath.row)
        let title = expenditure.title ?? ""
        let amount = String(expenditure.amount)
        let color = Frequency(mode: Frequency.Mode(rawValue: Int(expenditure.frequencyMode))!).color
        
        cell.configureCell(title: title, amount: amount, color: color)
        return cell
    }
}

extension DataListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            viewModel.removeItem(index: indexPath.row)
            viewModel.removeItem(expenditure: getExpenditure(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentUpdateRecordViewController(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DataListViewController: ObservableObjectListener {
    func notify<V>(newValue: V) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.dataList = nil
//            self.getExpendicures()
            self.tableView.reloadData()
        }
    }
}

extension DataListViewController: RecordDetailDelegate {
    func addRecord(title: String, amount: Double, dateTime: Date, frequency: Frequency) {
        viewModel.addItem(title: title, amount: amount, dateTime: dateTime, frequency: frequency)
    }
    func updateRecord(model: Expenditure, title: String, amount: Double, dateTime: Date, frequency: Frequency) {
        viewModel.updateItem(expenditure: model, title: title, amount: amount, dateTime: dateTime, frequency: frequency)
    }
    func getDate() -> Date {
        if let filter = self.dateFilter {
            return Date.getDate(at: "\(filter) 12:00", format: "yyyy-MM-dd HH:mm")
        } else {
            return Date()
        }
    }
}
