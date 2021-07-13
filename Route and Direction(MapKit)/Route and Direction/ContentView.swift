//
//  ContentView.swift
//  Route and Direction
//
//  Created by rutik maraskolhe on 12/07/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        
        
        mapView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct mapView: UIViewRepresentable {
    
    func makeCoordinator() -> mapView.Coordinator {
        return mapView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<mapView>) -> MKMapView {
        
        let map = MKMapView()
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567)
        let destinationCoordiante = CLLocationCoordinate2D(latitude: 19.9615, longitude: 79.2961)
        
        let region = MKCoordinateRegion(center: sourceCoordinate,latitudinalMeters: 100000, longitudinalMeters: 100000)
        
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = sourceCoordinate
        sourcePin.title = "Source"
        map.addAnnotation(sourcePin)
        
        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destinationCoordiante
        destinationPin.title = "Destination"
        map.addAnnotation(destinationPin)
        
        
        map.region = region
        map.delegate = context.coordinator
        
        let req = MKDirections.Request()
        
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordiante))
        
        let directions  = MKDirections(request: req)
        
        directions.calculate { (direct, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            
            let polyline = direct?.routes.first?.polyline
            map.addOverlay(polyline!)
            map.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
        }
        
        return map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<mapView>)  {
        
    }
    
    class Coordinator :  NSObject,MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .orange
            render.lineWidth = 4
            return render
        }
        
    }
    
}
