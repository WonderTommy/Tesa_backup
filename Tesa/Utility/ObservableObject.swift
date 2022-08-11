//
//  ObservableObject.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-16.
//

import Foundation

protocol ObservableObjectListener {
    func notify<V>(newValue: V)
}

final class ObservableObject<T> {
    private var value: T {
        didSet {
            notifyListeners()
        }
    }
    
    private var listeners: [ObservableObjectListener]
    
    init(value: T, listeners: [ObservableObjectListener]) {
        self.value = value
        self.listeners = listeners
    }
    
    convenience init(value: T) {
        self.init(value: value, listeners: [])
    }
    
    public func setValue(newValue: T) {
        self.value = newValue
    }
    
    public func getValue() -> T {
        return self.value
    }
    
    public func addListener(_ listener: ObservableObjectListener) {
        self.listeners.append(listener)
    }
    
    private func notifyListeners() {
        for listener in listeners {
            listener.notify(newValue: value)
        }
    }
}
