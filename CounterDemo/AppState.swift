//
//  AppState.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 19/02/2024.
//

import Foundation


enum CounterAction {
  case decrTapped
  case incrTapped
}
enum PrimeModalAction {
  case saveFavoritePrimeTapped
  case removeFavoritePrimeTapped
}
enum FavoritePrimesAction {
  case deleteFavoritePrimes(IndexSet)
}
enum AppAction {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
  case favoritePrimes(FavoritePrimesAction)
}

struct AppState {
    var count = 0
    var favoritePrimes: [Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []
   
    struct Activity {
        let timestamp: Date
        let type: ActivityType
        
        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }
    
    struct User {
        let id: Int
        let name: String
        let bio: String
    }
}

func appReducer(value: inout AppState, action: AppAction) -> Void {
  switch action {
  case .counter(.decrTapped):
    value.count -= 1

  case .counter(.incrTapped):
    value.count += 1

  case .primeModal(.saveFavoritePrimeTapped):
    value.favoritePrimes.append(value.count)
    value.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(value.count)))

  case .primeModal(.removeFavoritePrimeTapped):
    value.favoritePrimes.removeAll(where: { $0 == value.count })
    value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(value.count)))

  case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
    for index in indexSet {
      let prime = value.favoritePrimes[index]
      value.favoritePrimes.remove(at: index)
      value.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
    }
  }
}

final class Store<Value, Action>: ObservableObject {
  let reducer: (inout Value, Action) -> Void
  @Published private(set) var value: Value

  init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }

  func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
}
