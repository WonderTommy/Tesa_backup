//
//  ViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-16.
//

import UIKit

class ViewController: UINavigationController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var itemCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.backgroundColor = .red
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(self.itemCountLabel)
        itemCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            itemCountLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            
        ])
//        addRow()
        getAllRows()
    }

    func getAllRows() {
        do {
            let rows = try context.fetch(Expenditure.fetchRequest())
            itemCountLabel.text = String(rows.count)
            print(rows[0])
//            print(rows[1])
            print(rows.count)
        } catch {
            // error case
        }
    }
    
    func addRow() {
        let expenditure = Expenditure(context: context)
        expenditure.title = "grocery"
        expenditure.amount = 12.0
        
        do {
            try context.save()
        } catch {
            // error case
        }
    }
    
}

