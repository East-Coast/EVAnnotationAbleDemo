//
//  EVAnnotationViewController.swift
//  EVAnnotationAbleDemo
//
//  Created by mc on 2017/4/6.
//  Copyright © 2017年 ccclubs. All rights reserved.
//

import UIKit

//屏幕的宽高
let height = UIScreen.main.bounds.height
let width = UIScreen.main.bounds.size.width

extension AMapPOI : EVAnnotationModelType{
  
  var id: Int { return Int(uid) ?? 0}
  var evName: String { return name }
  var evCoordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
  }
}

class EVAnnotationViewController: UIViewController , EVAnnotationAble{
  
  var mapView: MAMapView?
  var list: [AMapPOI]?{
    didSet{
      self.addEVAnnotations(models: list)
    }
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "地图"
        view.backgroundColor = UIColor.white
        configMapView()
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    list = DataManager.shared().dataList
  }
  
  func configMapView(){
    mapView = MAMapView(frame: CGRect(x: 0, y:64, width: view.frame.width, height: view.frame.height - 64))
    mapView?.mapType = MAMapType.standard
    mapView?.isRotateEnabled = false
    mapView?.isRotateCameraEnabled = false
    mapView?.isSkyModelEnabled = false
    mapView?.showsScale = false
    mapView?.showsCompass = false
    mapView?.showsUserLocation = true
    mapView?.delegate = self
    view.addSubview(mapView!)
  }
  
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
  
  //设置显示标注的图标
  func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
    
    if let annotation = annotation as? EVAnnotation<T> {
      
      let annotationIdentifier = "EVAnnimationIdentifier"
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? EVAnnotationView
      
      if annotationView == nil{
        annotationView = EVAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
      }
      annotationView?.centerOffset = CGPoint(x: 0, y: -20)
      return annotationView
    }
    
    return nil
  }
    

}




