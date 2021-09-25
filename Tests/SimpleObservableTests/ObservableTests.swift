//
//  File.swift
//  
//
//  Created by Igor Kulman on 25.09.2021.
//

import Foundation
import XCTest
@testable import SimpleObservable

final class ObservableTests: XCTestCase {
    func testInitialValueBeingPropagated() {
        let observable = Observable<Int>(0)
        var value: Int?

        let expectation = expectation(description: "")
        observable.bind { v in
            value = v
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(value, 0)
        XCTAssertEqual(observable.value, 0)
    }

    func testAdditionalValueBeingPropagated() {
        let observable = Observable<Int>(0)
        var value: Int?

        let expectation = expectation(description: "")
        observable.bind { v in
            value = v

            if v == 1 {
                expectation.fulfill()
            }
        }

        observable.value = 1

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(value, 1)
        XCTAssertEqual(observable.value, 1)
    }
}
