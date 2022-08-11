//
//  DataListViewModel.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-16.
//

import Foundation
import CoreData

class DataListViewModel {
    let dataList: ObservableObject<[Expenditure]?> = ObservableObject(value: nil)
    
    let defaultFrequency: ObservableObject<Frequency> = ObservableObject(value: UserDefaults.getDefaultFrequency())
    let emptyBarSetting: ObservableObject<Bool> = ObservableObject(value: UserDefaults.getExcludeEmptyBar())
    
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        fetchData()
    }
    
    private func fetchData() {
        do {
            let items = try managedObjectContext?.fetch(Expenditure.fetchRequest())
            dataList.setValue(newValue: items ?? [])
        } catch {
            dataList.setValue(newValue: [])
        }
    }
    
    public func addItem(title: String, amount: Double, dateTime: Date, frequency: Frequency) {
        if let context = managedObjectContext {
            let expenditure = Expenditure(context: context)
            expenditure.title = title
            expenditure.amount = amount
            expenditure.dateTime = dateTime
            expenditure.frequencyMode = Int16(frequency.mode.rawValue)
            do {
                try context.save()
                self.fetchData()
            } catch {
                // error case
            }
        }
    }
    
    public func removeItem(index: Int) {
        let expenditure = getDataList()[index]
        self.removeItem(expenditure: expenditure)
    }
    
    public func removeItem(expenditure: Expenditure) {
        if let context = managedObjectContext {
            context.delete(expenditure)
            do {
                try context.save()
                self.fetchData()
            } catch {
                // error case
            }
        }
    }
    
    public func updateItem(index: Int, title: String, amount: Double, frequency: Frequency) {
        if let context = managedObjectContext {
            let expediture = getDataList()[index]
            expediture.title = title
            expediture.amount = amount
            expediture.frequencyMode = Int16(frequency.mode.rawValue)
            do {
                try context.save()
                self.fetchData()
            } catch {
                //error case
            }
        }
    }
    
    public func updateItem(expenditure: Expenditure, title: String, amount: Double, dateTime: Date, frequency: Frequency) {
        if let context = managedObjectContext {
            expenditure.title = title
            expenditure.amount = amount
            expenditure.dateTime = dateTime
            expenditure.frequencyMode = Int16(frequency.mode.rawValue)
            do {
                try context.save()
                self.fetchData()
            } catch {
                // error case
            }
        }
    }
    
    public func addDataListListener(listener: ObservableObjectListener) {
        dataList.addListener(listener)
    }
    
    public func getDataList() -> [Expenditure] {
        return dataList.getValue() ?? []
    }
    
    public func addDefaultFrequencyObserver(listener: ObservableObjectListener) {
        defaultFrequency.addListener(listener)
    }
    public func addEmptyBarSettingListener(listener: ObservableObjectListener) {
        emptyBarSetting.addListener(listener)
    }
}
