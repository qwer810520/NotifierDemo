//
//  Notifier.swift
//  NotifierDemo
//
//  Created by Min on 2021/8/5.
//

import Foundation

final class Notifier: NotifierProtocol {

  private(set) var observers: ObserversParameter

  init() {
    self.observers = [:]
  }

  func add(with key: Name, withValue value: @escaping (UserInfo) -> Void) {
    if observers[key] != nil {
      observers[key]?.append(value)
    } else {
      observers[key] = [value]
    }
  }

  func findValue(with key: Name) -> [ObserverBlock]? {
    return observers[key]
  }

  func remove(from key: Name) {
    observers.removeValue(forKey: key)
  }
}

extension Notifier {
  struct Name: Hashable {
    let rawValue: String
  }
}
