//
//  FavoritePrimeView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 18/02/2024.
//

import SwiftUI

struct FavoritePrimeView: View {
    @ObservedObject var state: FavoritePrimesState
    var body: some View {
        List{
            ForEach(self.state.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let prime = self.state.favoritePrimes[index]
                    self.state.favoritePrimes.remove(at: index)
                    self.state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))

                }
            }
        }
            .navigationTitle("Favorite Primes")
    }
}

#Preview {
    FavoritePrimeView(state: FavoritePrimesState(state: AppState()))
}
