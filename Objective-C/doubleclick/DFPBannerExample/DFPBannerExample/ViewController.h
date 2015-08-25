//  Copyright (c) 2014 Google. All rights reserved.

#import <UIKit/UIKit.h>

@class DFPBannerView;

@interface ViewController : UIViewController<GADAppEventDelegate,GADBannerViewDelegate>

/// The DFP banner view.
@property(nonatomic, weak) IBOutlet DFPBannerView *bannerView;
@property(nonatomic, strong) DFPRequest *request ;

- (IBAction)refresh:(id)sender;

@end
