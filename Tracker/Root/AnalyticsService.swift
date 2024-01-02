import Foundation
//import YandexMobileMetrica

final class AnalyticsService {
    static func activate() {
//        let apiKey = YandexMetricaApiKey.value // используйте ваш ключ
//        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else { return }
//        YMMYandexMetrica.activate(with: configuration)
    }
    
    static func report(event: String, params : [AnyHashable : Any]) {
//        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
//            print("REPORT ERROR: %@", error.localizedDescription)
//        })
    }
}
