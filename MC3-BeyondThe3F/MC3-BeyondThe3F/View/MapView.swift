//
//  MapView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var musicList: [MusicItemVO] = []
    @State private var isMoving = true
    @State private var draggedYOffset = 0.0
    @State private var accumulatedYOffset = 0.0
    @State var locationManager = CLLocationManager()
    @State var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.70564024126748, longitude: 142.37968945214223), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    let maxHeight = 500.0
    let minHeight = 100.0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                MapUIKitView(
                    musicList: $musicList,
                    locationManager: $locationManager,
                    userLocation: $userLocation,
                    userRegion: $region
                )
                VStack {
                    Spacer()
                    VStack{
                        VStack{
                            HStack {
                                Image("annotaion0")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    .padding(.trailing, 15)
                                VStack(alignment: .leading){
                                    Text("장소")
                                        .title2(color: .white)
                                        .padding(.bottom, 2)
                                    Text("6곡 수집")
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
                                ForEach(musicItemVODummyData) { musicItem in
                                    MusicListRowView(
                                        imageName: (musicItem.savedImage != nil) ? musicItem.savedImage! :  "annotation0",
                                        songName: musicItem.songName,
                                        artistName: musicItem.artistName)
                                }
                            }
                        }
                        .padding()
                        
                    }
                    .frame(idealWidth: 390, maxWidth: 390)
                    .frame(height: .infinity)
                    .background(Color.custom(.background))
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .offset(y: draggedYOffset)
                    .gesture(
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
                                if caculatedValue > maxHeight {
                                    accumulatedYOffset = maxHeight
                                } else if caculatedValue < minHeight {
                                    accumulatedYOffset = minHeight
                                } else {
                                    accumulatedYOffset = caculatedValue
                                }
                                
                                
                            }
                    )
                }
                VStack {
                    Spacer()
                        .frame(height: 30)
                    MusicSearchView()
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            locationManager.startUpdatingLocation()
                               if let userCurrentLocation = locationManager.location?.coordinate {
                                   userLocation = userCurrentLocation
                               }
                            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
                        } label: {
                            ScopeButtonComponentView()
                        }
                    }
                }
                .padding()
            }
            MusicPlayerComponentView()
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
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
    @State var region = startRegion
    @Binding var musicList: [MusicItemVO]
    @Binding var locationManager: CLLocationManager
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var userRegion: MKCoordinateRegion

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
        
        /// 화면 이동중 musicList reset
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
        let view = MKMapView()
        view.delegate = context.coordinator
        view.setRegion(region, animated: false)
        view.mapType = .standard
        
        for annotaionData in annotaionDataList {
            let annotation = MusicAnnotation(annotaionData)
            view.addAnnotation(annotation)
        }
        view.showsUserLocation = true
        view.setUserTrackingMode(.follow, animated: true)
        
        
        return view
        
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(userRegion, animated: true)
    }
    
    
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}

