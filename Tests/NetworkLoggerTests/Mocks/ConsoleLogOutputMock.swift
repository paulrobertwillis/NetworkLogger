import Foundation
import NetworkLogger

class ConsoleLogOutputMock: LogOutputProtocol {
    
    // MARK: - write(_ string: String)
    
    var writeCallCount = 0
    
    // string
    var writeStringParametersReceived: [String] = []
    
    func write(_ string: String) {
        self.writeCallCount += 1
        self.writeStringParametersReceived.append(string)
        
        print(string)
    }
}
