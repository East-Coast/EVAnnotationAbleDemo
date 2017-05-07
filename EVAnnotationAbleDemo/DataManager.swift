//
//  DataManager.swift
//  EVAnnotationAbleDemo
//
//  Created by mc on 2017/4/6.
//  Copyright © 2017年 ccclubs. All rights reserved.
//

import UIKit

class DataManager {
  
  static let manager = DataManager()
  static func shared() -> DataManager{
    return manager
  }
  
  var dataList = [AMapPOI]()

}
