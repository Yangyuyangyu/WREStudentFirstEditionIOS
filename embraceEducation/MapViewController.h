//
//  MapViewController.h
//  BanDouApp
//
//  Created by waycubeOXA on 16/3/2.
//  Copyright © 2016年 waycubeOXA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locService;
    BMKPointAnnotation* pointAnnotation;
}
//用户纬度
@property (nonatomic, copy, readonly) NSString *locaLatitude;
@property (nonatomic, copy) NSString *loati;//纬度中间变量

//用户经度
@property (nonatomic, copy, readonly) NSString *locaLongitude;
@property (nonatomic, copy) NSString *longi;//经度中间变量

@property (nonatomic, strong, readonly)BMKGeoCodeSearch* geocodesearch;//地图编码

@property (nonatomic, strong, readonly)BMKRouteSearch* routesearch;//路径规划

@end
