//
//  BarChartView.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-29.
//

import Foundation
import Charts
import UIKit

protocol ExpenseChartViewDataSource {
    func getData() -> [(x: String, y: Double, data: [Expenditure])]
}

class ExpenseChartView: BarChartView {
    enum GroupComponentFormat: String {
        case Day = "yyyy-MM-dd"
        case Month = "yyyy-MM"
        case Year = "yyyy"
    }
    
//    let viewDelegate: ChartViewDelegate
    let dataSource: ExpenseChartViewDataSource
    
    var dataList = [[Expenditure]]()
    
    var formatedData = [(x: String, y:Double, data:[Expenditure])]()
    
    init(viewDelegate: ChartViewDelegate, dataSource: ExpenseChartViewDataSource) {
        self.dataSource = dataSource
        super.init(frame: CGRect.zero)
        self.delegate = viewDelegate
        self.configLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configLayout() {
//        let rawData = dataSource.getData()
//        let dataBook: [String: [Expenditure]] = Dictionary(grouping: rawData, by: { item in
//            if let dateTime = item.dateTime {
//                return dateTime.getComponent(with: GroupComponentFormat.Day.rawValue)
//            } else {
//                return "Unknown"
//            }
//        })
//
//        for (key, value) in dataBook {
//            let element = (x: key, y: value.reduce(0, { (accu, next) in
//                return accu + next.amount
//            }), data: value)
//            formatedData.append(element)
//        }
//
//        formatedData = formatedData.sorted(by: { (a, b) in
//            return a.x < b.x
//        })
        
        
        self.formatedData = dataSource.getData()
        
        var entries = [BarChartDataEntry]()
        self.dataList = [[Expenditure]]()
        for x in 0..<formatedData.count {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(formatedData[x].y)))
            dataList.append(formatedData[x].data)
        }
        let set = BarChartDataSet(entries:entries, label: "Cost")
        set.colors = [.systemRed]
        let data = BarChartData(dataSet: set)
        self.data = data
        self.setVisibleXRangeMaximum(12)
        self.moveViewToX(Double(entries.count))
        self.xAxis.labelPosition = .bottom
        self.xAxis.valueFormatter = self
        self.xAxis.labelCount = formatedData.count
        self.xAxis.spaceMin = 0.5
        self.xAxis.spaceMax = 0.5
        self.xAxis.granularityEnabled = true
        self.xAxis.granularity = formatedData.count < 3 ? 1 : 3
    }
    
    func getBarData(at index: Int) -> (x: String, y: Double, data: [Expenditure]) {
        return formatedData[index]
    }
}

extension ExpenseChartView: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index < formatedData.count {
            return formatedData[index].x
        } else {
            return ""
        }
    }
}
