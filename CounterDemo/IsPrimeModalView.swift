//
//  IsPrimeModalView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 06/02/2024.
//

import SwiftUI

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        VStack {
            if isPrime(self.store.value.count) {
                Text("\(self.store.value.count) is prime 🎉")
                if self.store.value.favoritePrimes.contains(self.store.value.count) {
                Button(action: {
                    self.store.send(.primeModal(.removeFavoritePrimeTapped))
                }) {
                  Text("Remove from favorite primes")
                }
              } else {
                Button(action: {
                    self.store.send(.primeModal(.saveFavoritePrimeTapped))
                }) {
                  Text("Save to favorite primes")
                }
              }

            } else {
              Text("\(self.store.value.count) is not prime :(")
            }
        }
    }
    
    private func isPrime (_ p: Int) -> Bool {
      if p <= 1 { return false }
      if p <= 3 { return true }
      for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
      }
      return true
    }
}


#Preview {
    IsPrimeModalView(store: Store(initialValue: AppState(), reducer: appReducer))
}
