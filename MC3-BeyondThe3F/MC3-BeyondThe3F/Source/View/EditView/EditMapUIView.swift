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
    
    @ObservedObject private var musicUpdateViewModel = MusicItemUpdateViewModel.shared
    
    
    private let locationManager = LocationManager.shared.locationManager
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
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
            parent.selectedCoordinate = mapView.centerCoordinate
            getSearchPlace(coord: mapView.centerCoordinate)
            if parent.isRegionSetted {
                parent.isRegionSetted = false
            }
        }
        
        private func getSearchPlace(coord: CLLocationCoordinate2D){
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { placemarks, e in
                guard e == nil else {
                    return
                }
                
                if let firstPlacemark = placemarks?.first {
                    if firstPlacemark.country != nil {
                        self.parent.selectedPositionDescription = "\(firstPlacemark.country ?? "") \(firstPlacemark.locality ?? "") \(firstPlacemark.subLocality ?? "")"
                    }
                    if firstPlacemark.locality == nil {
                        if firstPlacemark.country == nil {
                            self.parent.selectedPositionDescription = "설정할 수 없는 위치입니다."
                        } else {
                            self.parent.selectedPositionDescription = "원하는 위치를 조금 더 자세히 표시해주세요."
                        }
                    } else {
                        self.parent.locationInfo = "\(firstPlacemark.locality ?? "")"
                    }
                }
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
