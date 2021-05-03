//
//  MeteoriteListCell.swift
//  MeteoritesSwiftUI
//
//  Created by Adam Salih on 03.05.2021.
//

import SwiftUI

struct MeteoriteListCell: View {
    var meteorite: Meteorite
    
    var action: (Meteorite) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: geometry.size.width - 16, height: 1)
                Text(meteorite.name)
                    .font(.system(size: 17, weight: .bold))
                    .fontWeight(.heavy)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Button(action: { action(meteorite) }) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
