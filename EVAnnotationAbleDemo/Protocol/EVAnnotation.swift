//
//  EVAnnotation.swift
//  EVAnnotationAbleDemo
//
//  Created by mc on 2017/4/6.
//  Copyright © 2017年 ccclubs. All rights reserved.
//

import UIKit

//标注Model类型
protocol EVAnnotationModelType: Equatable{
  var evCoordinate:CLLocationCoordinate2D { get }
  var id: Int { get }
  var evName: String { get }
  
}


//标注
class EVAnnotation<T:EVAnnotationModelType>: MAPointAnnotation {
  
  var model:T?{
    didSet{
      if let model = model {
        coordinate = model.evCoordinate
      }
    }
  }
  
  class func instance(model:T) -> EVAnnotation<T>{
    let annotation = EVAnnotation()
    annotation.model = model
    return annotation
  }
}

