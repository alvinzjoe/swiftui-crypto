//
//  PortfolioView.swift
//  Crypto
//
//  Created by Alvin Amri on 12/03/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var qtyText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, content: {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if(selectedCoin != nil) {
                        VStack(spacing: 20, content: {
                            HStack {
                                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                                Spacer()
                                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                            }
                            Divider()
                            HStack {
                                Text("Amount in holding")
                                Spacer()
                                TextField("Ex. 1.4", text: $qtyText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                            Divider()
                            HStack {
                                Text("Current value: ")
                                Spacer()
                                Text(getCurrentValue().asCurrencyWith2Decimals())
                            }
                        })
                        .animation(.none)
                        .padding()
                        .font(.headline)
                    }
                })
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                   XMarkButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarButtons
                }
                
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView()
                .environmentObject(dev.homeVM)
        }
        .toolbar(.hidden)
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke((selectedCoin?.id == coin.id) ? Color.theme.green : Color.clear, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        )
                }
            }
        }
        .padding(.vertical, 4)
        .padding(.leading)
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
            if  let portfolioCoin = vm.portfolioCoins.first { $0.id == coin.id },
            let amount = portfolioCoin.currentHoldings {
                qtyText = "\(amount)"
            } else {
                qtyText = ""
            }
    }
    
    private func getCurrentValue() -> Double {
        if let qty = Double(qtyText) {
            return qty * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var trailingNavBarButtons: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity((showCheckmark) ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save")
            })
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(qtyText) ? 1.0 : 0.0))
        }
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(qtyText) else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
