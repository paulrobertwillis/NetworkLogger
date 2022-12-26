import Foundation

public protocol NetworkLoggerProtocol {
    func log(_ request: LoggableRequest)
    func log(_ response: LoggableResponse)
    func log(_ response: LoggableResponse, withError error: Error?)
}

class NetworkLogger {
    
    // MARK: - Private Properties
    
    private let printer: NetworkLogPrinterProtocol
    
    // MARK: - Lifecycle
    
    init(printer: NetworkLogPrinterProtocol) {
        self.printer = printer
    }
}

// MARK: - NetworkLoggerProtocol

extension NetworkLogger: NetworkLoggerProtocol {
    func log(_ request: LoggableRequest) {
        let log = Log(logType: .request,
                      requestName: request.requestName,
                      httpMethodType: request.urlRequest.httpMethod,
                      url: request.urlRequest.url,
                      headers: request.urlRequest.allHTTPHeaderFields
        )
        
        self.printer.writeLog(log)
    }
    
    func log(_ response: LoggableResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: LoggableResponse, withError error: Error?) {
        let log = Log(logType: .response,
                      requestName: response.requestName,
                      url: response.urlResponse.url,
                      status: response.urlResponse.statusCode,
                      statusDescription: HTTPResponse.statusCodes[response.urlResponse.statusCode] ?? "",
                      headers: response.urlResponse.allHeaderFields as? [String: String],
                      errorDescription: error?.localizedDescription,
                      body: self.convertJsonToString(response.data)
        )
        
        self.printer.writeLog(log)
    }
    
    private func convertJsonToString(_ data: Data?) -> String? {
        guard let data = data,
              let object = try? JSONSerialization.jsonObject(with: data),
              let serialisedData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        else {
            return nil
        }
        
        return String(data: serialisedData, encoding: .utf8)
    }
}

struct HTTPResponse {
    static let statusCodes: [Int: String] = [
        200: "OK",
        400: "Bad Request"
    ]
}

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
