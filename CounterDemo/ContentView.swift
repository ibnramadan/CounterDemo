//
//  ContentView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 04/02/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var state: AppState
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                NavigationLink(destination: CounterView(state: state)) {
                    Text("Counter Demo")
                }
                NavigationLink(destination: FavoritePrimeView(state: FavoritePrimesState(state: state))) {
                    Text("favorite Primes")
                }
            }
            .navigationTitle("State Management")
        }
    }
}

#Preview {
    ContentView(state: AppState())
}
