//
//  UIWebviewController2.m
//  WebviewTest
//
//  Created by duanhongjin on 16/11/17.
//  Copyright © 2016年 CrazyKids. All rights reserved.
//

#import "UIWebviewController2.h"

@interface UIWebviewController2 ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (strong, nonatomic) UIBarButtonItem *closeButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end

@implementation UIWebviewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://code.angularjs.org/1.1.0/docs/guide/scope"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [self.webview loadRequest:request];
    
    self.closeButton = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonClicked:)];
    self.backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButtonClicked:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)onBackButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCloseButtonClicked:(id)sender {
    if (self.webview.canGoBack) {
        [self.webview goBack];
        self.navigationItem.leftBarButtonItems = @[self.backButton, self.closeButton];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webview2: %@", webView.request.URL.absoluteString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webview2 start load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webview2 finish load");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"webview2 error = %@", error);
}

@end
