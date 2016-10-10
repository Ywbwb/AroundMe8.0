//
//  WeatherViewController.m
//  AroundMe
//
//  Created by mac13 on 16/9/21.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherCell.h"
#import "WeatherModel.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
@interface WeatherViewController()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,MAMapViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    UITableView *_table;
    NSMutableArray *_modelArr;
    NSString *locAdd;
    NSDictionary *_weatherDic;
    CLLocationManager *_locationManager;
    MBProgressHUD *hud;
}
@end
@implementation WeatherViewController
-(void)viewDidLoad{
    self.title = @"天气";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableView];
    [self searchAction];
    [self showProgress];
    //GwAs3y8XgH1EidVCSStcKQ7smnFfOuyH
}
- (void)showProgress{
    hud = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    hud.userInteractionEnabled = NO;
    hud.delegate = self;
    // hud.color = [UIColor whiteColor];
    
    hud.labelText = @"load";
    
    
    [self.navigationController.view addSubview:hud];
    
    [hud show:YES];
}
- (void)searchAction{
    _locationManager = [[CLLocationManager alloc]init];
    _modelArr = [NSMutableArray new];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"currentLoc"]) {
        NSDictionary *dic = [NSDictionary new];
        dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userLoc"];
        locAdd = dic[@"locName"];
        [self query];
    }else{
        if (kSystemVersion > 8.0) {
            
            [_locationManager requestWhenInUseAuthorization];
            
        }
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager startUpdatingLocation];
    }
    
    

}
- (void)query{
    NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?"];
    AFHTTPSessionManager *http = [AFHTTPSessionManager manager];
    http.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = [NSDictionary dictionary];
    dic = @{@"location":locAdd,
            @"output":@"json",
            @"ak":@"GwAs3y8XgH1EidVCSStcKQ7smnFfOuyH"
            };
    [http GET:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *subArr = responseObject[@"results"];
        NSDictionary *subDic = subArr[0];
        NSArray *weatherArr= subDic[@"weather_data"];
        NSLog(@"count:%ld", weatherArr.count);
        
         NSMutableArray *mArr = [NSMutableArray new];
        for (NSDictionary *dic in weatherArr) {
            WeatherModel *model = [WeatherModel new];
            model.time = dic[@"date"];
           model.currentTem = dic[@"temperature"];
           
            if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"TEM"]isEqualToString:@"celsius"]) {
                NSString *str = dic[@"temperature"];
                //33.8 \u2109  ℉
                NSRange range = [str rangeOfString:@"~"];
                NSString *subStrOne = [str substringToIndex:range.location];
                float min = [subStrOne floatValue] * 1.8 +32;
                
                NSString *subStrSecond = [str substringFromIndex:range.location+1];
                
                NSRange rangeTwo = [subStrSecond rangeOfString:@"℃"];
                NSString *subStrThird = [subStrSecond substringToIndex:rangeTwo.location];
                float max = [subStrThird floatValue]*1.8+32;
                model.currentTem = [NSString stringWithFormat:@"%.1f~%.1f℉",min, max];
                
            }
            model.weather = dic[@"weather"];
            model.imgUrl = dic[@"dayPictureUrl"];
            [mArr addObject:model];
           
        }
        _modelArr = [mArr copy];
        [hud hide:YES];
        [_table reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        hud.labelText = @"定位失败";
        [hud hide:YES afterDelay:1];
    }];

}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
    {
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            locAdd = city;
            [self query];
        }
        else if (error == nil && [array count] == 0)
        {
            
        }
        
    }];
    [manager stopUpdatingLocation];
}
#pragma mark tableView
- (void)creatTableView{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 80) style:UITableViewStylePlain];
    [_table registerNib:[UINib nibWithNibName:@"WeatherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weatherCell"];
    
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+_table.height+30, kScreenWidth, 50)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"For 3 days weather forecasts";
    label.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:label];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell"];
    [cell setModel:_modelArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)viewWillDisappear:(BOOL)animated{
    [hud hide:YES];
}
@end
