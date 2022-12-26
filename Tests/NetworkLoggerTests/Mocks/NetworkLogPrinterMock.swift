import Foundation
@testable import NetworkLogger

class NetworkLogPrinterMock: NetworkLogPrinterProtocol {
    var printedLog: String = ""
    
    // MARK: - printToDebugArea
    
    var recordLogCallCount = 0
    
    // log
    var recordLogParameterReceived: Log?
    
    func writeLog(_ log: Log) {
        self.recordLogCallCount += 1
        self.recordLogParameterReceived = log
    }
}
