//
//  HFOtherViewController.m
//  MyWeiboClient
//
//  Created by hanyfeng on 14-8-15.
//  Copyright (c) 2014年 hanyfeng. All rights reserved.
//

#import "HFMoreViewController.h"

@interface HFMoreViewController ()

@end

@implementation HFMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [label setBackgroundColor:[UIColor redColor]];
    [label setTextColor:[UIColor greenColor]];
    [label setText:@"4"];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
