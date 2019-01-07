//
//  Atomic.swift
//  Zedit
//
//  Created by Keith Irwin on 1/6/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation

class Atomic<T> {

    var value: T

    let queue = DispatchQueue(label: "atom." + UUID().uuidString)

    init(_ value: T) {
        self.value = value
    }

    func swap(_ f: (T) -> (T)) {
        return queue.sync {
            let oldValue = self.value
            self.value = f(oldValue)
        }
    }

    func reset(_ value: T) {
        return queue.sync {
            self.value = value
        }
    }

    func deref() -> T {
        return queue.sync { let copy = self.value ; return copy }
    }

}
