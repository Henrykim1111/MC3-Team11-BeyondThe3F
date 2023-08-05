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
                        EditMapUIView(
                            mapView: $mapViewModel.mapView,
                            userLocation: $mapViewModel.userLocation,
                            region: $mapViewModel.region,
                            selectedCoordinate: $mapViewModel.selectedCoordinate,
                            selectedPositionDescription: $mapViewModel.selectedPositionDescription,
                            isRegionSetted: $mapViewModel.isRegionSetted,
                            showDeniedLocationStatus: $mapViewModel.isLocationAuthDenied,
                            isLocationEnabled: $mapViewModel.isLocationEnabled,
                            locationInfo: $mapViewModel.locationInfo)
                        VStack {
                            Image("pinLocation")
                            Spacer()
                                .frame(height: 30)
                        }
                        ScopeButtonBoxView
                    } else {
                        MapSearchResultView
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
                                        setLocationDataToUpdateModel()
                                    })
                            } label: {
                                PrimaryButtonComponentView(
                                    buttonType: .recordThePosition,
                                    backgroundColor: .primary)
                            }
                            
                        case .backward:
                            Button {
                                setLocationDataToUpdateModel()
                                dismiss()
                            } label: {
                                PrimaryButtonComponentView(
                                    buttonType: .recordThePosition,
                                    backgroundColor: .primary)
                            }
                        }
                    } else {
                        PrimaryButtonComponentView(
                            buttonType: .recordThePosition,
                            backgroundColor: .secondaryDark)
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
                    mapViewModel.isRegionSetted = true
                    mapViewModel.showUserLocation()
                default: break
                }
            }
        }
        
    }
    private func setLocationDataToUpdateModel(){
        musicItemUpdateViewModel.musicItemshared.longitude = mapViewModel.mapView.centerCoordinate.longitude
        musicItemUpdateViewModel.musicItemshared.latitude = mapViewModel.mapView.centerCoordinate.latitude
        musicItemUpdateViewModel.musicItemshared.locationInfo = mapViewModel.locationInfo
    }
    
}

extension EditMapPositionView {
    var ScopeButtonBoxView: some View {
        VStack {
            Spacer()
            HStack{
                if mapViewModel.isLocationAuthDenied {
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
                        mapViewModel.isLocationAuthDenied = false
                        locationManager.getLocationAuth()
                    case .denied, .restricted:
                        mapViewModel.isLocationAuthDenied = true
                    default:
                        mapViewModel.isLocationAuthDenied = false
                        mapViewModel.isRegionSetted = true
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
    
    private var MapSearchResultView: some View {
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

struct EditMapPositionView_Previews: PreviewProvider {
    static var previews: some View {
        EditMapPositionView()
    }
}
