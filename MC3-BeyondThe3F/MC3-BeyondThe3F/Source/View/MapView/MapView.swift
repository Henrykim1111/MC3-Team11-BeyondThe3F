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
    let locationHelper = LocationManager.shared
    let musicItemDataModel = MusicItemDataModel.shared
    
    @ObservedObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    @ObservedObject private var mapViewModel = MapViewModel()
    
    @State private var musicList: [MusicItem] = []
    @State var currentRegion = startRegion
    @State private var searchText = ""
    @State private var searchPlaces : [Place] = []
    @State private var annotationDataList: [MusicItem] = []
    @State private var showMusicPlayView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    MapUIKitView(
                        mapView: $mapViewModel.mapView,
                        musicList: $musicList,
                        userLocation: $mapViewModel.userLocation,
                        currentRegion: $mapViewModel.region,
                        isRegionSetted: $mapViewModel.isRegionSetted,
                        centerPlaceDescription: $mapViewModel.centerPlaceDescription,
                        locationManager: locationHelper.locationManager
                    )
                    .ignoresSafeArea(.all, edges: .top)
                    
                    VStack {
                        MapSearchComponentView(textInput: $searchText)
                        if searchText == "" {
                            Spacer()
                        } else {
                            if searchPlaces.isEmpty {
                                Spacer()
                                SearchFailureComponentView(failure: .locationSearchFailure)
                            } else {
                                ScrollView {
                                    LazyVStack {
                                        ForEach(searchPlaces, id: \.self) { place in
                                            Button{
                                                moveToSelectedPlaced(place: place)
                                                self.endTextEditing()
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
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color.custom(.background))
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Button {
                                mapViewModel.isRegionSetted = true
                                mapViewModel.showUserLocation()
                            } label: {
                                ScopeButtonComponentView()
                            }
                            
                        }
                        .offset(y: -208)
                        
                    }
                    .padding()
                    .background(
                        withAnimation(.easeInOut(duration: 0.2)) {
                            searchText == "" ? .white.opacity(0) : Color.custom(.background)
                        }
                    )
                    MapMusicInfoView(
                        musicList: $musicList,
                        centerPlaceDescription: $mapViewModel.centerPlaceDescription
                    )
                    
                    VStack {
                        Spacer()
                        if musicItemUpdateViewModel.showToastAddMusic {
                            ToastComponentView(message: "저장되었습니다!")
                        }
                        Button {
                            showMusicPlayView = true
                        } label: {
                            MusicPlayerComponentView()
                        }
                    }
                }
            }
            
            .onAppear {
                locationHelper.getLocationAuth()
                switch locationHelper.locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    mapViewModel.isRegionSetted = true
                    mapViewModel.showUserLocation()
                default: break
                }
            }
            .onChange(of: searchText) { _ in
                getSearchPlace()
            }
            .onChange(of: musicItemDataModel.musicList, perform: { updatedMusicList in
                resetAnnotations()
                musicList = updatedMusicList
            })
            .sheet(isPresented: $showMusicPlayView) {
                MusicPlayView()
                    .presentationDragIndicator(.visible)
            }
            .ignoresSafeArea(.keyboard)
        }
        .accentColor(Color.custom(.white))
    }
    
    private func resetAnnotations(){
        mapViewModel.mapView.removeAnnotations(mapViewModel.mapView.annotations)
        let annotationDataList = getSavedMusicData()
        
        for annotaionData in annotationDataList {
            let annotation = MusicAnnotation(annotaionData)
            mapViewModel.mapView.addAnnotation(annotation)
        }
    }
    private func getSavedMusicData() -> [MusicItem]{
        var tempMusicList: [MusicItem] = []
        MusicItemDataModel.shared.musicList.forEach{ music in
            tempMusicList.append(music)
        }
        return tempMusicList
    }
//    private func showUserLocation(){
//        locationHelper.locationManager.startUpdatingLocation()
//        if let userCurrentLocation = locationHelper.locationManager.location?.coordinate {
//            mapViewModel.userLocation = userCurrentLocation
//        }
//        currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapViewModel.userLocation.latitude, longitude: mapViewModel.userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
//    }
    
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
        
        mapViewModel.mapView.setRegion(coordinateRegion, animated: false)
        mapViewModel.mapView.setVisibleMapRect(mapViewModel.mapView.visibleMapRect, animated: false)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
