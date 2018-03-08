//
//  RabbitTests.swift
//  CryptoSwift
//
//  Created by Dima Kalachov on 13/11/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
@testable import CryptoSwift

class RabbitTests: XCTestCase {

    func testInitialization() {
        var key = Array<UInt8>(repeating: 0, count: Rabbit.keySize - 1)
        var iv: Array<UInt8>?
        XCTAssertThrowsError(try Rabbit(key: key, iv: iv))

        key = Array<UInt8>(repeating: 0, count: Rabbit.keySize + 1)
        XCTAssertThrowsError(try Rabbit(key: key, iv: iv))
        
        key = Array<UInt8>(repeating: 0, count: Rabbit.keySize)
        XCTAssertNotNil(try Rabbit(key: key, iv: iv))
        
        iv = Array<UInt8>(repeating: 0, count: Rabbit.ivSize - 1)
        XCTAssertThrowsError(try Rabbit(key: key, iv: iv))
        
        iv = Array<UInt8>(repeating: 0, count: Rabbit.ivSize)
        XCTAssertNotNil(try Rabbit(key: key, iv: iv))
    }
    
    func testRabbitWithoutIV() {
        // Examples from Appendix A: Test Vectors in http://tools.ietf.org/rfc/rfc4503.txt
        let cases: [(Array<UInt8>, Array<UInt8>)] = [
            // First case
            (
                [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
                [
                    0xB1, 0x57, 0x54, 0xF0, 0x36, 0xA5, 0xD6, 0xEC, 0xF5, 0x6B, 0x45, 0x26, 0x1C, 0x4A, 0xF7, 0x02,
                    0x88, 0xE8, 0xD8, 0x15, 0xC5, 0x9C, 0x0C, 0x39, 0x7B, 0x69, 0x6C, 0x47, 0x89, 0xC6, 0x8A, 0xA7,
                    0xF4, 0x16, 0xA1, 0xC3, 0x70, 0x0C, 0xD4, 0x51, 0xDA, 0x68, 0xD1, 0x88, 0x16, 0x73, 0xD6, 0x96,
                ]
            ),
            // Second case
            (
                [0x91, 0x28, 0x13, 0x29, 0x2E, 0x3D, 0x36, 0xFE, 0x3B, 0xFC, 0x62, 0xF1, 0xDC, 0x51, 0xC3, 0xAC],
                [
                    0x3D, 0x2D, 0xF3, 0xC8, 0x3E, 0xF6, 0x27, 0xA1, 0xE9, 0x7F, 0xC3, 0x84, 0x87, 0xE2, 0x51, 0x9C,
                    0xF5, 0x76, 0xCD, 0x61, 0xF4, 0x40, 0x5B, 0x88, 0x96, 0xBF, 0x53, 0xAA, 0x85, 0x54, 0xFC, 0x19,
                    0xE5, 0x54, 0x74, 0x73, 0xFB, 0xDB, 0x43, 0x50, 0x8A, 0xE5, 0x3B, 0x20, 0x20, 0x4D, 0x4C, 0x5E,
                ]
            ),
            // Third case
            (
                [0x83, 0x95, 0x74, 0x15, 0x87, 0xE0, 0xC7, 0x33, 0xE9, 0xE9, 0xAB, 0x01, 0xC0, 0x9B, 0x00, 0x43,],
                [
                    0x0C, 0xB1, 0x0D, 0xCD, 0xA0, 0x41, 0xCD, 0xAC, 0x32, 0xEB, 0x5C, 0xFD, 0x02, 0xD0, 0x60, 0x9B,
                    0x95, 0xFC, 0x9F, 0xCA, 0x0F, 0x17, 0x01, 0x5A, 0x7B, 0x70, 0x92, 0x11, 0x4C, 0xFF, 0x3E, 0xAD,
                    0x96, 0x49, 0xE5, 0xDE, 0x8B, 0xFC, 0x7F, 0x3F, 0x92, 0x41, 0x47, 0xAD, 0x3A, 0x94, 0x74, 0x28,
                ]
            ),
        ]
        
        let plainText = Array<UInt8>(repeating: 0, count: 48)
        for (key, expectedCipher) in cases {
            let rabbit = try! Rabbit(key: key)
            let cipherText = rabbit.encrypt(plainText)
            XCTAssertEqual(cipherText, expectedCipher)
            XCTAssertEqual(rabbit.decrypt(cipherText), plainText)
        }
    }
    
    func testRabbitWithIV() {
        // Examples from Appendix A: Test Vectors in http://tools.ietf.org/rfc/rfc4503.txt
        let key = Array<UInt8>(repeating: 0, count: Rabbit.keySize)
        let cases: [(Array<UInt8>, Array<UInt8>)] = [
            (
                [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
                [
                    0xC6, 0xA7, 0x27, 0x5E, 0xF8, 0x54, 0x95, 0xD8, 0x7C, 0xCD, 0x5D, 0x37, 0x67, 0x05, 0xB7, 0xED,
                    0x5F, 0x29, 0xA6, 0xAC, 0x04, 0xF5, 0xEF, 0xD4, 0x7B, 0x8F, 0x29, 0x32, 0x70, 0xDC, 0x4A, 0x8D,
                    0x2A, 0xDE, 0x82, 0x2B, 0x29, 0xDE, 0x6C, 0x1E, 0xE5, 0x2B, 0xDB, 0x8A, 0x47, 0xBF, 0x8F, 0x66,
                ]
            ),
            (
                [0xC3, 0x73, 0xF5, 0x75, 0xC1, 0x26, 0x7E, 0x59],
                [
                    0x1F, 0xCD, 0x4E, 0xB9, 0x58, 0x00, 0x12, 0xE2, 0xE0, 0xDC, 0xCC, 0x92, 0x22, 0x01, 0x7D, 0x6D,
                    0xA7, 0x5F, 0x4E, 0x10, 0xD1, 0x21, 0x25, 0x01, 0x7B, 0x24, 0x99, 0xFF, 0xED, 0x93, 0x6F, 0x2E,
                    0xEB, 0xC1, 0x12, 0xC3, 0x93, 0xE7, 0x38, 0x39, 0x23, 0x56, 0xBD, 0xD0, 0x12, 0x02, 0x9B, 0xA7,
                ]
            ),
            (
                [0xA6, 0xEB, 0x56, 0x1A, 0xD2, 0xF4, 0x17, 0x27],
                [
                    0x44, 0x5A, 0xD8, 0xC8, 0x05, 0x85, 0x8D, 0xBF, 0x70, 0xB6, 0xAF, 0x23, 0xA1, 0x51, 0x10, 0x4D,
                    0x96, 0xC8, 0xF2, 0x79, 0x47, 0xF4, 0x2C, 0x5B, 0xAE, 0xAE, 0x67, 0xC6, 0xAC, 0xC3, 0x5B, 0x03,
                    0x9F, 0xCB, 0xFC, 0x89, 0x5F, 0xA7, 0x1C, 0x17, 0x31, 0x3D, 0xF0, 0x34, 0xF0, 0x15, 0x51, 0xCB,
                ]
            ),
        ]
        
        let plainText = Array<UInt8>(repeating: 0, count: 48)
        for (iv, expectedCipher) in cases {
            let rabbit = try! Rabbit(key: key, iv: iv)
            let cipherText = rabbit.encrypt(plainText)
            XCTAssertEqual(cipherText, expectedCipher)
            XCTAssertEqual(rabbit.decrypt(cipherText), plainText)
        }
    }
}

#if !CI
extension RabbitTests {
    func testRabbitPerformance() {
        let key: Array<UInt8> = Array<UInt8>(repeating: 0, count: Rabbit.keySize)
        let iv: Array<UInt8> = Array<UInt8>(repeating: 0, count: Rabbit.ivSize)
        let message = Array<UInt8>(repeating: 7, count: (1024 * 1024) * 1)
        measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: true, for: { () -> Void in
            let encrypted = try! Rabbit(key: key, iv: iv).encrypt(message)
            self.stopMeasuring()
            XCTAssert(!encrypted.isEmpty, "not encrypted")
        })
    }
}
#endif

extension RabbitTests {
    static func allTests() -> [(String, (RabbitTests) -> () -> Void)] {
        var tests = [
            ("testInitialization", testInitialization),
            ("testRabbitWithoutIV", testRabbitWithoutIV),
            ("testRabbitWithIV", testRabbitWithIV)
        ]

        #if !CI
            tests += [
                ("testRabbitPerformance", testRabbitPerformance)
            ]
        #endif
        return tests
    }
}
