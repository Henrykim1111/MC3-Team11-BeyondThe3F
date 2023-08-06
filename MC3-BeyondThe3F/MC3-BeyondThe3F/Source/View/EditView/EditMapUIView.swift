//
//  EditMapUIView.swift
//  Tune Spot
//
//  Created by Seungui Moon on 2023/08/05.
//

import CoreLocation
import MapKit
import SwiftUI

struct EditMapUIView: UIViewRepresentable{
    @Binding var mapView: MKMapView
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    @Binding var selectedPositionDescription: String
    @Binding var isRegionSetted: Bool
    @Binding var showDeniedLocationStatus: Bool
    @Binding var isLocationEnabled: Bool
    @Binding var locationInfo: String
    @Binding var newMapPosition: CLLocationCoordinate2D
    
    @ObservedObject private var musicUpdateViewModel = MusicItemUpdateViewModel.shared
    
    private let locationManager = LocationManager.shared.locationManager
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.4, longitude: 127)
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: EditMapUIView

        init(_ parent: EditMapUIView) {
            self.parent = parent
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.parent.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.newMapPosition = mapView.centerCoordinate
            
            if parent.isRegionSetted {
                parent.isRegionSetted = false
            }
        }
        
        
    }

    func makeCoordinator() -> Coordinator {
        EditMapUIView.Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if isRegionSetted {
            uiView.setRegion(region, animated: true)
            isRegionSetted = false
        }
    }
}
