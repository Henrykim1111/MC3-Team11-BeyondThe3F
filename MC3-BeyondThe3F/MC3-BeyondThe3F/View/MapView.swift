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
    
    @State private var draggedYOffset = 500.0
    @State private var accumulatedYOffset = 500.0
    private let maxHeight = 500.0
    private let minHeight = 100.0
    
    let locationHelper = LocationHelper.shared
    @State private var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State var region = startRegion
    @State var isShowUserLocation = false
    
    @State private var searchText = ""
    @State private var searchPlaces : [Place] = []
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                MapUIKitView(
                    mapView: $mapView,
                    musicList: $musicList,
                    locationManager: locationHelper.locationManager,
                    userLocation: $userLocation,
                    userRegion: $region,
                    isShowUserLocation: $isShowUserLocation
                )
                VStack {
                    Spacer()
                    VStack{
                        VStack{
                            HStack {
                                Spacer()
                                Rectangle()
                                    .foregroundColor(Color.custom(.white))
                                    .frame(width: 40, height: 5)
                                    .opacity(0.4)
                                    .cornerRadius(3)
                                Spacer()
                            }
                            HStack {
                                if musicList.isEmpty {
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                        .foregroundColor(Color.custom(.white))
                                        .padding(.trailing, 15)
                                } else {
                                    Image("annotaion0")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                        .padding(.trailing, 15)
                                }

                                VStack(alignment: .leading){
                                    Text("장소")
                                        .title2(color: .white)
                                        .padding(.bottom, 2)
                                    Text("\(musicList.count)곡 수집")
                                        .body1(color: .white)
                                }
                                Spacer()
                            }
                            .padding(.bottom,15)
                            
                            HStack {
                                MidButtonComponent()
                                Spacer()
                                MidButtonComponent(sfImageName: .shuffle, name: .임의재생)
                            }
                        }
                        .padding()
                        
                        Divider()
                            .overlay(Color.custom(.white))
                        ScrollView {
                            VStack{
                                ForEach(musicList) { musicItem in
                                    MusicListRowView(
                                        imageName: (musicItem.savedImage != nil) ? musicItem.savedImage! :  "annotation0",
                                        songName: musicItem.songName,
                                        artistName: musicItem.artistName,
                                        musicListRowType: .saved,
                                        buttonEllipsisAction: {
                                            
                                        }
                                    )
                                }
                            }
                        }
                        .padding()
                        .frame(minHeight: 300)
                    }
                    .frame(idealWidth: 390, maxWidth: 390)
                    .frame(height: 600)
                    .background(Color.custom(.background))
                    .presentationDragIndicator(.visible)
                    .offset(y: draggedYOffset)
                    .gesture(drag)
                }
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
                        .frame(width: 350, height: 300)
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
                }
                .padding()
                .background(
                    withAnimation(.easeInOut(duration: 0.2)) {
                        searchText == "" ? .green.opacity(0) : Color.custom(.background)
                    }

                )
            }
            MusicPlayerComponentView()
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            locationHelper.getLocationAuth()
        }
        .onChange(of: searchText) { newValue in
            getSearchPlace()
        }
        
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                let caculatedValue = accumulatedYOffset + gesture.translation.height
                if caculatedValue > maxHeight {
                    draggedYOffset = maxHeight
                } else if caculatedValue < minHeight {
                    draggedYOffset = minHeight
                } else {
                    draggedYOffset = caculatedValue
                }
            }
            .onEnded { gesture in
                let caculatedValue = accumulatedYOffset + gesture.translation.height
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    if caculatedValue > maxHeight {
                        accumulatedYOffset = maxHeight
                    } else if caculatedValue < minHeight {
                        accumulatedYOffset = minHeight
                    } else {
                        if caculatedValue > 400 {
                            accumulatedYOffset = maxHeight
                        } else if caculatedValue > 200 {
                            accumulatedYOffset = 300.0
                        } else {
                            accumulatedYOffset = minHeight
                        }
                        draggedYOffset = accumulatedYOffset
                    }
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
    @State var region = startRegion
    @Binding var musicList: [MusicItemVO]
    let locationManager: CLLocationManager
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var userRegion: MKCoordinateRegion
    @Binding var isShowUserLocation: Bool

    private let annotaionDataList = musicItemVODummyData

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
        
        for annotaionData in annotaionDataList {
            let annotation = MusicAnnotation(annotaionData)
            mapView.addAnnotation(annotation)
        }
        
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

