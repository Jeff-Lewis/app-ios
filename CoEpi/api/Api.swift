import Foundation
import RxSwift
import RxSwift
import RxAlamofire
import RxBlocking

protocol Api {

    func postCenReport(cenReport: CENReport) -> Completable

    func getCenKeys() -> Single<[String]>

    func getCenReport(cenKey: CENKey, id: String, report: String) -> Single<CENReport>
}

// TODO finish
class ApiImpl: Api {

    var lastSuccessfulExposureCheck = Date()
    var currentAttemptedExposureCheck = Date()


    func postCenReport(cenReport: CENReport) -> Completable {
        struct reportPayload: Encodable {
            let reportID: String
            let report: String
            let cenKeys: String
            let reportTimestamp: Int64
        }

        let payload: reportPayload = reportPayload(reportID: cenReport.id,
                                                   report: cenReport.report,
                                                   cenKeys: cenReport.keys,
                                                   reportTimestamp: cenReport.timestamp)

        guard let jsonData = try? JSONEncoder().encode(payload) else {
            return Completable.empty()
        }

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }

        let stringURL = "https://coepi.wolk.com:8080/cenreport"
        var request = URLRequest(url: URL(string: stringURL)!)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return RxAlamofire.request(request).debug().responseString().debug().ignoreElements()
    }

    func getCenKeys() -> Single<[String]> {
        let stringURL = "https://coepi.wolk.com:8080/cenkeys/\(Int(currentAttemptedExposureCheck.timeIntervalSince1970))"
        return json(.get, stringURL).asSingle().map { result in
            result as! [String]
        }
    }

    func getCenReport(cenKey: CENKey, id: String, report: String) -> Single<CENReport> {
        let stringURL = "https://coepi.wolk.com:8080/cenreport/\(cenKey)"
        return json(.get, stringURL).asSingle().map { result in
            CENReport(id: id, report: report, timestamp: Int64(Date().timeIntervalSince1970))
        }
    }
}
