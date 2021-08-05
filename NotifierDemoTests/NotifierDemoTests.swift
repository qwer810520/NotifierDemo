//
//  NotifierDemoTests.swift
//  NotifierDemoTests
//
//  Created by Min on 2021/8/4.
//

import XCTest
@testable import NotifierDemo

class NotifierDemoTests: XCTestCase {

  func test_addObserver_deliversObserverNameSaveOnObservers() {
    let sut = makeSUT()
    let key = NotifierCenter.NotifierName.testSampleKey
    var isHaveResponse = false
    sut.addObserver(with: key) { _ in
      isHaveResponse = true
    }

    sut.post(name: key)

    XCTAssertTrue(isHaveResponse)
  }

  func test_postObserver_postNilDataToSubscribeThanCheckResultIsNil() {
    let sut = makeSUT()
    var observerIsCallBackResult = false
    var observerResult: NotifierCenter.UserInfo = nil
    sut.addObserver(with: .testSampleKey) { observer in
      observerResult = observer
      observerIsCallBackResult = true
    }

    sut.post(name: .testSampleKey, userInfo: nil)

    XCTAssertTrue(observerIsCallBackResult)
    XCTAssertNil(observerResult)
  }

  func test_postObserver_postDataToSubscribeThanCheckResultNotNil() {
    let sut = makeSUT()
    var observerIsCallBackResult = false
    var observerResult: NotifierCenter.UserInfo = nil
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
    let sut = makeSUT()
    var observerResult1: NotifierCenter.UserInfo = nil
    var observerResult2: NotifierCenter.UserInfo = nil

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
    let sut = makeSUT()
    var isHaveObserverResponse = false
    sut.addObserver(with: .testSampleKey) { _ in
      isHaveObserverResponse = true
    }
    sut.removeObserver(with: .testSampleKey)

    sut.post(name: .testSampleKey)

    XCTAssertFalse(isHaveObserverResponse)
  }

  // MARK: - Helper

  func makeSUT() -> NotifierCenter {
    return NotifierCenter()
  }

  func expect(targetDic: NotifierCenter.UserInfo, baseDic: NotifierCenter.UserInfo, file: StaticString = #filePath, line: UInt = #line) {
    let targetValue = targetDic?["number"] as? Int
    let baseValue = baseDic?["number"] as? Int

    XCTAssertEqual(targetValue, baseValue, file: file, line: line)
  }

  func anyUserInfo() -> [String: Any] {
    return [
      "number": 123
    ]
  }
}

private extension NotifierCenter.NotifierName {
  static let testSampleKey = NotifierCenter.NotifierName(rawValue: "testSampleKey")
}
