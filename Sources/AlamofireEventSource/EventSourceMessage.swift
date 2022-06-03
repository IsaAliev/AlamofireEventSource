//
//  EventSourceMessage.swift
//  AlamofireEventSource
//
//  Created by Daniel Clelland on 7/08/20.
//

import Foundation

public struct EventSourceMessage {
    
    public var event: String?
    public var id: String?
    public var data: String?
    public var retry: String?
    
}

extension EventSourceMessage {
    
    internal init?(parsing string: String) {
        let fields = string.components(separatedBy: "\n").compactMap(Field.init(parsing:))
        for field in fields {
            switch field.key {
            case .event:
                self.event = self.event.map { $0 + "\n" + field.value } ?? field.value
            case .id:
                self.id = self.id.map { $0 + "\n" + field.value } ?? field.value
            case .data:
                self.data = self.data.map { $0 + "\n" + field.value } ?? field.value
            case .retry:
                self.retry = self.retry.map { $0 + "\n" + field.value } ?? field.value
            }
        }
    }
    
}

extension EventSourceMessage {
    
    internal struct Field {
        
        internal enum Key: String {
            
            case event
            case id
            case data
            case retry
            
        }
        
        internal var key: Key
        internal var value: String
        
        internal init?(parsing string: String) {
            let components = string.split(separator: ":").map(String.init)
            
            guard components.count > 1,
                  let keyStr = components.first,
                  let key = Key(rawValue: keyStr),
                  let value = components[1...].joined(separator: ":").split(separator: "\n").first
            else { return nil }
            
            self.key = key
            self.value = String(value)
        }
        
    }
    
}
