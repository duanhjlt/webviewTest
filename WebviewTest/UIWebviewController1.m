//
//  UIWebviewController1.m
//  WebviewTest
//
//  Created by duanhongjin on 16/11/17.
//  Copyright © 2016年 CrazyKids. All rights reserved.
//

#import "UIWebviewController1.h"
#import "NSObject+KVO.h"

@interface UIWebviewController1 ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (strong, nonatomic) UIBarButtonItem *closeButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end

@implementation UIWebviewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://code.angularjs.org/1.1.0/docs/guide/scope"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [self.webview loadRequest:request];
    
    self.backButton = [[UIBarButtonItem alloc]initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonClicked:)];
    self.closeButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButtonClicked:)];
    self.navigationItem.leftBarButtonItem = self.closeButton;
}

- (void)onBackButtonClicked:(id)sender {
    [self.webview goBack];
}

- (void)onCloseButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webview1: %@", webView.request.URL.absoluteString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webview1 start load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webview1 finish load");
    
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.closeButton, self.backButton];
    } else {
        self.navigationItem.leftBarButtonItem = self.closeButton;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"webview1 error = %@", error);
}

@end
