//
//  HTTPClientExampleAppApp.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

import SwiftUI

@main
struct HTTPClientExampleAppApp: App {
    var body: some Scene {
        WindowGroup {
            ExampleViewAssemblerInjection().resolve()
        }
    }
}
