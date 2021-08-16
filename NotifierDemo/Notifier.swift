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

  func add(with key: Name, object: Any, withValue value: @escaping ObserverBlock) {
    let objectName = "\(type(of: object))"
    if var values = threadSafeObservers[key], values[objectName] == nil {
      values[objectName] = value
      threadSafeObservers[key] = values
    } else {
      threadSafeObservers[key] = [objectName: value]
    }
  }

  func findValue(with key: Name) -> [ObserverBlock]? {
    guard let observers = threadSafeObservers[key]?.values else { return nil }
    return observers.map { $0 }
  }

  func remove(from key: Name, object: Any) {
    let objectName = "\(type(of: object))"
    guard var values = threadSafeObservers[key] else { return }
    values.removeValue(forKey: objectName)
    switch values.isEmpty {
      case true:
        threadSafeObservers.removeValue(forKey: key)
      case false:
        threadSafeObservers[key] = values
    }
  }
}

extension Notifier {
  struct Name: Hashable {
    let rawValue: String
  }
}
