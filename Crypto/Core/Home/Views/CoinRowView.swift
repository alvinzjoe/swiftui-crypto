//
//  CoinRowView.swift
//  Crypto
//
//  Created by Alvin Amri on 23/02/24.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingColumn: Bool
    var body: some View {
        HStack {
            leftColumn
            
            Spacer()
            
            if(showHoldingColumn) {
                centerColumn
                //Spacer()
            }
            
            rightColumn
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingColumn: true)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack (spacing: 5) {
            Text("\(coin.rank)")
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
        }
    }
    
    private var centerColumn: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var rightColumn: some View {
        VStack (alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0%")
                .foregroundStyle(coin.priceChangePercentage24H! >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
//            .frame(width: UIScreen.main.bounds.width / 3)
    }
}
