protocol CENKeyRepo {
    func generateAndStoreCENKey() -> CENKey

    func computeSymmetricKey() -> String?

    func getLatestCENKey() -> CENKey?

    func getCENKeys(limit: Int64) -> [CENKey]?

    func insert(key: CENKey) -> Bool
}