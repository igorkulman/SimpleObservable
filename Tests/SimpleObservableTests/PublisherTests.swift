//
//  File.swift
//  
//
//  Created by Igor Kulman on 25.09.2021.
//

import Foundation

import Foundation
import XCTest
@testable import SimpleObservable

final class PublisherTests: XCTestCase {
    func testNoInitialValueBeingPropagated() {
        let observable = Publisher<Int>()
        var value: Int?

        observable.bind { v in
            value = v
            XCTFail()
        }

        XCTAssertEqual(value, nil)
    }

    func testValueBeingPropagated() {
        let observable = Publisher<Int>()
        var value: Int?

        let expectation = expectation(description: "")
        observable.bind { v in
            value = v

            expectation.fulfill()
        }

        observable.publish(1)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(value, 1)
    }
}
