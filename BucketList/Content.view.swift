//
//  ContentView.swift
//  BucketList
//
//  Created by Ricky David Groner II on 1/3/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var vm = ViewModel()
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        switch vm.isUnlocked {
        case true:
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(vm.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture {
                                    vm.selectedPlace = location
                                }
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        vm.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $vm.selectedPlace) { place in
                    EditView(location: place) {
                        vm.update(location: $0)
                    }
                }
            }
            
        default:
            Button("Unlock Places", action: vm.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
