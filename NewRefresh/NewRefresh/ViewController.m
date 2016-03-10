//
//  ViewController.m
//  NewRefresh
//
//  Created by 冯鸿辉 on 16/3/10.
//  Copyright © 2016年 DGC. All rights reserved.
//

#define ScreenW [[UIScreen mainScreen] bounds].size.width
#define ScreenH [[UIScreen mainScreen] bounds].size.height
#import "ViewController.h"
#import "NewRefreshView.h"
#import "NewWebView.h"
@interface ViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)NewRefreshView *rview;
@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,assign)CGFloat lastRefreshViewY;
@property(nonatomic,assign)CGFloat currentRefreshViewY;
@property(nonatomic,assign)BOOL canEdit;
@end

@implementation ViewController

#pragma mark - < vc lifecycle> -
- (void)viewDidLoad {
  [super viewDidLoad];

  [self customInitData];
  [self customInitUI];
  
}

#pragma mark - < method > -
#pragma mark customInitUI
-(void)customInitData{
  self.lastRefreshViewY = 0;
  self.currentRefreshViewY = 0;
  self.canEdit = YES;
}

-(void)customInitUI{
  UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH-50)];
  [webview setDelegate:self];
//  [webview.scrollView setDelegate:self];
  [webview.scrollView setBounces:NO];
  [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
  webview.userInteractionEnabled = YES;
  [self.view addSubview:webview];
  self.webview = webview;
  
  
  UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(webviewPanGRAction:)];
  [panGR setDelegate:self];
  [webview addGestureRecognizer:panGR];
//  [webview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webviewTapGRAction:)]];
  
  NewRefreshView *rview = [[[NSBundle mainBundle] loadNibNamed:@"NewRefreshView" owner:self options:nil] lastObject];
  [rview setFrame:CGRectMake(0, 0, ScreenW, 50)];
  [self.view addSubview:rview];
  self.rview = rview;
}

#pragma mark GestureRecognizer
-(void)webviewPanGRAction:(UIPanGestureRecognizer *)panGR{
  if (self.canEdit == YES) {
    CGFloat delta = [panGR translationInView:self.view].y;
    CGFloat currentRefreshViewY = self.lastRefreshViewY+delta;
    [self.webview setUserInteractionEnabled:NO];
    if (currentRefreshViewY<=0) {
      NSLog(@"~没有移动或往上移");
      [self.rview customInitUI];
      self.lastRefreshViewY = 0;
      self.currentRefreshViewY = 0;
    }else if (currentRefreshViewY>0 && currentRefreshViewY<150) {
      NSLog(@"~往下移动中");
      [self.rview setFrame:CGRectMake(0, self.lastRefreshViewY+delta, ScreenW, 50)];
      [self.rview customInitUI];
      self.lastRefreshViewY = currentRefreshViewY;
      self.currentRefreshViewY = currentRefreshViewY;
    }else{
      NSLog(@"~到达临界点");
      [self.rview readyUpload];
      self.lastRefreshViewY = 150;
      self.currentRefreshViewY = 150;
    }
  }
  
  [panGR setTranslation:CGPointZero inView:self.view];
}

-(void)webviewTapGRAction:(UITapGestureRecognizer *)tapGR{

}

#pragma mark touch
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//  CGPoint location = CGPointZero;
//  for (UITouch *touch in touches) {
//    location = [touch locationInView:self.view];
//  }
////  NSLog(@"began:%@",NSStringFromCGPoint(location));
//}
//
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//  for (UITouch *touch in touches) {
//    CGPoint location = [touch locationInView:self.view];
//    CGPoint previousLocation = [touch previousLocationInView:self.view];
//    [self move:location previous:previousLocation];
//  }
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//  for (UITouch *touch in touches) {
//    CGPoint location = [touch locationInView:self.view];
//    [self.webview setUserInteractionEnabled:YES];
//    [self end:location];
//  }
//}

#pragma mark rview
-(void)move:(CGPoint)location previous:(CGPoint)previousLocation{
  
  if (self.canEdit == YES) {

    CGFloat delta = location.y - previousLocation.y;
    CGFloat currentRefreshViewY = self.lastRefreshViewY+delta;
    [self.webview setUserInteractionEnabled:YES];
    if (currentRefreshViewY<=0) {
      NSLog(@"没有移动或往上移");
      [self.rview customInitUI];
      self.lastRefreshViewY = 0;
      self.currentRefreshViewY = 0;
    }else if (currentRefreshViewY>0 && currentRefreshViewY<150) {
      NSLog(@"往下移动中");
      [self.rview setFrame:CGRectMake(0, self.lastRefreshViewY+delta, ScreenW, 50)];
      [self.rview customInitUI];
      self.lastRefreshViewY = currentRefreshViewY;
      self.currentRefreshViewY = currentRefreshViewY;
    }else{
      NSLog(@"到达临界点");
      [self.rview readyUpload];
      self.lastRefreshViewY = 150;
      self.currentRefreshViewY = 150;
    }
  }else{
    return;
  }
  
}

-(void)end:(CGPoint)location{
  
  if (self.canEdit == YES) {
    if (self.currentRefreshViewY <= 0) {
      NSLog(@"end - 没有移动或往上移");
      return;
    }
    if (self.currentRefreshViewY >0 && self.currentRefreshViewY<150) {
      NSLog(@"end - 往下移动中");
      [self endRefreshView1:location];
      return;
    }
    if (self.currentRefreshViewY >= 150) {
      NSLog(@"end - 到达临界点");
      [self endRefreshView2:location];
      return;
    }
  }

}

-(void)endRefreshView1:(CGPoint)location{
  self.canEdit = NO;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:1 animations:^{
        [self.rview setFrame:CGRectMake(0, 0, ScreenW, 50)];
        self.lastRefreshViewY = 0;
        self.currentRefreshViewY = 0;
      } completion:^(BOOL finished) {
        self.canEdit = YES;
      }];
      
    });
  });
}

-(void)endRefreshView2:(CGPoint)location{
  self.canEdit = NO;
  [self.rview uploading:^{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [NSThread sleepForTimeInterval:3.0];
      dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
          [self.rview finish:nil];
          [self.rview setFrame:CGRectMake(0, 0, ScreenW, 50)];
          self.lastRefreshViewY = 0;
          self.currentRefreshViewY = 0;
        } completion:^(BOOL finished) {
          self.canEdit = YES;
          [self.rview customInitUI];
        }];
        
      });
    });
  }];
}

#pragma mark - < callback > -
#pragma mark webview
-(void)webViewDidStartLoad:(UIWebView *)webView{

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

#pragma mark scrollview


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  NSLog(@"scrollViewWillBeginDragging %@",NSStringFromCGPoint(scrollView.contentOffset));
  
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  NSLog(@"scrollViewDidEndDragging %@",NSStringFromCGPoint(scrollView.contentOffset));
  self.webview.userInteractionEnabled = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  NSLog(@"~~scrollViewDidScroll %@",NSStringFromCGPoint(scrollView.contentOffset));
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
  return YES;
}

@end
