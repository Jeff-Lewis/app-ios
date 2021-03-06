import Foundation

protocol CenMatcher {
    func hasMatches(key: CENKey, maxTimestamp: Int64) -> Bool
}

class CenMatcherImpl: CenMatcher {
    private let cenRepo: CENRepo // TODO decouple from DB
    private let cenLogic: CenLogic

    init(cenRepo: CENRepo, cenLogic: CenLogic) {
        self.cenRepo = cenRepo
        self.cenLogic = cenLogic
    }

    func hasMatches(key: CENKey, maxTimestamp: Int64) -> Bool {
        !match(key: key, maxTimestamp: maxTimestamp).isEmpty
    }

    // Copied from Android implementation
    private func match(key: CENKey, maxTimestamp: Int64) -> [CEN] {
        // take the last 7 days of timestamps and generate all the possible CENs (e.g. 7 days) TODO: Parallelize this?
        let minTimestamp: Int64 = maxTimestamp - 7*24*60
        var CENLifetimeInSeconds = 15*60   // every 15 mins a new CEN is generated

        // last time (unix timestamp) the CENKeys were requested

        let max = 7*24*(60/CENLifetimeInSeconds)

        var possibleCENs: [String] = []
        possibleCENs.reserveCapacity(max)

        let CENKeyLifetimeInSeconds = 7*86400 // every 7 days a new key is generated

        for i in 0...max {
            let ts = maxTimestamp - Int64(CENLifetimeInSeconds * i)
            let cen = cenLogic.generateCen(CENKey: key.cenKey)
//            possibleCENs[i] = cen.toHex()
            possibleCENs.append(cen.toHex()) // No fixed size array
        }

        return cenRepo.match(start: minTimestamp, end: maxTimestamp, hexEncodedCENs: possibleCENs)
    }
}
