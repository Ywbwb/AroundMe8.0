//
//  LocationViewController.m
//  AroundMe
//
//  Created by DaiDai on 16/9/5.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationCell.h"
#import "LocationModel.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
@interface LocationViewController ()<CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate,MKMapViewDelegate,AMapSearchDelegate,MBProgressHUDDelegate>
{
    CLLocationManager *_locationManager;
    UITableView *_tableView;
    NSMutableArray *_locationArr;
    MKMapView *_mapView;
    NSInteger segmentIndex;
    NSString *queryText;
    NSString *_area;
    AMapGeoPoint *_location;
    AMapSearchAPI *mapSearch;
    MBProgressHUD *hud;
    UIView *bottomGrayView;
    UIView *buttonWhiteView;
    
}
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _locationManager = [[CLLocationManager alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 64, 64);
    // IconOptions
    //NavbarIconOptionsFlat
    [button setImage:[UIImage imageNamed:@"IconOptions"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [self showProgress];
    [self locationAction];
    [self createListView];
    [self createMapView];
    [self createBottomView];
    //150df518d6c6634e5422e1f35235d23e
    // Do any additional setup after loading the view.
}
- (void)bottomViewBack{
    bottomGrayView.y = kScreenHeight;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    buttonWhiteView.y = kScreenHeight;
    [UIView commitAnimations];
}
- (void)createBottomView{
    bottomGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    bottomGrayView.backgroundColor = [UIColor grayColor];
    bottomGrayView.alpha = 0.4;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomViewBack)];
    [bottomGrayView addGestureRecognizer:ges];
    [self.navigationController.view addSubview:bottomGrayView];
    
    buttonWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0.2 * kScreenHeight)];
    buttonWhiteView.backgroundColor = [UIColor whiteColor];
    
    NSArray *segmentArr = [NSArray arrayWithObjects:@"列表", @"地图", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentArr];
    segment.frame = CGRectMake(50, buttonWhiteView.height/3, kScreenWidth - 100, buttonWhiteView.height/3);
    segment.tintColor = myColor;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SEARCH_HID"]) {
        segmentIndex = 1;
    }else{
        segmentIndex = 0;
    }
    segment.selectedSegmentIndex = segmentIndex;
    [buttonWhiteView addSubview:segment];
    
    [self.navigationController.view addSubview:buttonWhiteView];
    
}

- (void)changeAction{
    bottomGrayView.y = 0;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    buttonWhiteView.y = 0.8 * kScreenHeight;
    [UIView commitAnimations];
    
    
}

- (void)showProgress{

    hud = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    hud.userInteractionEnabled = NO;
//    if (_model.pic) {
//        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_model.pic]];
//    }else{
//        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CategoryGridIconSearchFlat@2x"]];
//    }
//
    hud.delegate = self;
   // hud.color = [UIColor whiteColor];
        
    hud.labelText = @"load";
    
    
    [self.navigationController.view addSubview:hud];
        
    [hud show:YES];

   
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [hud hide:YES];
}

