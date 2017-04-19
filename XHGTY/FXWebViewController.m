//
//  FXWebViewController.m
//  CityCook
//
//  Created by 杨健 on 16/8/16.
//  Copyright © 2016年 Sichuan City Cooking Brother. All rights reserved.
//

#import "FXWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "UIBarButtonItem+Exstion.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#define kColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface FXWebViewController ()<UIWebViewDelegate,WKNavigationDelegate>
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FXWebViewController{
      YHWebViewProgress *_progressProxy;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (_isneed){
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-44, 0, 0, 0));
    }];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
   
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    self.title = self.titleName;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImge:@"backImage_w" selectedIcon:@"backImage_w" target:self andSEL:@selector(back)];
    
    
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 2)];
    progressView.progressBarColor = kColor(254, 153, 0, 1);
    
    
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViewProgress
    self.webView.delegate = self.progressProxy;
    // 设置webview代理转发到self（可选）
    self.progressProxy.webViewProxy = self;
    
    // 添加到视图
    [self.view addSubview:progressView];
    
    [self loadNewItems];
    
    //self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    [SVProgressHUD dismiss];
}
- (void)close{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancel{
    [self.webView reload];
}


- (void)loadNewItems{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.accessUrl]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    
    NSLog(@"url = %@",url);
    
    return YES;
}




@end