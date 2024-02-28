//
//  ContentView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 04/02/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                NavigationLink(destination: CounterView(store: store)) {
                    Text("Counter Demo")
                }
                NavigationLink(destination: FavoritePrimeView(store: self.store)) {
                    Text("favorite Primes")
                }
            }
            .navigationTitle("State Management")
        }
    }
}

#Preview {
    ContentView(store: Store(initialValue: AppState(), reducer: appReducer))
}