- (void)queryAction{
    [AMapServices sharedServices].apiKey = @"150df518d6c6634e5422e1f35235d23e";
    mapSearch = [[AMapSearchAPI alloc]init];
    mapSearch.delegate = self;
    queryText = self.title;
   /* AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    
    
    request.keywords = queryText;
    request.requireExtension    = YES;
    request.city = @"杭州";

    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [mapSearch AMapPOIKeywordsSearch:request];
    
    */
    
    AMapPOIAroundSearchRequest *requestTwo = [AMapPOIAroundSearchRequest new];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"currentLoc"]) {
        _location = [[AMapGeoPoint alloc]init];
        NSDictionary *dic = [NSDictionary new];
        dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userLoc"];
        _location.latitude = [dic[@"latitude"] floatValue];
        _location.longitude = [dic[@"longitude"] floatValue];
    }
    
    requestTwo.location = _location;
    NSLog(@"_location:%@", _location);
    requestTwo.radius = 2000;
    requestTwo.keywords = queryText;
    requestTwo.sortrule = 0;
    
    [mapSearch AMapPOIAroundSearch:requestTwo];
    
    
    
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"搜索出错" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response{
    NSLog(@"Near");
}
#pragma mark 附近搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
   
    if (response.pois.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有符合要求的位置信息" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    NSMutableArray *pointAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        LocationModel *locationModel = [LocationModel new];
        
        
        CLGeocoder *geo = [CLGeocoder new];
        CLLocation *clLocation = [[CLLocation alloc]initWithLatitude:obj.location.latitude longitude:obj.location.longitude];

        
        
        [geo reverseGeocodeLocation:clLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *place = [placemarks firstObject];
            NSDictionary *locationDic = [place addressDictionary];
            
            _area = [locationDic objectForKey:@"SubLocality"];
            locationModel.area = _area;
            
        }];
       
        MKPointAnnotation *pointAnnotation  = [MKPointAnnotation new];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
        pointAnnotation.title = obj.name;
        pointAnnotation.subtitle = obj.address;
        [pointAnnotations addObject:pointAnnotation];
        
        locationModel.address = obj.name;
        locationModel.subArea = obj.address;
        NSString *unit = [[NSUserDefaults standardUserDefaults] valueForKey:@"unit"];
        if ([unit isEqualToString:@"m"]) {
            locationModel.distance = [NSString stringWithFormat:@"%ld%@",obj.distance,unit];
        }else{
            locationModel.distance = [NSString stringWithFormat:@"%.1f%@",obj.distance*0.9144,unit];

        }
        
        
        [_locationArr addObject:locationModel];

        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [_mapView addAnnotations:pointAnnotations];

    /* 如果只有一个结果，设置其为中心点. */
    if (pointAnnotations.count == 1)
    {
        [_mapView setCenterCoordinate:[pointAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [_mapView showAnnotations:pointAnnotations animated:NO];
    }
    [_tableView reloadData];
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败");
    hud.labelText = @"定位失败";
    [hud hide:YES afterDelay:1];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"定位成功");
    [hud hide:YES];
    [_locationManager stopUpdatingLocation];
    _location = [[AMapGeoPoint alloc]init];
    _location.longitude = userLocation.coordinate.longitude;
    _location.latitude = userLocation.coordinate.latitude;
    //1.调整地图显示的范围
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    //显示范围
    //地图显示的大小，单位为经纬度的1度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    //创建区域对象
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);

    //设定显示区域
    [_mapView setRegion:region animated:YES];
    [self queryAction];
}

- (void)createMapView{
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SEARCH_HID"]) {
        [self.view insertSubview:_mapView atIndex:1];
    }else {
        [self.view insertSubview:_mapView atIndex:0];
    }

}

- (void)createListView{
    _locationArr = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"LocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SEARCH_HID"]) {
        [self.view insertSubview:_tableView atIndex:0];
    }else {
        [self.view insertSubview:_tableView atIndex:1];
    }
    
}

#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _locationArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setLocationModel:_locationArr[indexPath.row]];
    

 //   NSLog(@"cell: %f/%f", cell.frame.size.height, cell.frame.size.width);
    return cell;
}

- (void)segmentAction:(UISegmentedControl *)seg{
    segmentIndex = seg.selectedSegmentIndex;
    if (segmentIndex == 0) {
        //切换列表视图
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SEARCH_HID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        _mapView.hidden = YES;
        _tableView.hidden = NO;
        [self bottomViewBack];
        
    }else{
        //切换地图视图
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SEARCH_HID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        _mapView.hidden = NO;
        _tableView.hidden = YES;
        [self bottomViewBack];
    }
}
- (void)locationAction{
    if (kSystemVersion > 8.0) {
        NSLog(@"8.0");
        
        [_locationManager requestWhenInUseAuthorization];
        
    }
    _locationManager.delegate = self;

    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
