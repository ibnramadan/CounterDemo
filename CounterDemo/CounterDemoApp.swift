//
//  CounterDemoApp.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 04/02/2024.
//

import SwiftUI
import ComposableArchitecture
@main
struct CounterDemoApp: App {
    var body: some Scene {
        WindowGroup {
           // ContentView(store: Store(initialValue: AppState(), reducer: appReducer))
            ContentView(store: Store(initialState: CounterFeature.State(), reducer: {
                CounterFeature()
            }))
        }
    }
}
