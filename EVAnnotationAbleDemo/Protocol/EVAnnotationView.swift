//
//  EVAnnotationView.swift
//  EVAnnotationAbleDemo
//
//  Created by mc on 2017/4/6.
//  Copyright © 2017年 ccclubs. All rights reserved.
//

import UIKit


protocol EVImageType {
  var selectedImg:String { get }
  var img:String { get }
}

extension EVImageType {
  var selectedImg:String { return "home-selectedOutlet" }
  var img:String { return "home-outlet" }
}


class EVAnnotationView: MAAnnotationView , EVImageType{
  
  override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    
    image = UIImage(named: img)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //设置标注选中状态
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      image = UIImage(named: selectedImg)
    }else{
      image = UIImage(named: img)
    }
    
  }

}


