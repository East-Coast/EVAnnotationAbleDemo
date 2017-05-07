//
//  ZZHMapViewController.swift
//  Evnet
//
//  Created by mc on 2016/11/19.
//  Copyright © 2016年 ccclubs. All rights reserved.
//

import UIKit
import SnapKit

typealias SendPOIClosure = (_ poi:AMapPOI)->Void

class ZZHMapViewController: UIViewController {

    var mapView:MAMapView = MAMapView()
    var search:AMapSearchAPI = AMapSearchAPI()
    var sendPoiClosure:SendPOIClosure?
    var searchArray:[AMapTip]?{
        didSet{
            if searchArray?.count ?? 0 > 0 {
                searchTableView.snp.updateConstraints({ (make) in
                    make.height.equalTo(height/3)
                })
            }else{
                searchTableView.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
            }
            searchTableView.reloadData()
        }
    }
    var poiArray:[AMapPOI]?{
        didSet{
            //刷新POI列表
            poiTableView.reloadData()
        }
    }
    override func viewDidLoad() {
      
        super.viewDidLoad()
        setupUI()
    }
    
    
    
  
    func setupUI(){
        
        self.title = "选择地址"
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        let imageView = UIImageView(image: UIImage(named: "mapview-center"))
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(poiTableView)
        view.addSubview(imageView)
        view.addSubview(searchTableView)
       
        searchBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        }
        
        
        mapView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(mapView)
            make.size.equalTo(CGSize(width: 84, height: 84))
        }
        
        poiTableView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        searchTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
     
        
    }
    
  
    fileprivate lazy var searchBar:UISearchBar = {
       
        let bar = UISearchBar()
        bar.delegate = self
        bar.backgroundColor = UIColor.cyan
        bar.placeholder = "请输入地址"
        return bar
    }()
    
  
        
  
    fileprivate lazy var searchTableView:UITableView = {
    
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    fileprivate lazy var poiTableView:UITableView = {
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
  
  override func viewWillAppear(_ animated: Bool) {
    configAppearMapView()
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    configDisappearMapView()
    super.viewWillDisappear(animated)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        view.endEditing(true)
    }
    
}

extension ZZHMapViewController:MAMapViewDelegate{
  
  func configAppearMapView() {
    
    search.delegate = self
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    
  }
  
  func configDisappearMapView() {
    
    mapView.clearDisk()
    search.delegate = nil
    mapView.delegate = nil
    mapView.showsUserLocation = false
    mapView.userTrackingMode = .none
    mapView.removeFromSuperview()
  }
  
  func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
   
    //POI周边搜索
    let poiRequest = AMapPOIAroundSearchRequest()
    let center = mapView.region.center
    poiRequest.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
    poiRequest.radius = 1000
    poiRequest.requireExtension = true
    search.aMapPOIAroundSearch(poiRequest)
  }
  
    
}

extension ZZHMapViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 1 {
            let tipRequest = AMapInputTipsSearchRequest()
            tipRequest.keywords = searchText
            search.aMapInputTipsSearch(tipRequest)
        }
    }
    
}

extension ZZHMapViewController:AMapSearchDelegate{
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        poiArray = response.pois
    }
    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        searchArray = response.tips
    }
}

extension ZZHMapViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case poiTableView:     //POI列表
            return poiArray?.count ?? 0
            
        case searchTableView:  //Tip列表
            return searchArray?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch tableView {
            
        case poiTableView:     //POI列表
            var cell = tableView.dequeueReusableCell(withIdentifier: "POIcell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "POIcell")
            }
            let poi = poiArray?[indexPath.row]
            cell?.textLabel?.text = poi?.name
            cell?.detailTextLabel?.text = poi?.address
            cell?.imageView?.image = UIImage(named: "usually_location_16")
            return cell!
            
        case searchTableView:  //Tip列表
            var cell = tableView.dequeueReusableCell(withIdentifier: "TipCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TipCell")
            }
            let tip = searchArray?[indexPath.row]
            cell?.textLabel?.text = tip?.name
            cell?.detailTextLabel?.text = tip?.address
            cell?.backgroundColor = UIColor.clear
            return cell!
        
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        switch tableView {
            
        case poiTableView:     //POI列表
            
            let poi = poiArray?[indexPath.row]
            
            if let  sendPoiClosure = sendPoiClosure{
                sendPoiClosure(poi!)
            }
            navigationController!.popViewController(animated: true)
            
        case searchTableView:  //Tip列表
            let tip = searchArray?[indexPath.row]
            searchBar.text = tip?.name
            searchTableView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
            var location:CLLocationCoordinate2D?
            if let point = tip?.location  {
                
                 location = CLLocationCoordinate2D(latitude: CLLocationDegrees(point.latitude), longitude: CLLocationDegrees(point.longitude))
            }else{
                //解决没有经纬度的情况
                let point1 = searchArray?[indexPath.row + 1].location
                location = CLLocationCoordinate2D(latitude: CLLocationDegrees(point1!.latitude), longitude: CLLocationDegrees(point1!.longitude))
            }
            
            
            mapView.setCenter(location!, animated: true)
            
        default:
            break
        }
    }
}
