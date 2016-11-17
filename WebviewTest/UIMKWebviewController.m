//
//  UIMKWebviewController.m
//  WebviewTest
//
//  Created by duanhongjin on 16/11/17.
//  Copyright © 2016年 CrazyKids. All rights reserved.
//

#import "UIMKWebviewController.h"
#import <WebKit/WebKit.h>

@interface UIMKWebviewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) UIBarButtonItem *closeButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end

@implementation UIMKWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.preferences = [WKPreferences new];
    configuration.userContentController = [WKUserContentController new];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:@"https://code.angularjs.org/1.1.0/docs/guide/scope"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [self.webView loadRequest:request];

    self.backButton = [[UIBarButtonItem alloc]initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonClicked:)];
    self.closeButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButtonClicked:)];
    self.navigationItem.leftBarButtonItem = self.closeButton;
}

- (void)onBackButtonClicked:(id)sender {
    [self.webView goBack];
}

- (void)onCloseButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.closeButton, self.backButton];
    } else {
        self.navigationItem.leftBarButtonItem = self.closeButton;
    }
}

@end
