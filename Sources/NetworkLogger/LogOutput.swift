import Foundation

// TODO: for prod/dev, can have different targets or a switch ...? By default, just use ifdebug.

public protocol LogOutputProtocol {
    func write(_ string: String)
}

class ConsoleLogOutput: LogOutputProtocol {
    func write(_ string: String) {
        print(string)
    }
}

class FileLogOutput: LogOutputProtocol {
    func write(_ string: String) {
        // do later when want to do to file
    }
}
