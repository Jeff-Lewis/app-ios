import Foundation
import Dip

class Dependencies {

    func createContainer() -> DependencyContainer {
        let container = DependencyContainer()

        registerLogic(container: container)
        registerViewModels(container: container)
        registerDaos(container: container)
        registerRepos(container: container)
        registerServices(container: container)
        registerNetworking(container: container)
        registerWiring(container: container)
        registerBle(container: container)

        return container
    }

    private func registerViewModels(container: DependencyContainer) {
        container.register { HomeViewModel() }
        container.register { OnboardingWireframe(container: container) }
        container.register { OnboardingViewModel() }
        container.register { HealthQuizViewModel(container: container) }
        container.register { AlertsViewModel(container: container) }

        container.register { DebugViewModel(bleAdapter: try container.resolve(),
                                            api: try container.resolve()) }
    }

    private func registerDaos(container: DependencyContainer) {
        container.register(.singleton) { RealmProvider() }
        container.register(.singleton) { RealmCENDao(realmProvider: try container.resolve()) as CENDao }
        container.register(.singleton) { RealmCENReportDao(realmProvider: try container.resolve()) as CENReportDao }
        container.register(.singleton) { RealmCENKeyDao(realmProvider: try container.resolve(),
                                                        cenLogic: try container.resolve()) as CENKeyDao }
    }

    private func registerRepos(container: DependencyContainer) {
        container.register(.singleton) { SymptomRepoImpl(coEpiRepo: try container.resolve()) as SymptomRepo }
        container.register(.singleton) { AlertRepoImpl(coEpiRepo: try container.resolve(),
                                                       cenReportsRepo: try container.resolve()) as AlertRepo }
        container.register(.singleton) { CENRepoImpl(cenDao: try container.resolve()) as CENRepo }
        container.register(.singleton) { CenReportRepoImpl(cenReportDao: try container.resolve()) as CENReportRepo }
        container.register(.singleton) { CENKeyRepoImpl(cenKeyDao: try container.resolve()) as CENKeyRepo }
        container.register(.singleton) { CoEpiRepoImpl(cenRepo: try container.resolve(),
                                                       api: try container.resolve(),
                                                       keysFetcher: try container.resolve(),
                                                       cenMatcher: try container.resolve()) as CoEpiRepo }
    }

    private func registerServices(container: DependencyContainer) {
        container.register(.singleton) { ContactReceivedHandler(cenKeyRepo: try container.resolve(),
                                                    cenLogic: try container.resolve()) }

    }

    private func registerLogic(container: DependencyContainer) {
        container.register(.singleton) { CenLogic() }
    }

    private func registerNetworking(container: DependencyContainer) {
        container.register(.singleton) { ApiImpl() as Api }
    }

    private func registerWiring(container: DependencyContainer) {
        container.register(.singleton) { ScannedCensHandler(coepiRepo: try container.resolve(),
                                                bleAdapter: try container.resolve()) }
        container.register(.eagerSingleton) { CenKeysFetcher(api: try container.resolve()) }
        container.register(.singleton) { CenMatcherImpl(cenRepo: try container.resolve(),
                                                        cenLogic: try container.resolve()) as CenMatcher }

        // .eagerSingleton appears not to work. Triggering initialization.
        let _: CoEpiRepo = try! container.resolve()
    }

    private func registerBle(container: DependencyContainer) {
        container.register(.singleton) { BleAdapter(cenReadHandler: try container.resolve()) }
        container.register(.eagerSingleton) { BluetoothController(delegate: try container.resolve()) }

    }
}

