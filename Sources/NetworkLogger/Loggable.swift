import Foundation

public protocol LoggableError: Error {}

public protocol LoggableRequest {
    var urlRequest: URLRequest { get }
    var requestName: RequestName { get }
}

public protocol LoggableResponse {
    var urlResponse: HTTPURLResponse { get }
    var requestName: RequestName { get set }
    var data: Data? { get }
}
