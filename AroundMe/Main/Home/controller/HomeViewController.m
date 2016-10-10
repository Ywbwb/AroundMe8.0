//
//  HomeViewController.m
//  AroundMe
//
//  Created by DaiDai on 16/8/25.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "HomeModel.h"
#import "LocationViewController.h"
#import "CoverDelegate.h"
#import "RightCoverDelegate.h"
#import "PersonalWebView.h"
#import "WeatherViewController.h"
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapSearchDelegate>

{
    NSMutableArray *homeModelArr;
    UITableView *listView;
    UITableView *leftCoverTableView;
    UIView *leftGaryCoverView;
    UILabel *leftCoverLabel;
    UIButton *leftCoverButton;
    UIView *rightGrayCover;
    UITableView *rightCoverTableView;
    UILabel *rightCoverLabel;
    UIButton *rightCoverButton;
    UISearchBar *rightCoverSearchBar;
    UIWebView *webView;
    AMapSearchAPI *_searchAPI;
    __strong CoverDelegate *delegate;
    __strong RightCoverDelegate *rightDelegate;


}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (strong, nonatomic)UISearchBar *searchBar;




@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButton];
    [self createListView];
     [self createCollectionView];
    [self creatLeftCoverView];
    [self creatRightCoverView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftCoverViewChanged:) name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalPush:) name:@"push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightCoverViewChanged) name:@"rightChange" object:nil];

}

- (void)personalPush:(NSDictionary *)result{
    NSLog(@"result:%@",result);
    PersonalWebView *web = [[PersonalWebView alloc]init];
    NSDictionary *user = [[NSDictionary alloc]init];
    user = [result valueForKey:@"userInfo"];
    NSString *urlStr = user[@"privacy"];
    web.request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
   // [self.navigationController presentViewController:web animated:YES completion:^{
        
 //   }];
}
- (void)creatRightCoverView{
    rightGrayCover = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    rightGrayCover.alpha = 0.4;
    rightGrayCover.backgroundColor = [UIColor grayColor];
    
    rightCoverLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth + 10, 20, kScreenWidth - 20, 43.5)];
    rightCoverLabel.backgroundColor = [UIColor whiteColor];
    rightCoverLabel.textAlignment = NSTextAlignmentCenter;
    rightCoverLabel.text = @"位置";
    rightCoverLabel.userInteractionEnabled = YES;
    
    rightCoverTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth + 10, 114, kScreenWidth - 20, (kScreenHeight - 64 - 50)/2) style:UITableViewStylePlain];
    rightDelegate = [RightCoverDelegate new];
    rightCoverTableView.delegate = rightDelegate;
    rightCoverTableView.dataSource = rightDelegate;
    [rightCoverTableView setSeparatorColor:[UIColor grayColor]];
    
    rightCoverSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(kScreenWidth + 10, 64.5, kScreenWidth - 20, 50)];
    rightCoverSearchBar.tag = 1;
    rightCoverSearchBar.delegate = self;
    rightCoverSearchBar.barTintColor = searchBarColor;

    
    rightCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightCoverButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightCoverButton setTitleColor:myColor forState:UIControlStateNormal];
    rightCoverButton.frame = CGRectMake(kScreenWidth + kScreenWidth - 10 - 50, 20, 40, 43.5);
    [rightCoverButton addTarget:self action:@selector(rightCoverViewChanged) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:rightGrayCover];
    [self.navigationController.view addSubview:rightCoverLabel];
    [self.navigationController.view addSubview:rightCoverSearchBar];
    [self.navigationController.view addSubview:rightCoverTableView];
    [self.navigationController.view addSubview:rightCoverButton];
    
}
- (void)creatLeftCoverView{
    
    leftCoverTableView = [[UITableView alloc]initWithFrame:CGRectMake(-kScreenWidth + 10, 64.5, kScreenWidth- 20, kScreenHeight - 74) style:UITableViewStyleGrouped];
    
    delegate = [CoverDelegate new];
    
    leftCoverTableView.delegate = delegate;
    leftCoverTableView.dataSource = delegate;
    
    leftGaryCoverView = [[UIView alloc]initWithFrame:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    leftGaryCoverView.backgroundColor = [UIColor grayColor];
    leftGaryCoverView.alpha = 0.4;
    
    leftCoverLabel = [[UILabel alloc]initWithFrame:CGRectMake(-kScreenWidth + 10, 20, (kScreenWidth - 20), 43.5)];
    leftCoverLabel.backgroundColor = [UIColor whiteColor];
    
    leftCoverLabel.textAlignment = NSTextAlignmentCenter;
    leftCoverLabel.text = @"设置";
    leftCoverLabel.userInteractionEnabled = YES;
    
    
    
    leftCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftCoverButton.frame = CGRectMake(-65, 20, 40, 43.5);
    
    [leftCoverButton setTitle:@"完成" forState:UIControlStateNormal];
    [leftCoverButton setTitleColor:[UIColor colorWithRed:34/255.0 green:90/255.0 blue:138/255.0 alpha:1] forState:UIControlStateNormal];
    leftCoverButton.backgroundColor = [UIColor clearColor];
    
    [leftCoverButton addTarget:self action:@selector(leftCoverViewChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.navigationController.view addSubview:leftGaryCoverView];
    [self.navigationController.view addSubview:leftCoverTableView];
    [self.navigationController.view addSubview:leftCoverLabel];
    [self.navigationController.view addSubview:leftCoverButton];
    
    
}
#pragma mark 右边遮盖视图弹出
- (void)locationAction{
   
    
    [rightCoverSearchBar becomeFirstResponder];
    rightGrayCover.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    rightCoverTableView.x = 10;
    rightCoverLabel.x = 10;
    rightCoverButton.x = kScreenWidth - 55;
    rightCoverSearchBar.x = 10;
    [UIView commitAnimations];
    
    
    
    
}

#pragma mark 搜索回调
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:[NSString stringWithFormat:@"%f", response.districts.firstObject.center.latitude] forKey:@"latitude"];
    [dic setValue:[NSString stringWithFormat:@"%f", response.districts.firstObject.center.longitude] forKey:@"longitude"];
    [dic setValue:response.districts.firstObject.name forKey:@"locName"];
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"userLoc"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [rightCoverTableView reloadData];
    
    
}
#pragma mark 右边遮盖视图弹回
- (void)rightCoverViewChanged{
    [rightCoverSearchBar resignFirstResponder];
    rightGrayCover. x = kScreenWidth;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    rightCoverTableView.x = 10 + kScreenWidth;
    rightCoverLabel.x = 10 + kScreenWidth;
    rightCoverButton.x = 2 * kScreenWidth - 55;
    rightCoverSearchBar.x = 10 + kScreenWidth;
    [UIView commitAnimations];
}

