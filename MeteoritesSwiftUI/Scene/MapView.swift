//
//  MapView.swift
//  MeteoritesSwiftUI
//
//  Created by Adam Salih on 03.05.2021.
//

import SwiftUI
import Combine
import MapKit

class MapViewModel: ObservableObject {
    @Published var meteorites: [Meteorite] = []
    @Published var region: MKCoordinateRegion = .init(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0 ),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(publisher: AnyPublisher<[Meteorite], Never>? = nil) {
        if let publisher = publisher {
            self.bind(with: publisher)
        }
    }
    
    func bind(with publisher: AnyPublisher<[Meteorite], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.meteorites, on: self)
            .store(in: &cancellables)
    }
}

struct MapView: View {
    @ObservedObject var model: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $model.region, annotationItems: model.meteorites) { meteorite in
            MapPin(coordinate: meteorite.locationCoordinate)
        }.ignoresSafeArea()
    }
}
