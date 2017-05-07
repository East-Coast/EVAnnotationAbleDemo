//
//  EVAnnotationType.swift
//  EVAnnotationAbleDemo
//
//  Created by mc on 2017/4/5.
//  Copyright © 2017年 ccclubs. All rights reserved.
//

import Foundation

//具备添加标注和显示标注详情的协议
protocol EVAnnotationAble: MAMapViewDelegate{
  associatedtype T:EVAnnotationModelType
  var list:[T]? { get }
  var mapView: MAMapView? { get }
  
  func addEVAnnotations(models:[T]?)
}



extension EVAnnotationAble where Self:UIViewController {
  
  //添加标注
  func addEVAnnotations(models: [AMapPOI]?) {
    mapView?.removeAnnotations(mapView?.annotations)
    let annotations = models?.map { EVAnnotation.instance(model: $0) }
    mapView?.addAnnotations(annotations)
    
    mapView?.showAnnotations(annotations, animated: true)
  }
  
 
  
}











