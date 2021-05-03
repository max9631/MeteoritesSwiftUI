//
//  MeteoriteListView.swift
//  MeteoritesSwiftUI
//
//  Created by Adam Salih on 03.05.2021.
//

import SwiftUI
import Combine
import DynamicContent
import BottomSheet

class MeteoriteListViewModel: ObservableObject {
    @Published var meteorites: [Meteorite] = []
    @Published var contentState: ContentDefaultState = .content
    
    private var cancellables: [AnyCancellable] = []
    
    init(meteoritePublisher: AnyPublisher<[Meteorite], Never>? = nil, statePublisher: AnyPublisher<ContentDefaultState, Never>?) {
        meteoritePublisher.flatMap(bind(meteoritePublisher:))
        statePublisher.flatMap(bind(statePublisher:))
    }
    
    func bind(meteoritePublisher: AnyPublisher<[Meteorite], Never>) {
        meteoritePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] meteorites in self?.meteorites = meteorites }
            .store(in: &cancellables)
    }
    
    func bind(statePublisher: AnyPublisher<ContentDefaultState, Never>) {
        statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in self?.contentState = state }
            .store(in: &cancellables)
    }
}


struct MeteoriteListView: View {
    @ObservedObject var model: MeteoriteListViewModel
    @EnvironmentObject var bottomSheet: BottomSheetModel<BottomSheetDefaultAnchor>
    
    var body: some View {
        NavigationView {
            DynamicContent(stateBinding: $model.contentState) {
                ScrollView(bottomSheet.scrollViewAxis) {
                    LazyVStack(spacing: 0) {
                        ForEach(model.meteorites) { meteorite in
                            MeteoriteListCell(meteorite: meteorite, action: show)
                                .frame(height: 50)
                        }
                    }
                    .navigationBarTitle("Meteorites", displayMode: .inline)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .frame(maxWidth: .infinity)
    }
    
    func show(meteorite: Meteorite) {
        bottomSheet.push(
            view: MeteoriteView(meteorite: meteorite)
                .background(Color(UIColor.systemBackground))
            ,
            initialAnchor: .max)
    }
}
