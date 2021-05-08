//
//  Task.swift
//  ToDoListRxSwift
//
//  Created by Ivan Ivanov on 5/8/21.
//

import Foundation

enum Priority: Int {
    case high
    case meduium
    case low
}

struct Task {
    let titile: String
    let priority: Priority
}
