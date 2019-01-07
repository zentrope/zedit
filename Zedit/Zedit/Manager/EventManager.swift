//
//  EventManager.swift
//  Zedit
//
//  Created by Keith Irwin on 1/6/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation

enum EventType {
    case AddFiles([URL])
}

protocol EventReceiver: class {
    func receive(event: EventType)
}

struct EventManager {

    static var receivers = Atomic([EventReceiver]())

    static func register(receiver: EventReceiver) {
        receivers.swap { rs in
            if !rs.contains { $0 === receiver } {
                return rs + [receiver]
            }
            return rs
        }
    }

    static func unregister(receiver: EventReceiver) {
        receivers.swap { rs in
            return Array(rs.drop { $0 === receiver })
        }
    }

    static func pub(_ event: EventType) {
        receivers.deref().forEach { receiver in
            DispatchQueue.main.async {
                receiver.receive(event: event)
            }
        }
    }
}
