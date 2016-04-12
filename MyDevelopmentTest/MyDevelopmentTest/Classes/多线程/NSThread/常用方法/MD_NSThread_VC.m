//
//  MD_NSThread_VC.m
//  MyDevelopmentTest
//
//  Created by 冯鸿辉 on 16/4/8.
//  Copyright © 2016年 hanyfeng. All rights reserved.
//

#import "MD_NSThread_VC.h"
@interface MD_NSThread_VC()
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)NSLock *lock;
@property(nonatomic,strong)NSCondition *condition;
@property(nonatomic,assign)NSInteger ticket;
@property(nonatomic,strong)NSThread *thread1;
@property(nonatomic,strong)NSThread *thread2;
@end


@implementation MD_NSThread_VC

#pragma mark - < vc lifecycle > -

-(void)viewDidLoad{
  
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
  
  [super viewDidAppear:animated];
  
  [self test_saleTickets];
}

-(void)viewDidDisappear:(BOOL)animated{

  [self.thread1 cancel];
  [self.thread2 cancel];
  
  [super viewDidDisappear:animated];
}

#pragma mark - < method > -
#pragma mark - 创建子线程
-(void)test_createThread{
  
//  [NSThread detachNewThreadSelector:@selector(createView:) toTarget:self withObject:@"创建view"];
  
  NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(createView:) object:@"创建view"];
  thread.name = @"1号线程";
  [thread start];
}

-(void)createView:(NSString *)object{
  
  NSLog(@"线程名：%@",[NSThread currentThread].name);
  
  if ([object isEqualToString:@"创建view"]) {
    for (int i = 0; i<5; i++) {
      [NSThread sleepForTimeInterval:1];
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*50, 200, 20, 20)];
      [view setBackgroundColor:[UIColor blueColor]];
      
      //回到主线程执行 waitUntilDone-是否等待主线程执行完再执行
      [self performSelectorOnMainThread:@selector(updateUI:) withObject:view waitUntilDone:NO];
    }
  }
}

-(void)updateUI:(UIView *)view{
  
  [self.view addSubview:view];
}

#pragma mark - 卖票问题(线程同步 加锁)
-(void)test_saleTickets{
  
  self.btn = [[UIButton alloc] init];
  self.lock = [[NSLock alloc] init];
  self.condition = [[NSCondition alloc] init];
  self.ticket = 100;
  
  NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleMain) object:nil];
  thread1.name = @"1号窗口";
  [thread1 start];
  self.thread1 = thread1;
  
  NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleMain) object:nil];
  thread2.name = @"2号窗口";
  [thread2 start];
  self.thread2 = thread2;
  
  NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(switchOnOff) object:nil];
  thread3.name = @"开关";
  [thread3 start];
}

-(void)saleMain{

  [self sale3];
}

-(void)switchOnOff{
  
  while (YES) {
    [self.condition lock];
    [NSThread sleepForTimeInterval:1];
    [self.condition signal];
    [self.condition unlock];
  }
  
}

//线程加锁方法1 - NSLock（也可以用NSCondition代替）
-(void)sale1{

  while (YES) {
    
    if ([[NSThread currentThread] isCancelled]) {
      NSLog(@"return:%@",[NSThread currentThread].name);
      //[NSThread exit];
      return;//return可以退出线程
    }
    
    [self.lock lock];
    NSLog(@"%@窗口开始卖%ld号票",[NSThread currentThread].name,(long)self.ticket);
    sleep(1);
    self.ticket--;
    [self.lock unlock];
    
  }
}

//线程加锁方法2 - 简便方法 不用加锁
-(void)sale2{

  while (YES) {
    
    if ([[NSThread currentThread] isCancelled]) {
      NSLog(@"return:%@",[NSThread currentThread].name);
      return;
    }
  
    @synchronized(self.btn){
      NSLog(@"%@窗口开始卖%ld号票",[NSThread currentThread].name,(long)self.ticket);
      [NSThread sleepForTimeInterval:1];
      self.ticket--;
    }

  }
}

//线程加锁方法3 - NSCondition
-(void)sale3{

  [self.condition wait];
  
  while (YES) {
    
    if ([[NSThread currentThread] isCancelled]) {
      NSLog(@"return:%@",[NSThread currentThread].name);
      return;
    }

    [self.lock lock];
    NSLog(@"%@窗口开始卖%ld号票",[NSThread currentThread].name,(long)self.ticket);
    sleep(1);
    self.ticket--;
    [self.lock unlock];
  }

}

@end
