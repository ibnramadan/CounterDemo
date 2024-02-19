//
//  AppState.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 19/02/2024.
//

import Foundation


class AppState: ObservableObject {
    @Published var count = 0
    @Published var favoritePrimes: [Int] = []
    
    @Published var loggedInUser: User? = nil
    @Published var activityFeed: [Activity] = []
    
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

extension AppState {
    func addFavoritePrime() {
        self.favoritePrimes.append(self.count)
        self.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(self.count)))
    }
    
    func removeFavoritePrime(_ prime: Int) {
        self.favoritePrimes.removeAll(where: { $0 == prime })
        self.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
    }
    
    func removeFavoritePrime() {
        self.removeFavoritePrime(self.count)
    }
    
    func removeFavoritePrimes(at indexSet: IndexSet) {
        for index in indexSet {
            self.removeFavoritePrime(self.favoritePrimes[index])
        }
    }
}


class FavoritePrimesState: ObservableObject {
    private var state: AppState
    init(state: AppState) {
        self.state = state
    }
    
    var favoritePrimes: [Int] {
        get {
            self.state.favoritePrimes
        }
        set {
            self.state.favoritePrimes = newValue
        }
    }
    
    var activityFeed: [AppState.Activity] {
        get {
            self.state.activityFeed
        }
        set {
            self.state.activityFeed = newValue
        }
    }
}
