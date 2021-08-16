//
//  NotifierProtocol.swift
//  NotifierDemo
//
//  Created by Min on 2021/8/5.
//

import Foundation

protocol NotifierProtocol {
  typealias UserInfo = [AnyHashable: Any]?
  typealias ObserverBlock = (UserInfo) -> Void
  typealias ObserversParameter = [Notifier.Name: [String: ObserverBlock]]

  func add(with key: Notifier.Name, object: Any, withValue value: @escaping ObserverBlock)
  func findValue(with key: Notifier.Name) -> [ObserverBlock]?
  func remove(from key: Notifier.Name,  object: Any)
}
