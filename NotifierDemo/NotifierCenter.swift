//
//  NotifierCenter.swift
//  NotifierDemo
//
//  Created by Min on 2021/8/4.
//

import Foundation

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
