//
//  testImmersiveApp.swift
//  testImmersive
//
//  Created by 김수환 on 3/3/24.
//

import SwiftUI

@main
struct testImmersiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
