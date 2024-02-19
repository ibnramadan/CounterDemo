//
//  IsPrimeModalView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 06/02/2024.
//

import SwiftUI

struct IsPrimeModalView: View {
    @ObservedObject var state: AppState

    var body: some View {
        VStack {
            if isPrime(self.state.count) {
              Text("\(self.state.count) is prime 🎉")
              if self.state.favoritePrimes.contains(self.state.count) {
                Button(action: {
                  self.state.favoritePrimes.removeAll(where: { $0 == self.state.count })
                    self.state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(self.state.count)))
                }) {
                  Text("Remove from favorite primes")
                }
              } else {
                Button(action: {
                  self.state.favoritePrimes.append(self.state.count)
                    self.state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(self.state.count)))
                }) {
                  Text("Save to favorite primes")
                }
              }

            } else {
              Text("\(self.state.count) is not prime :(")
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
    IsPrimeModalView(state: AppState())
}
