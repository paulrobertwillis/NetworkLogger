import Foundation

public struct LoggableRequest {
    let urlRequest: URLRequest
    let requestName: String
}

public struct LoggableResponse {
    let urlResponse: HTTPURLResponse
    let requestName: String
    let data: Data?
    
    init(urlResponse: HTTPURLResponse,
         requestName: String,
         data: Data? = nil) {
        self.urlResponse = urlResponse
        self.requestName = requestName
        self.data = data
    }
}
