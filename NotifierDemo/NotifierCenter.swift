//
//  NotifierCenter.swift
//  NotifierDemo
//
//  Created by Min on 2021/8/4.
//

import Foundation

class NotifierCenter {
  typealias UserInfo = [AnyHashable: Any]?
  typealias ObserverBlock = (UserInfo) -> Void

  struct NotifierName: Hashable {
    let rawValue: String
  }

  static let `default` = NotifierCenter()

  private var observers = [NotifierName: [ObserverBlock]]()

  init() { }

  func addObserver(with key: NotifierCenter.NotifierName, andNotify notify: @escaping ObserverBlock) {
    if observers[key] != nil {
      observers[key]?.append(notify)
    } else {
      observers[key] = [notify]
    }
  }

  func post(name aName: NotifierCenter.NotifierName, userInfo aUserInfo: UserInfo = nil) {
    guard let observer = observers[aName] else { return }
    observer.forEach { $0(aUserInfo) }
  }

  func removeObserver(with key: NotifierCenter.NotifierName) {
    observers.removeValue(forKey: key)
  }
}
