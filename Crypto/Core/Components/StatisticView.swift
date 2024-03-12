//
//  StatisticView.swift
//  Crypto
//
//  Created by Alvin Amri on 11/03/24.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: ((stat.percentageChange ?? 0) >= 0) ? 0 : 180)
                    )
                Text(stat.percentageChange?.asPercentString()  ?? " ")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(((stat.percentageChange ?? 0) >= 0) ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HStack {
                StatisticView(stat: dev.stat1)
                Spacer()
                StatisticView(stat: dev.stat2)
                Spacer()
                StatisticView(stat: dev.stat3)
            }
            .padding()
        }
        .toolbar(.hidden)
    }
}

