//
//  MeteoriteView.swift
//  MeteoritesSwiftUI
//
//  Created by Adam Salih on 03.05.2021.
//

import SwiftUI
import BottomSheet

struct MeteoriteView: View {
    @State var meteorite: Meteorite
    @EnvironmentObject var bottomSheet: BottomSheetModel<BottomSheetDefaultAnchor>
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                bottomSheet.pop()
            }, label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(Color(UIColor.label))
            }).frame(width: 50, height: 50)
            .padding(.init(top: 16, leading: 16, bottom: 0, trailing: 0))
            HStack {
                Text(meteorite.name)
                    .font(.system(size: 32, weight: .bold))
                    .padding(.init(top: 8, leading: 24, bottom: 16, trailing: 24))
                Spacer()
            }
            VStack(spacing: 8) {
                HStack {
                    Text("Rok dopadu")
                    Spacer()
                    Text(meteorite.year ?? "-")
                }
                HStack {
                    Text("Hmotnost")
                    Spacer()
                    Text(meteorite.mass.flatMap { "\($0) g" } ?? "-")
                }
                HStack {
                    Text("Třída")
                    Spacer()
                    Text(meteorite.recclass)
                }
                HStack {
                    Text("Zeměpisná šířka")
                    Spacer()
                    Text(meteorite.reclat ?? "-")
                }
                HStack {
                    Text("Zeměpisná délka")
                    Spacer()
                    Text(meteorite.reclong ?? "-")
                }
            }.padding(.init(top: 0, leading: 32, bottom: 0, trailing: 32))
            Spacer()
        }.frame(height: 400)
    }
}
