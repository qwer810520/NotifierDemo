//
//  NotifierCenterTests.swift
//  NotifierDemoTests
//
//  Created by Min on 2021/8/4.
//

import XCTest
@testable import NotifierDemo

class NotifierCenterTests: XCTestCase {

  func test_init_doesNotObserverInNotifier() {
    let (_, spy) = makeSUT()

    XCTAssertEqual(spy.dicCount(), 0)
  }

  func test_addObserver_deliversObserverNameSaveOnNotifierThenCheckResultCountIs1() {
    let (sut, spy) = makeSUT()
    let key = Notifier.Name.testSampleKey
    sut.addObserver(with: key) { _ in }

    let result = spy.observers[key]

    XCTAssertNotNil(result)
    XCTAssertEqual(result?.count, 1)
  }

  func test_addObserver_addObserverTwice() {
    let (sut, spy) = makeSUT()
    sut.addObserver(with: .testSampleKey) { _ in }
    sut.addObserver(with: .testSampleKey2) { _ in }

    let result = spy.dicCount()

    XCTAssertEqual(result, 2)
  }

  func test_postObserver_postNilDataToSubscribeThanCheckResultIsNil() {
    let (sut, _) = makeSUT()
    var observerIsCallBackResult = false
    var observerResult: Notifier.UserInfo = nil
    sut.addObserver(with: .testSampleKey) { observer in
      observerResult = observer
      observerIsCallBackResult = true
    }

    sut.post(name: .testSampleKey, userInfo: nil)

    XCTAssertTrue(observerIsCallBackResult)
    XCTAssertNil(observerResult)
  }

  func test_postObserver_postDataToSubscribeThanCheckResultNotNil() {
    let (sut, _) = makeSUT()
    var observerIsCallBackResult = false
    var observerResult: NotifierProtocol.UserInfo = nil
    sut.addObserver(with: .testSampleKey) { observer in
      observerResult = observer
      observerIsCallBackResult = true
    }

    sut.post(name: .testSampleKey, userInfo: anyUserInfo())

    XCTAssertTrue(observerIsCallBackResult)
    XCTAssertNotNil(observerResult)
    expect(targetDic: observerResult, baseDic: anyUserInfo())
  }

  func test_twoSubscribeCase_setupObserverThenCheckTwoResultIsEqual() {
    let (sut, _) = makeSUT()
    var observerResult1: NotifierProtocol.UserInfo = nil
    var observerResult2: NotifierProtocol.UserInfo = nil

    sut.addObserver(with: .testSampleKey) { observer in
      observerResult1 = observer
    }
    sut.addObserver(with: .testSampleKey) { observer in
      observerResult2 = observer
    }

    sut.post(name: .testSampleKey, userInfo: anyUserInfo())

    XCTAssertNotNil(observerResult1)
    XCTAssertNotNil(observerResult2)
    expect(targetDic: observerResult1, baseDic: anyUserInfo())
    expect(targetDic: observerResult2, baseDic: anyUserInfo())
  }

  func test_removeObserver_deliversObserverThanRemoveCheckObserversIsEmpty() {
    let (sut, spy) = makeSUT()
    let key = Notifier.Name.testSampleKey

    sut.addObserver(with: key) { _ in }
    sut.removeObserver(with: key)

    let result = spy.observers[key]

    XCTAssertNil(result)
  }

  // MARK: - Helper

  func makeSUT() -> (sut: NotifierCenter, spy: NotifierSpy) {
    let notifierSpy = NotifierSpy()
    let center = NotifierCenter(nofifierObject: notifierSpy)
    return (center, notifierSpy)
  }

  func expect(targetDic: NotifierProtocol.UserInfo, baseDic: NotifierProtocol.UserInfo, file: StaticString = #filePath, line: UInt = #line) {
    let targetValue = targetDic?["number"] as? Int
    let baseValue = baseDic?["number"] as? Int

    XCTAssertEqual(targetValue, baseValue, file: file, line: line)
  }

  func anyUserInfo() -> [String: Any] {
    return [
      "number": 123
    ]
  }

  class NotifierSpy: NotifierProtocol {

    private(set) var observers: ObserversParameter

    init() { self.observers = [:] }

    func add(with key: Notifier.Name, withValue value: @escaping (UserInfo) -> Void) {
      if observers[key] != nil {
        observers[key]?.append(value)
      } else {
        observers[key] = [value]
      }
    }

    func findValue(with key: Notifier.Name) -> [ObserverBlock]? {
      return observers[key]
    }

    func remove(from key: Notifier.Name) {
      observers.removeValue(forKey: key)
    }

    func dicCount() -> Int {
      return observers.count
    }
  }
}

private extension Notifier.Name {
  static let testSampleKey = Notifier.Name(rawValue: "testSampleKey")
  static let testSampleKey2 = Notifier.Name(rawValue: "testSampleKey2")
}
