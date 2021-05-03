//
//  AppModel.swift
//  MeteoritesSwiftUI
//
//  Created by Adam Salih on 30.04.2021.
//

import Foundation
import Combine
import DynamicContent


class AppModel {
    private let url: URL = "https://data.nasa.gov/resource/y77d-th95.json"
    private let token: String = "THhtPVVG3TovCfxbxXoYTYvAU"
    private var cancellables: Set<AnyCancellable> = Set()
    private let decoder: JSONDecoder = .init()
    
    var meteorites: CurrentValueSubject<[Meteorite], Never> = CurrentValueSubject([])
    var meteoritesState: CurrentValueSubject<ContentDefaultState, Never> = CurrentValueSubject(.loading)
    private(set) lazy var mapViewModel: MapViewModel = { .init(publisher: meteorites.eraseToAnyPublisher()) }()
    private(set) lazy var meteoriteListModel: MeteoriteListViewModel = {
        .init(
            meteoritePublisher: meteorites.eraseToAnyPublisher(),
            statePublisher: meteoritesState.eraseToAnyPublisher()
        )
    }()
    
    init() {
        meteorites
            .map { videos -> ContentDefaultState in videos.isEmpty ? .empty : .content }
            .subscribe(meteoritesState)
            .store(in: &cancellables)
    }
    
    func loadMeteorites() {
        meteoritesState.value = .loading
        var request = URLRequest(url: URL(string: "https://data.nasa.gov/resource/y77d-th95.json")!)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.addValue(self.token, forHTTPHeaderField: "X-App-Token")
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw AppError.generalCommunicationError
                }
                return data
            }
//            .map { data -> [Meteorite] in return [] }
            .decode(type: [Meteorite].self, decoder: decoder)
            .map { $0.filter { $0.geolocation != nil && !$0.name.isEmpty  } }
            .replaceError(with: [])
//            .filter { !$0.isEmpty }
            .sink(receiveValue: { [weak self] meteorites in self?.meteorites.value = meteorites })
            .store(in: &cancellables)
    }
}
