@testable import NetworkLogger
import XCTest

class NetworkLogPrinterTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private var output: ConsoleLogOutputMock?
    private var sut: NetworkLogPrinter?
    
    private var requestLog: Log?
    private var responseLog: Log?
    
    private var formattedRequestStrings: FormattedRequestStrings?
    private var formattedResponseStrings: FormattedResponseStrings?
    
    private var logType: Log.LogType?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        self.output = ConsoleLogOutputMock()
        self.sut = NetworkLogPrinter(output: self.output!)
    }
    
    override func tearDown() {
        self.output = nil
        self.sut = nil
        
        self.requestLog = nil
        self.responseLog = nil
        
        self.formattedRequestStrings = nil
        self.formattedResponseStrings = nil
        
        self.logType = nil
    }
    
    // MARK: - Tests: Request Section Formatting
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintFirstSectionAsDashedDivider() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsFirstSectionAsDashedDivider()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintDateTimeSectionAsFormattedString() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsDateTimeSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintRequestNameSectionAsFormattedString() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsRequestNameSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequestWithMethodTypeAndUrl_shouldPrintDataTransferSectionAsFormattedString() {
        // given
        givenRequestLogCreatedWithMethodTypeAndUrl()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsDataTransferRequestSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequestWithHeaders_shouldPrintRequestHeadersSectionAsFormattedString() {
        // given
        givenRequestLogCreatedWithHeaders()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsHeadersSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintRequestBodySectionAsNone() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsRequestBodySectionAsNone()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintLastSectionAsDashedDivider() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsLastSectionAsDashedDivider()
    }
    
    // MARK: - Tests: Request Optional Handling
    
    func test_OptionalHandling_whenPrintsRequestWithNoMethodType_shouldNotPrintDataTransferSectionIfMethodTypeIsNil() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintDataTransferSection()
    }
    
    func test_OptionalHandling_whenPrintsRequestWithNoURL_shouldNotPrintDataTransferSection() {
        // given
        givenRequestLogCreatedWithNoUrl()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintDataTransferSection()
    }
    
    func test_OptionalHandling_whenPrintsRequestWithNoMethodTypeAndNoUrl_shouldNotPrintDataTransferSectionIfMethodTypeAndUrlAreNil() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintDataTransferSection()
    }
    
    
    func test_OptionalHandling_whenPrintsRequestWithNoHeaders_shouldNotPrintHeadersSectionIfHeadersIsNil() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintHeadersSection()
    }
    
    // MARK: - Tests: Request Output Call Count
    
    func test_RequestOutputCallCount_whenPrintsRequest_shouldPrintDateTimeSectionExactlyOnce() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsDateTimeSectionExactlyOnceForRequest()
    }
    
    func test_RequestOutputCallCount_whenPrintsRequest_shouldPrintRequestNameSectionExactlyOnce() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsRequestNameSectionExactlyOnceForRequest()
    }
    
    func test_RequestOutputCallCount_whenPrintsRequestWithMethodTypeAndUrl_shouldPrintDataTransferSectionExactlyOnce() {
        // given
        givenRequestLogCreatedWithMethodTypeAndUrl()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsDataTransferSectionExactlyOnceForRequest()
    }
    
    func test_RequestOutputCallCount_whenPrintsRequestWithHeaders_shouldPrintHeadersSectionExactlyOnce() {
        // given
        givenRequestLogCreatedWithHeaders()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsHeadersSectionExactlyOnceForRequest()
    }
    
    func test_RequestOutputCallCount_whenPrintsRequest_shouldPrintBodySectionExactlyOnce() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsBodySectionExactlyOnceForRequest()
    }
    
    // MARK: - Tests: Successful Response Section Formatting
    
    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintFirstSectionAsDashedDivider() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()
        
        // then
        thenEnsurePrintsFirstSectionAsDashedDivider()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintDateTimeSectionAsFormattedString() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()
        
        // then
        thenEnsurePrintsDateTimeSectionAsFormattedString()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintRequestNameSectionAsFormattedString() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsRequestNameSectionAsFormattedString()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintDataTransferSectionAsFormattedString() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()
        
        // then
        thenEnsurePrintsDataTransferRequestSectionAsFormattedString()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintStatusSectionAsFormattedString() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsStatusSectionAsFormattedString()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintHeadersSectionAsFormattedString() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsHeadersSectionAsFormattedString()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintBodySectionAsFormattedString() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsBodySectionAsFormattedString()
    }

    func test_SuccessfulResponseSectionFormatting_whenPrintsSuccessfulResponse_shouldPrintLastSectionAsDashedDivider() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsLastSectionAsDashedDivider()
    }
    
    // MARK: - Tests: Successful Response Output Call Count
    
    func test_SuccessfulResponseOutputCallCount_whenPrintsSuccessfulResponse_shouldPrintDateTimeSectionExactlyOnce() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsDateTimeSectionExactlyOnceForResponse()
    }
    
    func test_SuccessfulResponseOutputCallCount_whenPrintsSuccessfulResponse_shouldPrintRequestNameSectionExactlyOnce() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsRequestNameSectionExactlyOnceForResponse()
    }
    
    func test_SuccessfulResponseOutputCallCount_whenPrintsSuccessfulResponse_shouldPrintDataTransferSectionExactlyOnce() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsDataTransferSectionExactlyOnceForResponse()
    }
    
    func test_SuccessfulResponseOutputCallCount_whenPrintsSuccessfulResponse_shouldPrintStatusSectionExactlyOnce() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsStatusSectionExactlyOnceForResponse()
    }

    
    func test_SuccessfulResponseOutputCallCount_whenPrintsSuccessfulResponse_shouldPrintHeadersSectionExactlyOnce() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsHeadersSectionExactlyOnceForResponse()
    }
    
    func test_SuccessfulResponseOutputCallCount_whenPrintsSuccessfulResponse_shouldPrintBodySectionExactlyOnce() {
        // given
        givenSuccessfulResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsBodySectionExactlyOnceForResponse()
    }
    
    // MARK: - Tests: Failed Response Section Formatting

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintFirstSectionAsDashedDivider() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()
        
        // then
        thenEnsurePrintsFirstSectionAsDashedDivider()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintDateTimeSectionAsFormattedString() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()
        
        // then
        thenEnsurePrintsDateTimeSectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintRequestNameSectionAsFormattedString() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsRequestNameSectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintDataTransferSectionAsFormattedString() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()
        
        // then
        thenEnsurePrintsDataTransferRequestSectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintStatusSectionAsFormattedString() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsStatusSectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintHeadersSectionAsFormattedString() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsHeadersSectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponseWithNoHeaders_shouldPrintHeadersSectionAsFormattedString() {
        // given
        givenFailedResponseLogCreatedWithNoHeaders()

        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsHeadersSectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintBodySectionAsFormattedString() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsBodySectionAsFormattedString()
    }

    func test_FailedResponseSectionFormatting_whenPrintsFailedResponse_shouldPrintLastSectionAsDashedDivider() {
        // given
        givenFailedResponseLogCreated()

        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsLastSectionAsDashedDivider()
    }

    // MARK: - Tests: Failed Response Output Call Count
    
    func test_FailedResponseOutputCallCount_whenPrintsFailedResponse_shouldPrintDateTimeSectionExactlyOnce() {
        // given
        givenFailedResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsDateTimeSectionExactlyOnceForResponse()
    }
    
    func test_FailedResponseOutputCallCount_whenPrintsFailedResponse_shouldPrintRequestNameSectionExactlyOnce() {
        // given
        givenFailedResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsRequestNameSectionExactlyOnceForResponse()
    }
    
    func test_FailedResponseOutputCallCount_whenPrintsFailedResponse_shouldPrintDataTransferSectionExactlyOnce() {
        // given
        givenFailedResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsDataTransferSectionExactlyOnceForResponse()
    }
    
    func test_FailedResponseOutputCallCount_whenPrintsFailedResponse_shouldPrintStatusSectionExactlyOnce() {
        // given
        givenFailedResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsStatusSectionExactlyOnceForResponse()
    }

    
    func test_FailedResponseOutputCallCount_whenPrintsFailedResponse_shouldPrintHeadersSectionExactlyOnce() {
        // given
        givenFailedResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsHeadersSectionExactlyOnceForResponse()
    }
    
    func test_FailedResponseOutputCallCount_whenPrintsFailedResponse_shouldPrintBodySectionExactlyOnce() {
        // given
        givenFailedResponseLogCreated()
        
        // when
        whenPrintResponse()

        // then
        thenEnsurePrintsBodySectionExactlyOnceForResponse()
    }
    
    // MARK: - Given: Request Logs
    
    private func givenRequestLogCreated() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com")
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    private func givenRequestLogCreatedWithMethodTypeAndUrl() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      httpMethodType: "GET",
                      url: URL(string: "www.example.com")
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    private func givenRequestLogCreatedWithNoUrl() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      httpMethodType: "GET",
                      url: nil
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    private func givenRequestLogCreatedWithHeaders() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com"),
                      headers: [
                        "Date": "Thu, 07 Jul 2022 15:51:16 GMT",
                        "Gateway-Status": "OK",
                        "Example-Header": "Value"
                      ]
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    // MARK: - Given: Response Logs

    private func givenSuccessfulResponseLogCreated() {
        let log = Log(logType: .response,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com"),
                      status: 200,
                      statusDescription: "OK",
                      headers: [
                        "Date": "Thu, 07 Jul 2022 15:51:16 GMT",
                        "Gateway-Status": "OK",
                        "Example-Header": "Value"
                      ],
                      body: successResponseStub().toJsonString()
        )
        self.responseLog = log
        self.formattedResponseStrings = FormattedResponseStrings(log: log)
    }
    
    private func givenFailedResponseLogCreated() {
        let log = Log(logType: .response,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com"),
                      status: 400,
                      statusDescription: "Bad Request",
                      headers: [
                        "Date": "Thu, 07 Jul 2022 15:51:16 GMT",
                        "Gateway-Status": "OK",
                        "Example-Header": "Value"
                      ]
        )
        self.responseLog = log
        self.formattedResponseStrings = FormattedResponseStrings(log: log)
    }
    
    private func givenFailedResponseLogCreatedWithNoHeaders() {
        let log = Log(logType: .response,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com"),
                      status: 400,
                      statusDescription: "Bad Request"
        )
        self.responseLog = log
        self.formattedResponseStrings = FormattedResponseStrings(log: log)
    }

    
    // MARK: - When
    
    private func whenPrintRequest(_ log: Log? = nil) {
        if let log = log {
            self.sut?.writeLog(log)
        } else {
            self.sut?.writeLog(self.requestLog!)
        }
        
        self.logType = .request
    }
    
    private func whenPrintResponse(_ log: Log? = nil) {
        if let log = log {
            self.sut?.writeLog(log)
        } else {
            self.sut?.writeLog(self.responseLog!)
        }
        
        self.logType = .response
    }
    
    // MARK: - Then: EnsurePrintsFormattedStrings
    
    private func thenEnsurePrintsFirstSectionAsDashedDivider() {
        XCTAssertEqual(output?.writeStringParametersReceived.first, "----")
    }
    
    private func thenEnsurePrintsDateTimeSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedStringsFromLogType() else { XCTFail(); return }

        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.dateTime()))
    }
    
    private func thenEnsurePrintsRequestNameSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedStringsFromLogType() else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.requestName()))
    }
        
    private func thenEnsurePrintsDataTransferRequestSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedStringsFromLogType() else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.httpMethodTypeAndUrl()))
    }
    
    private func thenEnsurePrintsStatusSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedStringsFromLogType() else { XCTFail(); return }

        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.status()))
    }
    
    private func thenEnsurePrintsHeadersSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedStringsFromLogType() else { XCTFail(); return }

        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.headers()))
    }
    
    private func thenEnsurePrintsBodySectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedStringsFromLogType() else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.body()))
    }

    private func thenEnsurePrintsRequestBodySectionAsNone() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedRequestStrings else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.body()))
    }
    
    private func thenEnsurePrintsLastSectionAsDashedDivider() {
        XCTAssertEqual(output?.writeStringParametersReceived.last, "----")
    }
    
    // MARK: - Then: EnsureDoesNotPrint
    
    private func thenEnsureDoesNotPrintDataTransferSection() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: log.httpMethodType)) to: \(String(describing: log.url))"
                
        XCTAssertFalse(output.writeStringParametersReceived.contains(formattedMethodTypeAndURL), "should only print this line if both httpMethodType and Url are not nil")
    }
    
    private func thenEnsureDoesNotPrintHeadersSection() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedHeaders = "🧠 Headers: \(String(describing: log.headers))"
        
        XCTAssertFalse(output.writeStringParametersReceived.contains(formattedHeaders), "should only print this line if headers property is not nil")
    }
    
    // MARK: - Then: EnsurePrintsExactlyOnceForRequest
    
    private func thenEnsurePrintsDateTimeSectionExactlyOnceForRequest() {
        let formattedDateTime = self.formattedRequestStrings?.dateTime()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedDateTime }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsRequestNameSectionExactlyOnceForRequest() {
        let formattedRequestName = self.formattedRequestStrings?.requestName()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedRequestName }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsDataTransferSectionExactlyOnceForRequest() {
        let formattedDataTransfer = self.formattedRequestStrings?.httpMethodTypeAndUrl()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedDataTransfer }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsHeadersSectionExactlyOnceForRequest() {
        let formattedHeaders = self.formattedRequestStrings?.headers()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedHeaders }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsBodySectionExactlyOnceForRequest() {
        let formattedBody = self.formattedRequestStrings?.body()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedBody }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    // MARK: - Then: EnsurePrintsExactlyOnceForResponse

    private func thenEnsurePrintsDateTimeSectionExactlyOnceForResponse() {
        let formattedDateTime = self.formattedResponseStrings?.dateTime()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedDateTime }.count
        
        XCTAssertEqual(occurrences, 1)
    }

    private func thenEnsurePrintsRequestNameSectionExactlyOnceForResponse() {
        let formattedRequestName = self.formattedResponseStrings?.requestName()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedRequestName }.count
        
        XCTAssertEqual(occurrences, 1)
    }

    private func thenEnsurePrintsDataTransferSectionExactlyOnceForResponse() {
        let formattedDataTransfer = self.formattedResponseStrings?.httpMethodTypeAndUrl()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedDataTransfer }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsStatusSectionExactlyOnceForResponse() {
        let formattedDataTransfer = self.formattedResponseStrings?.status()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedDataTransfer }.count
        
        XCTAssertEqual(occurrences, 1)
    }

    
    private func thenEnsurePrintsHeadersSectionExactlyOnceForResponse() {
        guard let output = self.output else { XCTFail(); return }
        
        let formattedHeaders = self.formattedResponseStrings?.headers()
        let occurrences = output.writeStringParametersReceived.filter { $0 == formattedHeaders }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsBodySectionExactlyOnceForResponse() {
        let formattedBody = self.formattedResponseStrings?.body()
        let occurrences = output?.writeStringParametersReceived.filter { $0 == formattedBody }.count
        
        XCTAssertEqual(occurrences, 1)
    }

    // MARK: - Helpers
    
    private func formattedStringsFromLogType() -> FormattedStringsProtocol? {
        guard let logType = self.logType else { XCTFail(); return nil }

        switch logType {
        case .request:
            return self.formattedRequestStrings
        case .response:
            return self.formattedResponseStrings
        }
    }
    
    private func statusEmoji(from status: Int) -> String {
        status == 200 ? "🟢" : "🔴"
    }

    private struct FormattedRequestStrings: FormattedStringsProtocol {
        var log: Log
        
        func dateTime() -> String {
            "🕔 \(self.log.dateTime.description)"
        }
        
        func requestName() -> String {
            "⌨️ Request Name: \(self.log.requestName)"
        }
        
        func httpMethodTypeAndUrl() -> String {
            guard
                let httpMethodType = self.log.httpMethodType,
                let url = self.log.url
            else {
                XCTFail("httpMethodType must be non optional")
                return ""
            }
            
            return "⬆️ Sending \(httpMethodType) to: \(url)"
        }
        
        func status() -> String {
            XCTFail("Request cannot contain a status or status code")
            return ""
        }
        
        func headers() -> String {
            guard let headers = self.log.headers else {
                XCTFail("headers must be non optional")
                return ""
            }
            
            return "🧠 Headers:\n\(String(describing: headers))"
        }
        
        func body() -> String {
            "🏋️ Body: None"
        }
    }
    
    private struct FormattedResponseStrings: FormattedStringsProtocol {
        var log: Log
        
        func dateTime() -> String {
            "🕔 \(self.log.dateTime.description)"
        }
        
        func requestName() -> String {
            "⌨️ Request Name: \(self.log.requestName)"
        }
        
        func httpMethodTypeAndUrl() -> String {
            guard let url = self.log.url else {
                XCTFail("url must be non optional")
                return ""
            }
            
            return "⬇️ Received from \(url)"
        }
        
        func status() -> String {
            guard
                let status = self.log.status,
                let statusDescription = self.log.statusDescription
            else {
                XCTFail("status and statusDescription must be non optional")
                return ""
            }
            
            let statusEmoji = status == 200 ? "🟢" : "🔴"
                        
            return "📋 Status: \(status) \(statusEmoji) -- \(statusDescription)"
        }
        
        func headers() -> String {
            switch self.log.headers {
            case .some(let headers):
                return "🧠 Headers:\n\(headers)"
            case .none:
                return "🧠 Headers: None"
            }
        }
        
        func body() -> String {
            switch self.log.body {
            case .some(let body):
                return "🏋️ Body:\n\(body)"
            case .none:
                return "🏋️ Body: None"
            }
        }
    }
}

private protocol FormattedStringsProtocol {
    var log: Log { get }
    func dateTime() -> String
    func requestName() -> String
    func httpMethodTypeAndUrl() -> String
    func status() -> String
    func headers() -> String
    func body() -> String
}
