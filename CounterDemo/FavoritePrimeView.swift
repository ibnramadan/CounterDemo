//
//  FavoritePrimeView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 18/02/2024.
//

import SwiftUI

struct FavoritePrimeView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        List{
            ForEach(self.store.value.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                self.store.send(.favoritePrimes(.deleteFavoritePrimes(indexSet)))
            }
        }
            .navigationTitle("Favorite Primes")
    }
}

#Preview {
    FavoritePrimeView(store: Store(initialValue: AppState(), reducer: appReducer))
}