#pragma mark 左边遮盖视图弹出
- (void)setButtonAction{
    
    leftGaryCoverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    leftCoverTableView.x = 10;
    leftCoverLabel.x = 10;
    leftCoverButton.x = kScreenWidth -55;
    [UIView commitAnimations];
    
}

#pragma mark 左边遮盖视图弹回
- (void)leftCoverViewChanged:(NSDictionary *)notice{
   
    if ([notice isKindOfClass:[NSNotification class]]) {
        NSDictionary *info = [[NSDictionary alloc]init];
        info = [notice valueForKey:@"userInfo"];
     //   NSLog(@"%@",info);
        if ([info[@"animate"] isEqualToString:@"YES"]) {
            _collectionView.hidden = listView.hidden;
            listView.hidden = !_collectionView.hidden;
        }
    }
    leftGaryCoverView.x = -kScreenWidth;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    leftCoverTableView.x = 10 - kScreenWidth;
    leftCoverLabel.x = 10 - kScreenWidth;
    leftCoverButton.x = - 65;
    [UIView commitAnimations];
    


}

#pragma mark 创建table
- (void)createListView{
    listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    listView.delegate = self;
    listView.dataSource = self;
    [self.view addSubview:listView];
    listView.hidden = ![[NSUserDefaults standardUserDefaults]boolForKey:@"hidden"];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return homeModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
    HomeModel *model = homeModelArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.pic];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:25];
    cell.textLabel.textColor = [UIColor colorWithRed:34/255.0 green:90/255.0 blue:138/255.0 alpha:1];
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _searchBar.barTintColor = searchBarColor;
    _searchBar.delegate = self;
    return _searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)createButton{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 64, 64);
    [leftButton setImage:[UIImage imageNamed:@"NavbarIconSettingsFlat"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    [leftButton addTarget:self action:@selector(setButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 64, 64);
    [rightButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"NavbarIconLocationFlat"] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    

}
#pragma mark 创建collection
- (void)createCollectionView{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, -65, kScreenWidth, 50)];
    _searchBar.barTintColor = searchBarColor;
    _searchBar.delegate = self;
    [_collectionView addSubview:_searchBar];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"home" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in arr) {
        HomeModel *homeModel = [[HomeModel alloc]init];
        homeModel.pic = dic[@"pic"];
        homeModel.name = dic[@"name"];
        homeModel.url = dic[@"url"];
        homeModel.tag = dic[@"tag"];
        [mArr addObject:homeModel];
        
    }
    homeModelArr = [mArr copy];
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(edgSpace, edgSpace, 0, edgSpace);
   // _collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.hidden = [[NSUserDefaults standardUserDefaults]boolForKey:@"hidden"];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return homeModelArr.count/3;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 6 * edgSpace) / 3, (kScreenWidth - 6 * edgSpace) / 3);
   
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    [cell setHomeModel:homeModelArr[3*indexPath.section + indexPath.row]];

   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *model = homeModelArr[indexPath.row];
    if ([model.name isEqualToString:@"天气"]) {
        WeatherViewController *weather = [WeatherViewController new];
        [self.navigationController pushViewController:weather animated:YES];
    }else{
    LocationViewController *lv = [[LocationViewController alloc]init];
    [self.navigationController pushViewController:lv animated:YES];
    lv.title = model.name;
    lv.model = model;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     HomeModel *model = homeModelArr[indexPath.section * 3 + indexPath.row];
    if ([model.name isEqualToString:@"天气"]) {
        WeatherViewController *weather = [WeatherViewController new];
        [self.navigationController pushViewController:weather animated:YES];
    }else{
        
    LocationViewController *lv = [[LocationViewController alloc]init];
    [self.navigationController pushViewController:lv animated:YES];
    lv.title = model.name;
    lv.model = model;
    }
   
    
}
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (searchBar.tag == 1) {
        [AMapServices sharedServices].apiKey = @"150df518d6c6634e5422e1f35235d23e";
        _searchAPI = [AMapSearchAPI new];
        _searchAPI.delegate = self;
        AMapDistrictSearchRequest *request = [AMapDistrictSearchRequest new];
        request.keywords = rightCoverSearchBar.text;
        [_searchAPI AMapDistrictSearch:request];
    }else{
        [searchBar resignFirstResponder];
        LocationViewController *locView = [LocationViewController new];
        locView.title = searchBar.text;
        [self.navigationController pushViewController:locView animated:YES];
        searchBar.text = nil;
    }
}
/*
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
