//
//  NotifierTests.swift
//  NotifierDemoTests
//
//  Created by Min on 2021/8/5.
//

import XCTest
@testable import NotifierDemo

class NotifierTests: XCTestCase {

  func test_add_deliversObserverSaveToNotifier() {
    let sut = makeSUT()
    let key = makeKey(with: 1)

    sut.add(with: key) { _ in }

    let result = sut.observers[key]
    expect(result)
  }

  func test_addTwice_deliversObserverSaveOneKeyToNotifierTwice() {
    let sut = makeSUT()
    let key = makeKey(with: 0)

    sut.add(with: key) { _ in }
    sut.add(with: key) { _ in }

    let result = sut.observers[key]
    expect(result, dataCount: 2)
  }

  func test_add_deliversObserverSaveWithDifferentKeyToNotifier() {
    let sut = makeSUT()
    let key1 = makeKey(with: 1)
    let key2 = makeKey(with: 2)

    sut.add(with: key1) { _ in }
    sut.add(with: key2) { _ in }

    let result1 = sut.observers[key1]
    let result2 = sut.observers[key2]
    expect(result1)
    expect(result2)
  }

  func test_find_doesNotFindObserverFromNotifier() {
    let sut = makeSUT()

    let result = sut.findValue(with: makeKey(with: 0))

    XCTAssertNil(result)
  }

  func test_find_findObserverFromNotifier() {
    let sut = makeSUT()
    let key = makeKey(with: 0)

    sut.add(with: key) { _ in }
    let result = sut.findValue(with: makeKey(with: 0))

    XCTAssertNotNil(result)
  }

  func test_remove_removeObserverFromNotifier() {
    let sut = makeSUT()
    let key = makeKey(with: 0)

    sut.add(with: key) { _ in }
    sut.remove(from: key)

    let result = sut.observers[key]
    XCTAssertNil(result)
    XCTAssertTrue(sut.observers.isEmpty)
  }

  // MARK; - Helper

  func makeSUT() -> Notifier {
    return Notifier()
  }

  func makeKey(with id: Int) -> Notifier.Name {
    return Notifier.Name(rawValue: "test\(id)")
  }

  func expect(_ result: [Notifier.ObserverBlock]?, dataCount: Int = 1, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertNotNil(result, file: file, line: line)
    XCTAssertEqual(result?.count, dataCount, file: file, line: line)
  }

}
