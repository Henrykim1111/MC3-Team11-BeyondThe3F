//
//  EditMapPoisitionView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct EditMapPositionView: View {
    @State private var mapView = MKMapView()
    @Environment(\.presentationMode) var presentationMode
    @State private var isMoving = true
    @State private var locationManager = LocationManager.shared
    @State private var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State private var region: MKCoordinateRegion = startRegion
    @State private var searchTerm = ""
    @State private var selectedCoordinate = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State private var selectedPositionDescription = "저장하고 싶은 위치를 선택하세요"
    @State private var isShowUserLocation = false
    @State private var isRegionSetted = false
    @State private var showDeniedLocationStatus = false
    @State private var searchPlaces : [Place] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        SFImageComponentView(symbolName: .chevronBack, color: .white)
                    }
                    Spacer()
                        .frame(width: 20)
                    TextField("위치를 검색해보세요", text: $searchTerm)
                        .padding()
                        .background(Color.custom(.secondaryDark))
                        .foregroundColor(Color.custom(.white))
                        .colorScheme(.dark)
                        .accentColor(Color.custom(.white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .cornerRadius(10)
                }
                .padding()
                ZStack {
                    if searchTerm == "" {
                        EditMapUIView(
                            region: $region,
                            userLocation: $userLocation,
                            userRegion: $region,
                            mapView: $mapView,
                            selectedCoordinate: $selectedCoordinate,
                            selectedPositionDescription: $selectedPositionDescription,
                            isShowUserLocation: $isShowUserLocation,
                            isRegionSetted: $isRegionSetted
                        )
                        VStack {
                            Image("pinLocation")
                            Spacer()
                                .frame(height: 30)
                        }
                        VStack {
                            Spacer()
                            HStack{
                                if showDeniedLocationStatus {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text("위치 정보가 거절되었습니다.")
                                                .caption(color: .white)
                                                .padding(.bottom, 5)
                                            Text("설정 - TuneSpot에서 위치 권한을 허용해주세요.")
                                                .caption(color: .white)
                                        }
                                    }
                                    .padding(10)
                                    .background(Color.custom(.background))
                                    .cornerRadius(10)
                                }
                                
                                Spacer()
                                Button {
                                    switch locationManager.locationManager.authorizationStatus {
                                    case .notDetermined:
                                        showDeniedLocationStatus = false
                                        locationManager.getLocationAuth()
                                    case .denied, .restricted:
                                        showDeniedLocationStatus = true
                                    default:
                                        showDeniedLocationStatus = false
                                        isShowUserLocation = true
                                        showUserLocation()
                                    }
                                    
                                } label: {
                                    ScopeButtonComponentView(
                                        foregroundColor: Color.custom(.white),
                                        backgroundColor: Color.custom(.background))
                                    .shadow(color: Color.custom(.background), radius: 4, x:3, y: 3)
                                }
                            }
                        }
                        .padding()
                    } else {
                        ScrollView {
                            VStack {
                                withAnimation(.easeInOut(duration: 0.2)) {
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
                                Spacer()
                            }
                        }
                        
                        .background(Color.custom(.background))
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    Text("\(selectedPositionDescription)")
                        .headline(color: .white)
                    Spacer()
                    NavigationLink {
                        EditDateView()
                    } label: {
                        PrimaryButtonComponentView(buttonType: .recordThePosition, backgroundColor: .primary)
                    }
                }
                .frame(maxHeight: 200)
                .padding()
            }
            .background(Color.custom(.background))
            .preferredColorScheme(.dark)
            .onChange(of: searchTerm) { newValue in
                getSearchPlace()
            }
        }
    }
    
    private func showUserLocation(){
        locationManager.locationManager.startUpdatingLocation()
        if let userCurrentLocation = locationManager.locationManager.location?.coordinate {
            userLocation = userCurrentLocation
        }
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    }
    private func getSearchPlace(){
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
    
    private func moveToSelectedPlaced(place: Place){
        searchTerm = ""
        
        guard let coordinate = place.place.location?.coordinate else { return }

        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        isRegionSetted = true
        region = coordinateRegion
    }
}

struct EditMapPositionView_Previews: PreviewProvider {
    static var previews: some View {
        EditMapPositionView()
    }
}


struct EditMapUIView: UIViewRepresentable{
    @Binding var region: MKCoordinateRegion
    private let locationManager = LocationManager.shared.locationManager
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var userRegion: MKCoordinateRegion
    @Binding var mapView: MKMapView
    @Binding var selectedCoordinate : CLLocationCoordinate2D
    @Binding var selectedPositionDescription: String
    @Binding var isShowUserLocation: Bool
    @Binding var isRegionSetted: Bool
    
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
        }
        
        private func getSearchPlace(coord: CLLocationCoordinate2D){
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { placemarks, e in
                guard e == nil else {
                    return
                }
                
                if let firstPlacemark = placemarks?.first {
                    self.parent.selectedPositionDescription = "\(firstPlacemark.country ?? "") \(firstPlacemark.locality ?? "") \(firstPlacemark.subLocality ?? "")"
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
        selectedCoordinate = mapView.centerCoordinate
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if isShowUserLocation {
            uiView.setRegion(userRegion, animated: true)
            isShowUserLocation = false
        } else if isRegionSetted {
            uiView.setRegion(region, animated: true)
            isRegionSetted = false
        }
    }
}
