//  Copyright (c) 2014 Google. All rights reserved.

@import GoogleMobileAds;

#import "ViewController.h"

@interface ViewController ()
// Flags to check and handle PubMatic passback
@property(nonatomic,assign) BOOL isAppEventPubmaticPbk;
@property(nonatomic,assign) BOOL isAdLoadSuccessful;

-(void) resetAllFlags;
-(void) firePassbackRequest;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetAllFlags];

  self.bannerView.adUnitID = @"/15671365/mobileapp";
  self.bannerView.rootViewController = self;
    self.request = [DFPRequest request];
  [self.bannerView loadRequest:self.request];
    self.bannerView.appEventDelegate=self;
    self.bannerView.delegate=self;
    
    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
    NSLog(@"Refesh!!!!");
    self.request = [DFPRequest request];
    [self.bannerView loadRequest:self.request];
}

- (void)adView:(GADBannerView *)banner
didReceiveAppEvent:(NSString *)name
      withInfo:(NSString *)info
{
    
    NSLog(@"Fetched Event Name %@ and Info %@",name,info);
    
    if([name isEqualToString:@"pmpbk"] && [info isEqualToString:@"1"])
    {
        self.isAppEventPubmaticPbk=YES;
        [self firePassbackRequest];
    }
    
    
}

-(void) resetAllFlags
{
    self.isAppEventPubmaticPbk=NO;
    self.isAdLoadSuccessful=NO;
}

-(void) firePassbackRequest
{
    @synchronized(self) {
        if (self.isAdLoadSuccessful && self.isAppEventPubmaticPbk) {
            self.request.customTargeting = @{@"pmpbk" : @"1"};
            [self.bannerView loadRequest:self.request];
            
            [self resetAllFlags];

        }
        
    }
}

#pragma mark Ad Request Lifecycle Notifications

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    self.isAdLoadSuccessful=YES;
    [self firePassbackRequest];
    
    NSLog(@"DFP Received Ad");
    
    
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"DFP Failed to load Ad with error %@",[error description]);
    [self resetAllFlags];
}


@end
