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

    sut.add(with: key, object: self) { _ in }

    let result = sut.threadSafeObservers[key]
    expect(result?.values.map({ $0 }))
  }

  func test_addTwice_deliversObserverSaveOneKeyToNotifierTwice() {
    let sut = makeSUT()
    let key = makeKey(with: 0)

    sut.add(with: key, object: self) { _ in }
    sut.add(with: key, object: self) { _ in }

    let result = sut.threadSafeObservers[key]
    expect(result?.values.map({ $0 }), dataCount: 1)
  }

  func test_add_deliversObserverSaveWithDifferentKeyToNotifier() {
    let sut = makeSUT()
    let key1 = makeKey(with: 1)
    let key2 = makeKey(with: 2)

    sut.add(with: key1, object: self) { _ in }
    sut.add(with: key2, object: self) { _ in }

    let result1 = sut.threadSafeObservers[key1]
    let result2 = sut.threadSafeObservers[key2]
    expect(result1?.values.map({ $0 }))
    expect(result2?.values.map({ $0 }))
  }

  func test_find_doesNotFindObserverFromNotifier() {
    let sut = makeSUT()

    let result = sut.findValue(with: makeKey(with: 0))

    XCTAssertNil(result)
  }

  func test_find_findObserverFromNotifier() {
    let sut = makeSUT()
    let key = makeKey(with: 0)

    sut.add(with: key, object: self) { _ in }
    let result = sut.findValue(with: makeKey(with: 0))

    XCTAssertNotNil(result)
  }

  func test_remove_removeObserverFromNotifier() {
    let sut = makeSUT()
    let key = makeKey(with: 0)

    sut.add(with: key, object: self) { _ in }
    sut.remove(from: key, object: self)

    let result = sut.threadSafeObservers[key]
    XCTAssertNil(result)
    XCTAssertTrue(sut.threadSafeObservers.isEmpty)
  }

  func test_remove_deliversTwoValueThanRemoveOneAndcheckValueHasOneValue() {
    let sut = makeSUT()
    let key = makeKey(with: 1)

    sut.add(with: key, object: self) { _ in }
    sut.add(with: key, object: TestController()) { _ in }
    sut.remove(from: key, object: self)

    let results = sut.threadSafeObservers[key]

    XCTAssertNotNil(results)
    XCTAssertEqual(results?.count, 1)
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

  class TestController: NSObject { }

}
