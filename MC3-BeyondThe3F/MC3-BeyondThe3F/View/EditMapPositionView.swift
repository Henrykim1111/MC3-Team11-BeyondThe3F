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
    @State private var isMoving = true
    @State private var isPresented = true
    @State private var locationManager = LocationManager.shared
    @State private var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.70564024126748, longitude: 142.37968945214223), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    @State private var textInput = ""
    @State private var selectedCoordinate = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State private var selectedPositionDescription = "저장하고 싶은 위치를 선택하세요"
    @State private var isShowUserLocation = false
    @State private var showDeniedLocationStatus = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                HStack {
                    SFImageComponentView(symbolName: .chevronBack, color: .white)
                    Spacer()
                        .frame(width: 20)
                    TextField("위치를 검색해보세요", text: $textInput)
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
                    EditMapUIView(
                        userLocation: $userLocation,
                        userRegion: $region,
                        selectedCoordinate: $selectedCoordinate,
                        selectedPositionDescription: $selectedPositionDescription,
                        isShowUserLocation: $isShowUserLocation
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
                                .shadow(color: Color.custom(.gray600), radius: 4, x:3, y: 3)
                            }
                        }
                    }
                    .padding()
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
        }
    }
    
    private func showUserLocation(){
        locationManager.locationManager.startUpdatingLocation()
        if let userCurrentLocation = locationManager.locationManager.location?.coordinate {
            userLocation = userCurrentLocation
        }
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    }
}

struct EditMapPositionView_Previews: PreviewProvider {
    static var previews: some View {
        EditMapPositionView()
    }
}


struct EditMapUIView: UIViewRepresentable{
    @State private var region = startRegion
    private let locationManager = LocationManager.shared.locationManager
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var userRegion: MKCoordinateRegion
    @State private var view = MKMapView()
    @Binding var selectedCoordinate : CLLocationCoordinate2D
    @Binding var selectedPositionDescription: String
    @Binding var isShowUserLocation: Bool
    
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
        view.delegate = context.coordinator
        view.setRegion(region, animated: false)
        view.mapType = .standard
        view.showsUserLocation = true
        view.setUserTrackingMode(.follow, animated: true)


        selectedCoordinate = view.centerCoordinate
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if isShowUserLocation  {
            uiView.setRegion(userRegion, animated: true)
            isShowUserLocation = false
        }
    }
}
