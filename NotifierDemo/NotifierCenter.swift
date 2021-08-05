//
//  NotifierCenter.swift
//  NotifierDemo
//
//  Created by Min on 2021/8/4.
//

import Foundation

protocol NotifierProtocol {
  typealias UserInfo = [AnyHashable: Any]?
  typealias ObserverBlock = (UserInfo) -> Void
  typealias ObserversProperty = [Notifier.Name: [ObserverBlock]]

  func add(with key: Notifier.Name, withValue value: @escaping ObserverBlock)
  func findValue(with key: Notifier.Name) -> [ObserverBlock]?
  func remove(from key: Notifier.Name)
}


final class Notifier: NotifierProtocol {

  private var observers: ObserversProperty

  init() {
    self.observers = [:]
  }

  func add(with key: Name, withValue value: (UserInfo) -> Void) {

  }

  func findValue(with key: Name) -> [ObserverBlock]? {
    return observers[key]
  }

  func remove(from key: Name) {

  }
}

extension Notifier {
  struct Name: Hashable {
    let rawValue: String
  }
}


class NotifierCenter {

  static let `default` = NotifierCenter()

  private var notifier: NotifierProtocol = Notifier()

  private init() { }

  convenience init(nofifierObject: NotifierProtocol? = nil) {
    self.init()
    guard let object = nofifierObject else { return }
    self.notifier = object
  }

  func addObserver(with key: Notifier.Name, andNotify notify: @escaping NotifierProtocol.ObserverBlock) {
    notifier.add(with: key, withValue: notify)
  }

  func post(name aName: Notifier.Name, userInfo aUserInfo: NotifierProtocol.UserInfo = nil) {
    guard let blocks = notifier.findValue(with: aName), !blocks.isEmpty else { return }
    blocks.forEach { $0(aUserInfo) }
  }

  func removeObserver(with key: Notifier.Name) {
    notifier.remove(from: key)
  }
}
