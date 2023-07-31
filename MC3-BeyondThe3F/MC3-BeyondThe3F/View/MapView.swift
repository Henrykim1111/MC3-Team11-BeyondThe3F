//
//  MapView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI
import MapKit
import CoreLocation

struct Place: Identifiable, Hashable {
    var id = UUID().uuidString
    var place: CLPlacemark
}

struct MapView: View {
    @State private var mapView = MKMapView()
    @State private var musicList: [MusicItem] = []
    @State private var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State var currentRegion = startRegion
    @State var isShowUserLocation = false
    @State private var searchText = ""
    @State private var searchPlaces : [Place] = []
    @State private var annotationDataList: [MusicItem] = []
    @State private var centerPlaceDescription = "장소"
    
    @State private var showMusicPlayView = false
    
    let locationHelper = LocationManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    MapUIKitView(
                        mapView: $mapView,
                        musicList: $musicList,
                        userLocation: $userLocation,
                        currentRegion: $currentRegion,
                        isShowUserLocation: $isShowUserLocation,
                        centerPlaceDescription: $centerPlaceDescription,
                        locationManager: locationHelper.locationManager
                    )
                    VStack {
                        Spacer()
                            .frame(height: 30)
                        MapSearchComponentView(textInput: $searchText)
                        if searchText == "" {
                            Spacer()
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(searchPlaces, id: \.self) { place in
                                        Button{
                                            moveToSelectedPlaced(place: place)
                                        } label: {
                                            HStack {
                                                Text("\(place.place.name ?? "no name")")
                                                    .body1(color: .white)
                                                Spacer()
                                            }
                                            .frame(height: 56)
                                        }
                                    }
                                }
                            }
                            .frame(width: .infinity)
                            .frame(height: 200)
                            .background(Color.custom(.background))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button {
                                isShowUserLocation = true
                                showUserLocation()
                            } label: {
                                ScopeButtonComponentView()
                            }
                        }
                        Spacer()
                            .frame(height: 120)
                    }
                    .padding()
                    .background(
                        withAnimation(.easeInOut(duration: 0.2)) {
                            searchText == "" ? .white.opacity(0) : Color.custom(.background)
                        }
                    )
                    MapMusicInfoView(
                        musicList: $musicList,
                        centerPlaceDescription: $centerPlaceDescription
                    )
                }
                Button {
                    showMusicPlayView = true
                } label: {
                    MusicPlayerComponentView()
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .onAppear {
                locationHelper.getLocationAuth()
            }
            .onChange(of: searchText) { newValue in
                getSearchPlace()
            }
            .sheet(isPresented: $showMusicPlayView) {
                MusicPlayView()
                    .presentationDragIndicator(.visible)
            }
        }
    }
        
    private func showUserLocation(){
        locationHelper.locationManager.startUpdatingLocation()
        if let userCurrentLocation = locationHelper.locationManager.location?.coordinate {
            userLocation = userCurrentLocation
        }
        currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    }
    
    private func getSearchPlace(){
        searchPlaces.removeAll()
                
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.searchPlaces = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }
    
    private func moveToSelectedPlaced(place: Place){
        searchText = ""
        guard let coordinate = place.place.location?.coordinate else { return }

        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
}

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
            self.setMusicList([])
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
        mapView.setUserTrackingMode(.follow, animated: true)
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
