//
//  CounterView.swift
//  CounterDemo
//
//  Created by mohamed ramadan on 04/02/2024.
//

import SwiftUI
import Combine

struct CounterView: View {
    
    @ObservedObject var store: Store<AppState, AppAction>
    @State var isPrimeModalShown: Bool = false
    @State var isNthPrimeShown: Bool = false
    @State var alertNthPrime: PrimeAlert?
    @State var isNthPrimeButtonDisabled = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    if self.store.value.count > 0 {
                        self.store.send(.counter(.decrTapped))                    }
                }, label: {
                    Text("-")
                })
                Text("\(self.store.value.count)")
                Button(action: {
                    self.store.send(.counter(.incrTapped))
                }, label: {
                    Text("+")
                })
            }
            
            Button(action: {
                isPrimeModalShown = true
            }, label: {
                Text("is this Prime?")
            })
            Button(action: self.nthPrimeButtonAction) {
                Text("What is the \(ordinal(self.store.value.count)) prime?")
            }
            .disabled(self.isNthPrimeButtonDisabled)
           
        }.font(.title)
            .sheet(isPresented: $isPrimeModalShown, onDismiss: { isPrimeModalShown = false
            }, content: {
                IsPrimeModalView(store: self.store)
            })
            .alert(isPresented: $isNthPrimeShown) {
                Alert(
                    title: Text("The \(ordinal(self.store.value.count)) prime is \(alertNthPrime?.prime ?? 0)"),
                    dismissButton: .default(Text("Ok"))
                )
            }
        
//            .alert(item: self.$alertNthPrime) { alert in
//              Alert(
//                title: Text("The \(ordinal(self.state.count)) prime is \(alert.prime)"),
//                dismissButton: .default(Text("Ok"))
//              )
//            }
    }
    
    func nthPrimeButtonAction() {
        self.isNthPrimeButtonDisabled = true
        nthPrime(self.store.value.count) { prime in
            self.alertNthPrime = prime.map(PrimeAlert.init(prime:))
            self.isNthPrimeShown = true
            self.isNthPrimeButtonDisabled = false
        }
    }
}


private func ordinal(_ n : Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

#Preview {
    CounterView(store: Store(initialValue: AppState(), reducer: appReducer))
}
