//
//  ContentView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 04/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct NumberFactClient {
  var fetch: @Sendable (Int) async throws -> String
}
extension NumberFactClient: DependencyKey {
  static let liveValue = Self { number in
    let (data, _) = try await URLSession.shared.data(
      from: URL(string: "http://www.numbersapi.com/\(number)")!
    )
    return String(decoding: data, as: UTF8.self)
  }
}
extension DependencyValues {
  var numberFact: NumberFactClient {
    get { self[NumberFactClient.self] }
    set { self[NumberFactClient.self] = newValue }
  }
}

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isTimerOn = false
        var isLoadingFact = false
    }
    
    enum Action: Equatable{
        case decrementButtonTapped
        case incrementButtonTapped
        case getFactButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTicked
    }
    
    private enum CancellID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .getFactButtonTapped:
                state.fact = nil
                state.isLoadingFact = true
                return .run { [count = state.count] send in
                  try await send(.factResponse(self.numberFact.fetch(count)))
                }
            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()
                if state.isTimerOn {
                    return .run { send in
                      for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                      }
                    }
                    .cancellable(id: CancellID.timer)
                } else {
                    return .cancel(id: CancellID.timer)
                }
            case let .factResponse(fact):
                state.isLoadingFact = false
                state.fact = fact
                return .none
            case .timerTicked:
                state.count += 1
                return .none
            }
            
        }
    }
}

struct ContentView: View {
    //  @ObservedObject var store: Store<AppState, AppAction>
    
    let store : StoreOf<CounterFeature>
    var body: some View {
        Form {
            Section {
                Text("\(store.count)")
                Button("Decrement") {
                    store.send(.decrementButtonTapped)
                }
                Button("Increment") {
                    store.send(.incrementButtonTapped)
                }
            }
            Section {
                Button {
                    store.send(.getFactButtonTapped)
                } label: {
                    HStack {
                        Text("Get Fact")
                        
                        if store.isLoadingFact {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                if let fact = store.fact {
                    Text(fact)
                }
                
                
            }
            
            Section {
                if store.isTimerOn {
                    Button("Stop timer") {
                        store.send(.toggleTimerButtonTapped)
                    }
                } else {
                    Button("Start Timer") {
                        store.send(.toggleTimerButtonTapped)
                    }
                }
            }
            
        }
    }
}

#Preview {
    // ContentView(store: Store(initialValue: AppState(), reducer: appReducer))
    
    ContentView(store: Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    })
}
