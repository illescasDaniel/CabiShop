//
//  PrintLoggerTests.swift
//  CabiShopTests
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import XCTest
@testable import CabiShop

class PrintLoggerTests: XCTestCase {

	func testPrintLogger() {
		let standardOutputString = captureSTDOUT {
			let logger = PrintLogger()
			logger.log(severity: .info, category: "categoryA", message: "message here")
		}
		print(standardOutputString)
		XCTAssertTrue(standardOutputString.contains("message here"))
		XCTAssertTrue(standardOutputString.contains("INFO"))
		XCTAssertTrue(standardOutputString.contains("categoryA"))
		XCTAssertTrue(standardOutputString.contains("PrintLoggerTests"))
	}

	// https://stackoverflow.com/a/73036792
	private func captureSTDOUT(printBlock: () -> Void) -> String {
		let outPipe = Pipe()
		var outString = String()
		let sema = DispatchSemaphore(value: 0)
		outPipe.fileHandleForReading.readabilityHandler = { fileHandle in
			let data = fileHandle.availableData
			if data.isEmpty  { // end-of-file condition
				fileHandle.readabilityHandler = nil
				sema.signal()
			} else {
				outString += String(data: data,  encoding: .utf8)!
			}
		}

		// Redirect
		setvbuf(stdout, nil, _IONBF, 0)
		let savedStdout = dup(STDOUT_FILENO)
		dup2(outPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

		printBlock()

		// Undo redirection
		dup2(savedStdout, STDOUT_FILENO)
		try! outPipe.fileHandleForWriting.close()
		close(savedStdout)
		sema.wait() // Wait until read handler is done

		return outString
	}
}

