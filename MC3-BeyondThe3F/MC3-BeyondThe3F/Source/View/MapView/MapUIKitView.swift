//
//  MapUIKitView.swift
//  Tune Spot
//
//  Created by Seungui Moon on 2023/08/05.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapUIKitView: UIViewRepresentable {
    @Binding var mapView: MKMapView
    @Binding var musicList: [MusicItem]
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var currentRegion: MKCoordinateRegion
    @Binding var isShowUserLocation: Bool
    @Binding var centerPlaceDescription: String
    
    let locationManager: CLLocationManager

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapUIKitView

        init(_ parent: MapUIKitView) {
            self.parent = parent
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.parent.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            var newAnnotaionList: [MusicItem] = []
            for annotation in mapView.visibleAnnotations() {
                if let defaultAnnotation = annotation as? MusicAnnotation {
                    newAnnotaionList.append(defaultAnnotation.musicData)
                }
            }
            setMusicList(newAnnotaionList)
            getSearchPlace(coord: mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
            case is MusicAnnotation:
                let musicAnnotaionView = MusicAnnotationView(annotation: annotation, reuseIdentifier: MusicAnnotationView.ReuseID)
                
                return musicAnnotaionView
            case is MKClusterAnnotation:
                return ClusteringAnnotationView(annotation: annotation, reuseIdentifier: ClusteringAnnotationView.ReuseID)
            default:
                return nil
            }
        }
       
        func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
            let clusterAnnotaion = MKClusterAnnotation(memberAnnotations: memberAnnotations)
            clusterAnnotaion.title  = "clusted"
            return clusterAnnotaion
        }
        
        private func setMusicList(_ newMusicList: [MusicItem]) {
            parent.musicList = []
            parent.musicList = newMusicList
        }
        
        private func getSearchPlace(coord: CLLocationCoordinate2D){
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { placemarks, e in
                guard e == nil else {
                    return
                }
                
                if let firstPlacemark = placemarks?.first {
                    self.parent.centerPlaceDescription = "\(firstPlacemark.country ?? "") \(firstPlacemark.locality ?? "")"
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        MapUIKitView.Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(currentRegion, animated: false)
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: false)
        let annotationDataList = getSavedMusicData()
        
        for annotaionData in annotationDataList {
            let annotation = MusicAnnotation(annotaionData)
            mapView.addAnnotation(annotation)
        }
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if isShowUserLocation  {
            uiView.setRegion(currentRegion, animated: true)
            isShowUserLocation = false
        }
    }
    private func getSavedMusicData() -> [MusicItem]{
        var tempMusicList: [MusicItem] = []
        MusicItemDataModel.shared.musicList.forEach{ music in
            tempMusicList.append(music)
        }
        return tempMusicList
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
