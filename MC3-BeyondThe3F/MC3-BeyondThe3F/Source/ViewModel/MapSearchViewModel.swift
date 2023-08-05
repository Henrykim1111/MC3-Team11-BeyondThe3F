//
//  MapSearchViewModel.swift
//  Tune Spot
//
//  Created by Seungui Moon on 2023/08/05.
//

import SwiftUI
import MapKit

class MapSearchViewModel: ObservableObject {
    @Published var searchPlaces : [Place] = []
    
    func getSearchPlace(_ searchTerm: String){
        searchPlaces.removeAll()
                
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTerm
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.searchPlaces = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }
    
}
