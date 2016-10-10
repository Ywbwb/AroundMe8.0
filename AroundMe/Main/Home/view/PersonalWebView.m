//
//  PersonalWebView.m
//  AroundMe
//
//  Created by mac13 on 16/9/19.
//  Copyright © 2016年 DaiDai. All rights reserved.
//

#import "PersonalWebView.h"

@implementation PersonalWebView
-(void)viewDidLoad{
    UIWebView *webView = [UIWebView new];
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _request = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
    [webView loadRequest:_request];
    [self.view addSubview:webView];
    

}
@end
