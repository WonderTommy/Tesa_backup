//
//  GroupByView.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-30.
//

import Foundation
import UIKit

class GroupByView: UISegmentedControl {
    private let selectedTag: ObservableObject<Tabs?> = ObservableObject(value: nil)
    
    enum Tabs: String, CaseIterable {
        case Day = "Day"
        case Month = "Month"
        case Year = "Year"
    }
    
    var items = [String]()
    
    init() {
        for tab in Tabs.allCases {
            self.items.append(tab.rawValue)
        }
        super.init(items: self.items)
        self.selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabChanged(_ segmentedControl: UISegmentedControl) {
        
    }
    
    override func didChangeValue(forKey key: String) {
        if key == "selectedSegmentIndex" {
            selectedTag.setValue(newValue: Tabs.allCases[selectedSegmentIndex])
        }
    }
    
    func addListener(_ listener: ObservableObjectListener) {
        selectedTag.addListener(listener)
    }
    
    func getGroup() -> Tabs? {
        return selectedTag.getValue()
    }
}
