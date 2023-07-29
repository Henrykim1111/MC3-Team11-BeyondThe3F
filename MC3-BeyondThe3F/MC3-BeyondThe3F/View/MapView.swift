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
    
    @State private var musicList: [MusicItemVO] = []
    
    let locationHelper = LocationManager.shared
    @State private var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State var region = startRegion
    @State var isShowUserLocation = false
    
    @State private var searchText = ""
    @State private var searchPlaces : [Place] = []
    @State private var showMusicPlayView = false
    @State private var annotationDataList: [MusicItemVO] = []
    
    let mainDataModel = MainDataModel.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    MapUIKitView(
                        mapView: $mapView,
                        musicList: $musicList,
                        userLocation: $userLocation,
                        userRegion: $region,
                        isShowUserLocation: $isShowUserLocation,
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
                                }
                            }
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
                            searchText == "" ? .green.opacity(0) : Color.custom(.background)
                        }
                    )
                    MapMusicInfoView(musicList: $musicList)
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
                annotationDataList = getSavedMusicData()
            }
            .onChange(of: searchText) { newValue in
                getSearchPlace()
            }
            .onChange(of: annotationDataList, perform: { newValue in
                
                for annotaionData in annotationDataList {
                    let annotation = MusicAnnotation(annotaionData)
                    mapView.addAnnotation(annotation)
                }
            })
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
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
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
    private func getSavedMusicData() -> [MusicItemVO]{
        var tempMusicVOList: [MusicItemVO] = []
        MainDataModel.shared.getData.forEach { mainVO in
            for music in mainVO.musicList {
                tempMusicVOList.append(
                    MusicItemVO(musicId: music.musicId ?? "", latitude: music.latitude, longitude: music.longitude, playedCount: 0, songName: music.songName ?? "undefined", artistName: music.artistName ?? "undefined", generatedDate: music.generatedDate ?? Date())
                )
            }
        }
        return tempMusicVOList
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

let musicItemVODummyData:[MusicItemVO] = [
    MusicItemVO(musicId: "1004836383", latitude: 43.70564024126748,longitude: 142.37968945214223,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotationTest"),
    MusicItemVO(musicId: "1004836383", latitude: 43.81257464206404,longitude: 142.82112322464369,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotaion1"),
    MusicItemVO(musicId: "1004836383", latitude: 43.38416585162576,longitude: 141.7252598737476,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotaion2"),
    MusicItemVO(musicId: "1004836383", latitude: 45.29168643283501,longitude: 141.95286751470724,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotaion3")
]
let startRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64422936785126, longitude: 142.39329541313924), span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2))

struct MapUIKitView: UIViewRepresentable {
    @Binding var mapView: MKMapView
    @Binding var musicList: [MusicItemVO]
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var userRegion: MKCoordinateRegion
    @Binding var isShowUserLocation: Bool
    
    @State var region = startRegion
    
    
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
            var newAnnotaionList: [MusicItemVO] = []
            for annotation in mapView.visibleAnnotations() {
                if let defaultAnnotation = annotation as? MusicAnnotation {
                    newAnnotaionList.append(defaultAnnotation.getMusicItemFromAnnotation())
                }
            }
            setMusicList(newAnnotaionList)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
            case is MusicAnnotation:
                return MusicAnnotationView(annotation: annotation, reuseIdentifier: MusicAnnotationView.ReuseID)
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
        private func setMusicList(_ newMusicList: [MusicItemVO]) {
            parent.musicList = newMusicList
        }
    }

    func makeCoordinator() -> Coordinator {
        MapUIKitView.Coordinator(self)
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
        if isShowUserLocation  {
            uiView.setRegion(userRegion, animated: true)
            isShowUserLocation = false
        }
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}

