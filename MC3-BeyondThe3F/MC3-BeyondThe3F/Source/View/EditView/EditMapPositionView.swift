//
//  EditMapPoisitionView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/23.
//

import SwiftUI
import MapKit
import CoreLocation

enum NextProcess {
    case backward
    case forward
}

struct EditMapPositionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var musicUpdateViewModel = MusicItemUpdateViewModel.shared
    @ObservedObject private var mapSearchViewModel = MapSearchViewModel()
    @ObservedObject private var mapViewModel = MapViewModel()
    @ObservedObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    let locationManager = LocationManager.shared
    
    @State private var searchTerm = ""
    var nextProcess: NextProcess = .forward
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                HStack {
                    Button {
                        dismiss()
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
                    if searchTerm.isEmpty {
                        EditMapUIView()
                        VStack {
                            Image("pinLocation")
                            Spacer()
                                .frame(height: 30)
                        }
                        scopeButtonBoxView
                    } else {
                        mapSearchResultView
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    Text("\(mapViewModel.selectedPositionDescription)")
                        .headline(color: .white)
                        .lineLimit(2)
                        .padding(.top, 24)
                    Spacer()
                    if mapViewModel.isLocationEnabled {
                        switch nextProcess {
                        case .forward:
                            NavigationLink {
                                EditDateView(nextProcess: .forward)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        musicUpdateViewModel.musicItemshared.longitude = mapViewModel.mapView.centerCoordinate.longitude
                                        musicUpdateViewModel.musicItemshared.latitude = mapViewModel.mapView.centerCoordinate.latitude
                                        musicUpdateViewModel.musicItemshared.locationInfo = mapViewModel.locationInfo
                                    })
                            } label: {
                                PrimaryButtonComponentView(buttonType: .recordThePosition, backgroundColor: .primary)
                            }
                            
                        case .backward:
                            Button {
                                musicUpdateViewModel.musicItemshared.longitude = mapViewModel.mapView.centerCoordinate.longitude
                                musicUpdateViewModel.musicItemshared.latitude = mapViewModel.mapView.centerCoordinate.latitude
                                musicUpdateViewModel.musicItemshared.locationInfo = mapViewModel.locationInfo
                                dismiss()
                            } label: {
                                PrimaryButtonComponentView(buttonType: .recordThePosition, backgroundColor: .primary)
                            }
                        }
                    } else {
                        PrimaryButtonComponentView(buttonType: .recordThePosition, backgroundColor: .secondaryDark)
                    }
                }
                .frame(maxHeight: 200)
            }
            .background(Color.custom(.background))
            .preferredColorScheme(.dark)
            .accentColor(Color.custom(.white))
            .onChange(of: searchTerm) { searchTerm in
                mapSearchViewModel.getSearchPlace(searchTerm)
            }
            .onAppear {
                locationManager.getLocationAuth()
                mapViewModel.selectedCoordinate = mapViewModel.mapView.centerCoordinate
                
                switch locationManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    mapViewModel.isShowUserLocation = true
                    mapViewModel.showUserLocation()
                default: break
                }
            }
        }
        
    }
}

extension EditMapPositionView {
    var scopeButtonBoxView: some View {
        VStack {
            Spacer()
            HStack{
                if mapViewModel.showDeniedLocationStatus {
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
                        mapViewModel.showDeniedLocationStatus = false
                        locationManager.getLocationAuth()
                    case .denied, .restricted:
                        mapViewModel.showDeniedLocationStatus = true
                    default:
                        mapViewModel.showDeniedLocationStatus = false
                        mapViewModel.isShowUserLocation = true
                        mapViewModel.showUserLocation()
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
    }
    
    private var mapSearchResultView: some View {
        ScrollView {
            VStack {
                withAnimation(.easeInOut(duration: 0.2)) {
                    ForEach(mapSearchViewModel.searchPlaces, id: \.self) { place in
                        Button{
                            searchTerm = ""
                            mapViewModel.moveToSelectedPlaced(place: place)
                        } label: {
                            HStack {
                                Text("\(place.place.name ?? "no name")")
                                    .body1(color: .white)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
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
    }
}


struct EditMapUIView: UIViewRepresentable{
    @ObservedObject private var mapViewModel = MapViewModel()
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
                self.parent.mapViewModel.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.mapViewModel.selectedCoordinate = mapView.centerCoordinate
            getSearchPlace(coord: mapView.centerCoordinate)
            if parent.mapViewModel.isShowUserLocation {
                parent.mapViewModel.isShowUserLocation = false
            } else if parent.mapViewModel.isRegionSetted {
                parent.mapViewModel.isRegionSetted = false
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
                        self.parent.mapViewModel.selectedPositionDescription = "\(firstPlacemark.country ?? "") \(firstPlacemark.locality ?? "") \(firstPlacemark.subLocality ?? "")"
                    }
                    if firstPlacemark.locality == nil {
                        if firstPlacemark.country == nil {
                            self.parent.mapViewModel.selectedPositionDescription = "설정할 수 없는 위치입니다."
                        } else {
                            self.parent.mapViewModel.selectedPositionDescription = "원하는 위치를 조금 더 자세히 표시해주세요."
                        }
                    } else {
                        self.parent.mapViewModel.locationInfo = "\(firstPlacemark.locality ?? "")"
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        EditMapUIView.Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        mapViewModel.mapView.delegate = context.coordinator
        mapViewModel.mapView.setRegion(mapViewModel.region, animated: false)
        mapViewModel.mapView.mapType = .standard
        mapViewModel.mapView.showsUserLocation = true
        mapViewModel.mapView.setUserTrackingMode(.follow, animated: true)
        
        return mapViewModel.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if mapViewModel.isShowUserLocation {
            uiView.setRegion(mapViewModel.region, animated: true)
        } else if mapViewModel.isRegionSetted {
            uiView.setRegion(mapViewModel.region, animated: true)
            mapViewModel.isRegionSetted = false
        }
    }
}



struct EditMapPositionView_Previews: PreviewProvider {
    static var previews: some View {
        EditMapPositionView()
    }
}
