//
//  AnalysisViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-25.
//

import Foundation
import UIKit
import Charts

class AnalysisViewController: UIViewController {
    var viewModel: DataListViewModel?
    
    lazy var groupsTab: GroupByView = {
        return GroupByView()
    }()
    
    var barChart: ExpenseChartView?
    
    init(viewModel: DataListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        viewModel.addDataListListener(listener: self)
        viewModel.addEmptyBarSettingListener(listener: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        configNavBar()
        configSubview()
    }
    
    func configNavBar() {
        title = "Analysis"
        view.backgroundColor = .white
    }
    
    func configSubview() {
        view.backgroundColor = .systemGray5
        view.addSubview(groupsTab)
        groupsTab.addListener(self)
        groupsTab.translatesAutoresizingMaskIntoConstraints = false
        groupsTab.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        groupsTab.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let barChartCard = createCardView()
//        barChartCard.layer.shadowColor = UIColor.black.cgColor
//        barChartCard.layer.shadowOpacity = 0.4
//        barChartCard.layer.shadowOffset = CGSize(width: -10, height: -10)
//        barChartCard.layer.shadowRadius = 10
//        barChartCard.layer.shadowPath = CGPath(
        
        
        view.addSubview(barChartCard)
        barChartCard.translatesAutoresizingMaskIntoConstraints = false
        barChartCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barChartCard.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        barChartCard.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        barChartCard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -40).isActive = true
        barChartCard.neumorphism(shadowRadius: 12, shadowOffset: 14, cornerRadius: 16)
        
        self.barChart = ExpenseChartView(viewDelegate: self, dataSource: self)
        if let barChart = self.barChart {
            barChartCard.addSubview(barChart)
            barChart.translatesAutoresizingMaskIntoConstraints = false
            barChart.centerXAnchor.constraint(equalTo: barChartCard.centerXAnchor).isActive = true
            barChart.centerYAnchor.constraint(equalTo: barChartCard.centerYAnchor).isActive = true
            barChart.widthAnchor.constraint(equalTo: barChartCard.widthAnchor, constant: -16).isActive = true
            barChart.heightAnchor.constraint(equalTo: barChartCard.heightAnchor, constant: -16).isActive = true
        }
    }
    
    func createCardView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 12
        return view
    }
}

extension AnalysisViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let viewModel = self.viewModel {
            let barData = barChart?.getBarData(at: Int(entry.x))
            let datalistViewController = DataListViewController(viewModel: viewModel, dateFilter: barData?.x ?? "")
            present(UINavigationController(rootViewController: datalistViewController), animated: true, completion: nil)
        }
    }
}

extension AnalysisViewController: ExpenseChartViewDataSource {
    func getData() -> [(x: String, y: Double, data: [Expenditure])] {
        if let viewModel = self.viewModel,
           let groupBy = groupsTab.getGroup() {
            let dataBook: [String: [Expenditure]] = Dictionary(grouping: viewModel.getDataList(), by: { item in
                if let dateTime = item.dateTime {
                    var xComponent: ExpenseChartView.GroupComponentFormat
                    switch groupBy {
                    case .Day:
                        xComponent = ExpenseChartView.GroupComponentFormat.Day
                    case .Month:
                        xComponent = ExpenseChartView.GroupComponentFormat.Month
                    case .Year:
                        xComponent = ExpenseChartView.GroupComponentFormat.Year
                    }
                    return dateTime.getComponent(with: xComponent.rawValue)
                } else {
                    return "Unknown"
                }
            })
            
            var formatedData = [(x: String, y: Double, data: [Expenditure])]()
            for (key, value) in dataBook {
                let element = (x: key, y: value.reduce(0, { (accu, next) in
                    return accu + next.amount
                }), data: value)
                formatedData.append(element)
            }
            
            formatedData = formatedData.sorted(by: { (a, b) in
                return a.x < b.x
            })
            
            // fill in empty bar
            if !UserDefaults.getExcludeEmptyBar() {
                if formatedData.count > 1 {
                    let begin = formatedData.first!.data.first!.dateTime ?? Date()
                    let end = formatedData.last!.data.first!.dateTime ?? Date()

                    var dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: begin)

                    var keyFormat: String = ""
                    switch groupBy {
                    case .Day:
                        keyFormat = ExpenseChartView.GroupComponentFormat.Day.rawValue
                    case .Month:
                        keyFormat = ExpenseChartView.GroupComponentFormat.Month.rawValue
                    case .Year:
                        keyFormat = ExpenseChartView.GroupComponentFormat.Year.rawValue
                    }

                    var keySet = Set<String>()

                    for item in formatedData {
                        keySet.insert(item.x)
                    }

                    while (true) {
                        let curDate = Calendar(identifier: .gregorian).date(from: dateComponent)!
                        let curKey = curDate.getComponent(with: keyFormat)
                        let endKey = end.getComponent(with: keyFormat)
                        if curKey == endKey {
                            break
                        }
                        switch groupBy {
                        case .Day:
                            dateComponent.setValue(dateComponent.day! + 1, for: .day)
                        case .Month:
                            dateComponent.setValue(dateComponent.month! + 1, for: .month)
                        case .Year:
                            dateComponent.setValue(dateComponent.year! + 1, for: .year)
                        }
                        if !keySet.contains(curKey) {
                            formatedData.append((x: curKey, y: 0, data:[]))
                        }
                    }

                    formatedData = formatedData.sorted(by: { (a, b) in
                        return a.x < b.x
                    })
                }
            }
            
            return formatedData
        } else {
            return []
        }
    }
}

extension AnalysisViewController: ObservableObjectListener {
    func notify<V>(newValue: V) {
        self.barChart?.configLayout()
    }
}
