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
    @ObservedObject private var mapSearchViewModel = MapSearchViewModel()
    @ObservedObject private var mapViewModel = MapViewModel()
    
    @State private var musicList: [MusicItem] = []
    @State var currentRegion = startRegion
    @State private var searchText = ""
    
    @State private var annotationDataList: [MusicItem] = []
    @State private var showMusicPlayView = false
    
    var body: some View {
        NavigationStack {
            
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
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 0)
                    MapSearchComponentView(textInput: $searchText)
                    if !searchText.isEmpty {
                        if mapSearchViewModel.searchPlaces.isEmpty {
                            SearchFailureComponentView(failure: .locationSearchFailure)
                        } else {
                            self.MapSearchResultView
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            mapViewModel.isRegionSetted = true
                            mapViewModel.showUserLocation()
                        } label: {
                            ScopeButtonComponentView()
                        }
                        
                    }
                    Spacer()
                        .frame(height: 210)
                    
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
            .onAppear {
                locationHelper.getLocationAuth()
                switch locationHelper.locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    mapViewModel.isRegionSetted = true
                    mapViewModel.showUserLocation()
                default: break
                }
            }
            .onChange(of: searchText) { newSearchTerm in
                mapSearchViewModel.getSearchPlace(newSearchTerm)
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
    
    private func moveToSelectedPlaced(place: Place){
        searchText = ""
        guard let coordinate = place.place.location?.coordinate else { return }

        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapViewModel.mapView.setRegion(coordinateRegion, animated: false)
        mapViewModel.mapView.setVisibleMapRect(mapViewModel.mapView.visibleMapRect, animated: false)
    }
}

extension MapView {
    private var MapSearchResultView: some View {
        ScrollView {
            LazyVStack {
                ForEach(mapSearchViewModel.searchPlaces, id: \.self) { place in
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
        .background(Color.custom(.background))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
