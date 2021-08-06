//
//  Notifier.swift
//  NotifierDemo
//
//  Created by Min on 2021/8/5.
//

import Foundation

final class Notifier: NotifierProtocol {

  private var observers: ObserversParameter
  private var notifierQueue = DispatchQueue(label: "com.notifier.notifierDamo", attributes: .concurrent)
  
  private(set) var threadSafeObservers: ObserversParameter {
    get {
      notifierQueue.sync {
        return observers
      }
    }
    set {
      notifierQueue.async(flags: .barrier) { [weak self] in
        self?.observers = newValue
      }
    }
  }

  init() {
    self.observers = [:]
  }

  func add(with key: Name, withValue value: @escaping (UserInfo) -> Void) {
    if threadSafeObservers[key] != nil {
      threadSafeObservers[key]?.append(value)
    } else {
      threadSafeObservers[key] = [value]
    }
  }

  func findValue(with key: Name) -> [ObserverBlock]? {
      return threadSafeObservers[key]
  }

  func remove(from key: Name) {
    threadSafeObservers.removeValue(forKey: key)
  }
}

extension Notifier {
  struct Name: Hashable {
    let rawValue: String
  }
}
