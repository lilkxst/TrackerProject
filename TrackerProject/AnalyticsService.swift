//
//  AnalyticsService.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.11.23.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func activateYandexMetrica() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "c370c91c-7037-4a7c-ba7a-fb223efd0fcc") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func reportEvent(event: String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        } )
    }
}
