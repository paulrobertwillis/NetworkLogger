import Foundation

protocol NetworkLogPrinterProtocol {
    func writeLog(_ log: Log)
}

class NetworkLogPrinter {
    
    private enum SectionEmojis: String {
        case dateTime = "🕔"
        case requestName = "⌨️"
        case sendingRequest = "⬆️"
        case receivingRequest = "⬇️"
        case status = "📋"
        case statusSuccess = "🟢"
        case statusFailure = "🔴"
        case headers = "🧠"
        case body = "🏋️"
    }
    
    // MARK: - Private Properties
    
    private let output: LogOutputProtocol
    
    // MARK: - Lifecycle
    
    init(output: LogOutputProtocol) {
        self.output = output
    }
}

// MARK: - NetworkLogPrinterProtocol

extension NetworkLogPrinter: NetworkLogPrinterProtocol {
    func writeLog(_ log: Log) {
        self.writeDividerSection()
        self.writeDateTimeSection(with: log.dateTime)
        self.writeRequestNameSection(with: log.requestName)
        self.writeDataTransferSection(for: log)
        self.writeStatusSection(for: log)
        self.writeHeadersSection(with: log.headers)
        self.writeBodySection(with: log.body)
        self.writeDividerSection()
    }
}

// MARK: - Divider Section

extension NetworkLogPrinter {
    private func writeDividerSection() {
        self.output.write("----")
    }
}

// MARK: - Date/Time Section

extension NetworkLogPrinter {
    private func writeDateTimeSection(with date: Date) {
        let formattedDateTime = "\(SectionEmojis.dateTime.rawValue) \(date)"
        self.output.write(formattedDateTime)
    }
}

// MARK: - Request Name Section

extension NetworkLogPrinter {
    private func writeRequestNameSection(with requestName: String) {
        let formattedRequestName = "\(SectionEmojis.requestName.rawValue) Request Name: \(requestName)"
        self.output.write(formattedRequestName)
    }
}

// MARK: - Data Transfer Section

extension NetworkLogPrinter {
    private func writeDataTransferSection(for log: Log) {
        guard let formattedDataTransferSection = formattedDataTransferSectionFromLog(log) else {
            return
        }
        
        self.output.write(formattedDataTransferSection)
    }
    
    private func formattedDataTransferSectionFromLog(_ log: Log) -> String? {
        switch log.logType {
        case .request:
            return self.requestDataTransferSection(httpMethodType: log.httpMethodType, url: log.url)
        case .response:
            return self.responseDataTransferSection(url: log.url)
        }
    }
    
    private func requestDataTransferSection(httpMethodType: String?, url: String?) -> String? {
        guard let httpMethodType = httpMethodType else { return nil }
        guard let url = url else { return nil }

        return "\(SectionEmojis.sendingRequest.rawValue) Sending \(httpMethodType) to: \(url)"
    }
    
    private func responseDataTransferSection(url: String?) -> String? {
        guard let url = url else { return nil }

        return "\(SectionEmojis.receivingRequest.rawValue) Received from \(url)"
    }
}

// MARK: - Status Section

extension NetworkLogPrinter {
    private func writeStatusSection(for log: Log) {
        guard let formattedStatusSection = formattedStatusSectionFromLog(log) else {
            return
        }
        
        self.output.write(formattedStatusSection)
    }
    
    private func formattedStatusSectionFromLog(_ log: Log) -> String? {
        switch log.logType {
        case .request:
            return nil
        case .response:
            return self.responseStatusSection(status: log.status, statusDescription: log.statusDescription)
        }
    }
    
    private func responseStatusSection(status: Int?, statusDescription: String?) -> String? {
        guard let status = status else { return nil }
        guard let statusDescription = statusDescription else { return nil }
        
        let statusEmoji = status == 200 ? SectionEmojis.statusSuccess.rawValue : SectionEmojis.statusFailure.rawValue

        return "\(SectionEmojis.status.rawValue) Status: \(status) \(statusEmoji) -- \(statusDescription)"
    }
}

// MARK: - Headers Section

extension NetworkLogPrinter {
    private func writeHeadersSection(with headers: [String: String]?) {
        switch headers {
        case .some(let headers):
            let formattedHeaders = "\(SectionEmojis.headers.rawValue) Headers:\n\(headers)"
            self.output.write(formattedHeaders)
        case .none:
            let formattedHeaders = "\(SectionEmojis.headers.rawValue) Headers: None"
            self.output.write(formattedHeaders)
        }
    }
}

// MARK: - Body Section

extension NetworkLogPrinter {
    private func writeBodySection(with body: String?) {
        body == nil ? self.writeEmptyBodySection() : self.writeSuccessResponseBodySection(body!)
    }
    
    private func writeEmptyBodySection() {
        let formattedBody = "\(SectionEmojis.body.rawValue) Body: None"
        self.output.write(formattedBody)
    }
    
    private func writeSuccessResponseBodySection(_ body: String) {
        let formattedBody = "\(SectionEmojis.body.rawValue) Body:\n\(body)"
        self.output.write(formattedBody)
    }
}
