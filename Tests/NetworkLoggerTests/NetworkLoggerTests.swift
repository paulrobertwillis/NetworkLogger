@testable import NetworkLogger
import XCTest

enum NetworkErrorMock: Error {
    case someError
}

class NetworkLoggerTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private var printer: NetworkLogPrinterMock?
    private var sut: NetworkLogger?
    
    private var url: URL?
    
    private var requestName: String?
    private var request: LoggableRequest?
    private var response: LoggableResponse?
    
    private var successResponseData: Data?
    private var networkError: NetworkErrorMock?
    
    // MARK: - Setup
    
    override func setUp() {
        self.printer = NetworkLogPrinterMock()
        self.sut = NetworkLogger(printer: self.printer!)
        
        self.url = URL(string: "www.example.com")
    }
    
    override func tearDown() {
        self.printer = nil
        self.sut = nil
        
        self.url = nil
        
        self.requestName = nil
        self.request = nil
        self.response = nil
        
        self.successResponseData = nil
        self.networkError = nil
    }
    
    // MARK: - Tests
    
    func test_LogCreation_whenLoggingResponseStatus_shouldCreateLog() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogsCreated(count: 1)
    }
    
    func test_LogCreation_whenLoggingMultipleResponseStatuses_shouldCreateMultipleLogs() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        whenResponseIsLogged()
        
        // then
        thenEnsureLogsCreated(count: 2)
    }
    
    func test_StatusCodeState_whenLoggingSuccessfulResponse_logShouldContainSuccessStatusCode() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogStatusCode(is: 200)
    }
    
    func test_StatusCodeState_whenLoggingFailedResponse_logShouldNotContainSuccessfulStatusCode() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogStatusCodeIsNotSuccess()
    }
    
    func test_StatusCodeDescriptionLogic_whenLoggingSuccessfulResponse_logShouldContainHTTPResponseStatusCodeDescription() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsSuccessfulStatusCodeDescription()
    }
    
    func test_StatusCodeDescriptionLogic_whenLoggingFailedResponse_logShouldContainHTTPResponseStatusCodeDescription() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsFailedStatusCodeDescription()
    }
    
    func test_StatusCodeDescriptionLogic_whenLoggingFailedResponse_logShouldContainEmptyHTTPResponseStatusCodeDescriptionIfResponseStatusCodeNotRecognised() {
        // given
        givenFailedResponseWithUnrecognisedStatusCode()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsEmptyStringAsStatusCodeDescription()
    }
    
    func test_LogType_whenLoggingSuccessfulResponse_logShouldBeResponseLog() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogTypeIsResponse()
    }
    
    func test_LogType_whenLoggingFailedResponse_logShouldBeResponseLog() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogTypeIsResponse()
    }
    
    func test_LogType_whenLoggingRequest_logShouldBeRequestLog() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogTypeIsRequest()
    }
    
    func test_LogFormatting_whenLoggingRequest_logShouldContainRequestURL() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsRequestURL()
    }
    
    func test_LogFormatting_whenLoggingRequest_logShouldContainRequestHeaders() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsExpectedRequestHeaders()
    }
    
    func test_LogFormatting_whenLoggingSuccessfulResponse_logShouldContainResponseHeaders() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsExpectedResponseHeaders()
    }
    
    func test_LogFormatting_whenLoggingFailedResponse_logShouldContainResponseHeaders() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsExpectedResponseHeaders()
    }
    
    func test_LogFormatting_whenLoggingRequest_logShouldContainTimeAndDateRequestWasMade() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_LogFormatting_whenLoggingSuccessfulResponse_logShouldContainTimeAndDateResponseWasReceived() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_LogFormatting_whenLoggingFailedResponse_logShouldContainTimeAndDateResponseWasReceived() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_LogFormatting_whenLoggingFailedResponse_logShouldContainAssociatedResponseError() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsErrorDescriptionForFailedResponse()
    }
    
    func test_LogFormatting_whenLoggingSuccessfulResponse_logShouldNotContainAnyResponseError() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogDoesNotContainErrorDescription()
    }
    
    func test_LogFormatting_whenLoggingRequest_logShouldContainNameOfNetworkRequestBeingPerformed() {
        // given
        givenRequest(ofType: "Get Movie Genres")
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()
    }
    
    func test_LogFormatting_whenLoggingMultipleRequests_logsShouldContainNamesOfAllNetworkRequestsBeingPerformed() {
        // given
        givenRequest(ofType: "Get Popular Movies")
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()
        
        // given
        givenRequest(ofType: "Get Top-Rated Movies")
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()
    }
    
    func test_LogFormatting_whenLoggingSuccessfulResponse_logShouldContainNameOfRequestThatResultedInResponse() {
        // given
        givenRequest(ofType: "Get Movie Genres")
        givenSuccessfulResponse(ofType: "Get Movie Genres")
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsNameOfRequestThatResultedInResponse()
    }
    
    func test_LogFormatting_whenLoggingFailedResponse_logShouldContainNameOfRequestThatResultedInResponse() {
        // given
        givenRequest(ofType: "Get Movie Genres")
        givenFailedResponse(ofType: "Get Movie Genres")
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsNameOfRequestThatResultedInResponse()
    }
    
    func test_LogFormatting_whenLoggingGetRequest_logShouldContainHTTPMethodTypeOfRequest() {
        // given
        givenGetRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsGetHTTPMethodType()
    }
    
    func test_LogFormatting_whenLoggingPostRequest_logShouldContainHTTPMethodTypeOfRequest() {
        // given
        givenPostRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsPostHTTPMethodType()
    }
    
    func test_LogFormatting_whenLoggingDeleteRequest_logShouldContainHTTPMethodTypeOfRequest() {
        // given
        givenDeleteRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsDeleteHTTPMethodType()
    }
    
    func test_LogFormatting_whenLoggingSuccessfulResponse_logShouldContainBodyOfResponseAsJson() {
        // given
        self.successResponseData = successResponseStub()
        givenSuccessfulResponse(withData: successResponseData)
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsBodyOfResponseAsJSON()
    }
    
    func test_LogFormatting_whenLoggingFailedResponse_logShouldContainNoBody() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogBodyIsNil()
    }
    
    func test_LogFormatting_whenLoggingRequest_logShouldContainNoBody() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogBodyIsNil()
    }
    
    func test_LogPrinting_whenLoggingRequestInDebug_shouldCallPrinterExactlyOnceToPrintLog() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsurePrinterIsCalled(numberOfTimes: 1)
    }
    
    func test_LogPrinting_whenLoggingMultipleRequestsInDebug_shouldCallPrinterMultipleTimesToPrintLogs() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        whenRequestIsLogged()
        whenRequestIsLogged()
        
        // then
        thenEnsurePrinterIsCalled(numberOfTimes: 3)
    }
    
    func test_LogPrinting_whenLoggingRequestInDebug_shouldPassLogToPrinter() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogIsPassedToPrinter()
    }
    
    func test_LogPrinting_whenLoggingSuccessfulResponseInDebug_shouldCallPrinterExactlyOnceToPrintLog() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsurePrinterIsCalled(numberOfTimes: 1)
    }
    
    func test_LogPrinting_whenLoggingMultipleSuccessfulResponsesInDebug_shouldCallPrinterMultipleTimesToPrintLogs() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        whenResponseIsLogged()
        whenResponseIsLogged()
        
        // then
        thenEnsurePrinterIsCalled(numberOfTimes: 3)
    }
    
    func test_LogPrinting_whenLoggingSuccessfulResponseInDebug_shouldPassLogToPrinter() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogIsPassedToPrinter()
    }
    
    func test_LogPrinting_whenLoggingFailedResponseInDebug_shouldCallPrinterExactlyOnceToPrintLog() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsurePrinterIsCalled(numberOfTimes: 1)
    }
    
    func test_LogPrinting_whenLoggingMultipleFailedResponsesInDebug_shouldCallPrinterMultipleTimesToPrintLogs() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        whenResponseIsLogged()
        whenResponseIsLogged()
        
        // then
        thenEnsurePrinterIsCalled(numberOfTimes: 3)
    }
    
    func test_LogPrinting_whenLoggingFailedResponseInDebug_shouldPassLogToPrinter() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogIsPassedToPrinter()
    }
    
    // MARK: - Given
    
    private func givenRequest(ofType type: String = "Unknown") {
        self.requestName = type
        self.request = Request(urlRequest: URLRequest(url: self.url!),
                                      requestName: type)
    }
    
    private func givenGetRequest() {
        self.requestName = "Get Movie Genres"
        
        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
        urlRequest.httpMethod = HTTPMethodType.get.rawValue
        
        self.request = Request(urlRequest: urlRequest,
                                      requestName: self.requestName!)
    }
    
    private func givenPostRequest() {
        self.requestName = "Post Movie Rating"
        
        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
        urlRequest.httpMethod = HTTPMethodType.post.rawValue
        
        self.request = Request(urlRequest: urlRequest,
                                      requestName: self.requestName!)
    }
    
    private func givenDeleteRequest() {
        self.requestName = "Delete Movie Rating"
        
        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
        urlRequest.httpMethod = HTTPMethodType.delete.rawValue
        
        self.request = Request(urlRequest: urlRequest,
                                      requestName: self.requestName!)
    }
    
    private func givenSuccessfulResponse(ofType type: String = "Unknown", withData data: Data? = nil) {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                          statusCode: 200,
                                          httpVersion: "1.1",
                                          headerFields: ["Date": "Thu, 07 Jul 2022 15:51:17 GMT"]
        )!
        self.response = Response(urlResponse: urlResponse,
                                        requestName: type,
                                        data: data)
    }
    
    private func givenFailedResponse(ofType type: String = "Unknown") {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                          statusCode: 400,
                                          httpVersion: "1.1",
                                          headerFields: ["Date": "Thu, 07 Jul 2022 15:51:17 GMT"]
        )!
        self.response = Response(urlResponse: urlResponse,
                                        requestName: type)
        self.networkError = NetworkErrorMock.someError
    }
    
    private func givenFailedResponseWithUnrecognisedStatusCode(requestType type: String = "Unknown") {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                          statusCode: 9999,
                                          httpVersion: "1.1",
                                          headerFields: [:]
        )!
        self.response = Response(urlResponse: urlResponse,
                                        requestName: type)
    }
    
    // MARK: - When
    
    private func whenRequestIsLogged() {
        guard let request = self.request else {
            XCTFail("request should be non optional at this point of execution")
            return
        }
        
        self.sut?.log(request)
    }
    
    private func whenResponseIsLogged() {
        guard let response = self.response else {
            XCTFail("response should be non optional at this point of execution")
            return
        }
        
        if self.networkError != nil {
            self.sut?.log(response, withError: self.networkError)
        } else {
            self.sut?.log(response)
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureLogsCreated(count: Int) {
        XCTAssertEqual(self.printer?.recordLogCallCount, count)
    }
    
    private func thenEnsureLogStatusCode(is status: Int) {
        XCTAssertEqual(self.lastLogCreated()?.status, status)
    }
    
    private func thenEnsureLogStatusCodeIsNotSuccess() {
        XCTAssertNotEqual(self.lastLogCreated()?.status, 200)
    }
    
    private func thenEnsureLogContainsSuccessfulStatusCodeDescription() {
        XCTAssertEqual("OK", self.lastLogCreated()?.statusDescription)
    }
    
    private func thenEnsureLogContainsFailedStatusCodeDescription() {
        XCTAssertEqual("Bad Request", self.lastLogCreated()?.statusDescription)
    }
    
    private func thenEnsureLogContainsEmptyStringAsStatusCodeDescription() {
        XCTAssertEqual("", self.lastLogCreated()?.statusDescription)
    }
    
    private func thenEnsureLogTypeIsRequest() {
        XCTAssertEqual(self.lastLogCreated()?.logType, .request)
    }
    
    private func thenEnsureLogTypeIsResponse() {
        XCTAssertEqual(self.lastLogCreated()?.logType, .response)
    }
    
    private func thenEnsureLogContainsRequestURL() {
        XCTAssertEqual(self.lastLogCreated()?.url, self.request?.urlRequest.url?.absoluteString)
    }
    
    private func thenEnsureLogContainsExpectedRequestHeaders() {
        XCTAssertEqual(self.lastLogCreated()?.headers, self.request?.urlRequest.allHTTPHeaderFields)
    }
    
    private func thenEnsureLogContainsExpectedResponseHeaders() {
        XCTAssertEqual(self.lastLogCreated()?.headers, self.response?.urlResponse.allHeaderFields as? [String: String])
    }
    
    private func thenEnsureLogContainsTimeAndDate() {
        XCTAssertEqual(self.lastLogCreated()?.dateTime.ISO8601Format(), Date().ISO8601Format())
    }
    
    private func thenEnsureLogContainsErrorDescriptionForFailedResponse() {
        XCTAssertEqual(self.lastLogCreated()?.errorDescription, self.networkError?.localizedDescription)
    }
    
    private func thenEnsureLogDoesNotContainErrorDescription() {
        XCTAssertNil(self.lastLogCreated()?.errorDescription)
    }
    
    private func thenEnsureLogContainsNameOfNetworkRequestBeingPerformed() {
        XCTAssertEqual(self.lastLogCreated()?.requestName, self.requestName)
    }
    
    private func thenEnsureLogContainsNameOfRequestThatResultedInResponse() {
        XCTAssertEqual(self.lastLogCreated()?.requestName, self.requestName)
    }
    
    private func thenEnsureLogContainsGetHTTPMethodType() {
        XCTAssertEqual(HTTPMethodType.get.rawValue, self.lastLogCreated()?.httpMethodType)
    }
    
    private func thenEnsureLogContainsPostHTTPMethodType() {
        XCTAssertEqual(HTTPMethodType.post.rawValue, self.lastLogCreated()?.httpMethodType)
    }
    
    private func thenEnsureLogContainsDeleteHTTPMethodType() {
        XCTAssertEqual(HTTPMethodType.delete.rawValue, self.lastLogCreated()?.httpMethodType)
    }
    
    private func thenEnsureLogContainsBodyOfResponseAsJSON() {
        XCTAssertEqual(self.lastLogCreated()?.body, self.successResponseData?.toJsonString())
    }
    
    private func thenEnsureLogBodyIsNil() {
        XCTAssertNil(self.lastLogCreated()?.body)
    }
    
    private func thenEnsurePrinterIsCalled(numberOfTimes: Int) {
        XCTAssertEqual(self.printer?.recordLogCallCount, numberOfTimes)
    }
    
    private func thenEnsureLogIsPassedToPrinter() {
        XCTAssertEqual(self.printer?.recordLogParameterReceived, self.lastLogCreated())
    }
    
    // MARK: - Helpers
    
    private func lastLogCreated() -> Log? {
        self.printer?.recordLogParameterReceived
    }
}

// MARK: - Data Extension

internal extension Data {
    func toJsonString() -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: self),
              let serialisedData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        else {
            return nil
        }
        
        return String(data: serialisedData, encoding: .utf8)
    }
}

func successResponseStub() -> Data {
        """
        {
        "page": 1,
        "results": [
        {
              "title": "The Shawshank Redemption",
            },
            {
              "title": "Whiplash",
            }
          ]
          "total_results": 5206,
          "total_pages": 261
        }
        """.data(using: .utf8)!
}

struct Request: LoggableRequest {
    let urlRequest: URLRequest
    let requestName: String
}

struct Response: LoggableResponse {
    let urlResponse: HTTPURLResponse
    let requestName: String
    let data: Data?
    
    public init(urlResponse: HTTPURLResponse,
         requestName: String,
         data: Data? = nil) {
        self.urlResponse = urlResponse
        self.requestName = requestName
        self.data = data
    }
}
