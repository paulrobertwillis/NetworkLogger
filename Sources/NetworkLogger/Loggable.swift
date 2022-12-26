import Foundation

public protocol LoggableRequest {
    var urlRequest: URLRequest { get }
    var requestName: String { get }
}

public protocol LoggableResponse {
    var urlResponse: HTTPURLResponse { get }
    var requestName: String { get }
    var data: Data? { get }
}
