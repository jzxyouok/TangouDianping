//
//  TRDetailDealVC.m
//  TRDeals
//
//  Created by tarena on 15/6/30.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRDetailDealVC.h"

@interface TRDetailDealVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TRDetailDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url ]];
    [self.webView loadRequest:request];
    
}

- (IBAction)buttonBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
