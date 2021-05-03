//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#include "LoupeRootListController.h"

@implementation LoupeRootListController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    CGRect frame = CGRectMake(0,0,self.table.bounds.size.width,170);
    CGRect Imageframe = CGRectMake(0,10,self.table.bounds.size.width,80);
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor colorWithRed: 0.38 green: 0.38 blue: 0.38 alpha: 1.00];
    
    
    UIImage *headerImage = [[UIImage alloc]
                            initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/LoupePrefs.bundle"] pathForResource:@"Loupe512" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Imageframe];
    [imageView setImage:headerImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:imageView];
    
    CGRect labelFrame = CGRectMake(0,imageView.frame.origin.y + 90 ,self.table.bounds.size.width,80);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [headerLabel setText:@"Loupe"];
    [headerLabel setFont:font];
    [headerLabel setTextColor:[UIColor blackColor]];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerLabel setContentMode:UIViewContentModeScaleAspectFit];
    [headerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:headerLabel];
    
    self.table.tableHeaderView = headerView;
    
    self.respringBtn = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(_reallyRespring)];
    self.navigationItem.rightBarButtonItem = self.respringBtn;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *rootSpecifiers = [[NSMutableArray alloc] init];
        
        //Tweak
        PSSpecifier *tweakEnabledGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Tweak" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [tweakEnabledGroupSpec setProperty:@"No respring required." forKey:@"footerText"];
        [rootSpecifiers addObject:tweakEnabledGroupSpec];
        
        PSSpecifier *tweakEnabledSpec = [PSSpecifier preferenceSpecifierNamed:@"Enabled" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [tweakEnabledSpec setProperty:@"Enabled" forKey:@"label"];
        [tweakEnabledSpec setProperty:@"enabled" forKey:@"key"];
        [tweakEnabledSpec setProperty:@YES forKey:@"default"];
        [tweakEnabledSpec setProperty:LOUPE_IDENTIFIER forKey:@"defaults"];
        [tweakEnabledSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:tweakEnabledSpec];
        
        //WebView
        PSSpecifier *enabledOnWebViewGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Magnifying Glass" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [enabledOnWebViewGroupSpec setProperty:@"Enable magnifying glass in web views." forKey:@"footerText"];
        [rootSpecifiers addObject:enabledOnWebViewGroupSpec];
        
        PSSpecifier *enabledOnWebViewSpec = [PSSpecifier preferenceSpecifierNamed:@"Web View" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [enabledOnWebViewSpec setProperty:@"Web View" forKey:@"label"];
        [enabledOnWebViewSpec setProperty:@"enabledOnWebView" forKey:@"key"];
        [enabledOnWebViewSpec setProperty:@YES forKey:@"default"];
        [enabledOnWebViewSpec setProperty:LOUPE_IDENTIFIER forKey:@"defaults"];
        [enabledOnWebViewSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:enabledOnWebViewSpec];
        
        //forceTrackpadMagnify
        PSSpecifier *forceTrackpadMagnifyGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [forceTrackpadMagnifyGroupSpec setProperty:@"Enable magnifying glass in trackpad mode." forKey:@"footerText"];
        [rootSpecifiers addObject:forceTrackpadMagnifyGroupSpec];
        
        PSSpecifier *forceTrackpadMagnifySpec = [PSSpecifier preferenceSpecifierNamed:@"Trackpad" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [forceTrackpadMagnifySpec setProperty:@"Trackpad" forKey:@"label"];
        [forceTrackpadMagnifySpec setProperty:@"forceTrackpadMagnify" forKey:@"key"];
        [forceTrackpadMagnifySpec setProperty:@NO forKey:@"default"];
        [forceTrackpadMagnifySpec setProperty:LOUPE_IDENTIFIER forKey:@"defaults"];
        [forceTrackpadMagnifySpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:forceTrackpadMagnifySpec];
        
        //xOffset
        PSSpecifier *xOffsetGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [xOffsetGroupSpec setProperty:@"Horizontal offset of magnifying region from cursor." forKey:@"footerText"];
        [rootSpecifiers addObject:xOffsetGroupSpec];
        
        PSSpecifier *xOffsetSpec = [PSSpecifier preferenceSpecifierNamed:@"Offset" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSliderCell edit:nil];
        [xOffsetSpec setProperty:@"xOffset" forKey:@"key"];
        [xOffsetSpec setProperty:@(-100) forKey:@"min"];
        [xOffsetSpec setProperty:@100 forKey:@"max"];
        [xOffsetSpec setProperty:@YES forKey:@"showValue"];
        [xOffsetSpec setProperty:@YES forKey:@"isSegmented"];
        [xOffsetSpec setProperty:@200 forKey:@"segmentCount"];
        [xOffsetSpec setProperty:@0 forKey:@"default"];
        [xOffsetSpec setProperty:LOUPE_IDENTIFIER forKey:@"defaults"];
        [xOffsetSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:xOffsetSpec];
        
        //yOffset
        PSSpecifier *yOffsetGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [yOffsetGroupSpec setProperty:@"Vertical offset of magnifying region from cursor." forKey:@"footerText"];
        [rootSpecifiers addObject:yOffsetGroupSpec];
        
        PSSpecifier *yOffsetSpec = [PSSpecifier preferenceSpecifierNamed:@"Offset" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSliderCell edit:nil];
        [yOffsetSpec setProperty:@"yOffset" forKey:@"key"];
        [yOffsetSpec setProperty:@(-100) forKey:@"min"];
        [yOffsetSpec setProperty:@100 forKey:@"max"];
        [yOffsetSpec setProperty:@YES forKey:@"showValue"];
        [yOffsetSpec setProperty:@YES forKey:@"isSegmented"];
        [yOffsetSpec setProperty:@200 forKey:@"segmentCount"];
        [yOffsetSpec setProperty:@0 forKey:@"default"];
        [yOffsetSpec setProperty:LOUPE_IDENTIFIER forKey:@"defaults"];
        [yOffsetSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:yOffsetSpec];
        
        //blank
        PSSpecifier *blankSpecGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:blankSpecGroup];
        
        //Support Dev
        PSSpecifier *supportDevGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Development" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:supportDevGroupSpec];
        
        PSSpecifier *supportDevSpec = [PSSpecifier preferenceSpecifierNamed:@"Support Development" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [supportDevSpec setProperty:@"Support Development" forKey:@"label"];
        [supportDevSpec setButtonAction:@selector(donation)];
        [supportDevSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LoupePrefs.bundle/PayPal.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:supportDevSpec];
        
        
        //Contact
        PSSpecifier *contactGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Contact" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:contactGroupSpec];
        
        //Twitter
        PSSpecifier *twitterSpec = [PSSpecifier preferenceSpecifierNamed:@"Twitter" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [twitterSpec setProperty:@"Twitter" forKey:@"label"];
        [twitterSpec setButtonAction:@selector(twitter)];
        [twitterSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LoupePrefs.bundle/Twitter.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:twitterSpec];
        
        //Reddit
        PSSpecifier *redditSpec = [PSSpecifier preferenceSpecifierNamed:@"Reddit" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [redditSpec setProperty:@"Twitter" forKey:@"label"];
        [redditSpec setButtonAction:@selector(reddit)];
        [redditSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LoupePrefs.bundle/Reddit.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:redditSpec];
        
        //udevs
        PSSpecifier *createdByGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [createdByGroupSpec setProperty:@"Created by udevs" forKey:@"footerText"];
        [createdByGroupSpec setProperty:@1 forKey:@"footerAlignment"];
        [rootSpecifiers addObject:createdByGroupSpec];
        
        _specifiers = rootSpecifiers;
    }
    
    return _specifiers;
}

- (void)donation {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/udevs"] options:@{} completionHandler:nil];
}

- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/udevs9"] options:@{} completionHandler:nil];
}

- (void)reddit {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/user/h4roldj"] options:@{} completionHandler:nil];
}

-(void)_reallyRespring{
    NSURL *relaunchURL = [NSURL URLWithString:@"prefs:root=Loupe"];
    SBSRelaunchAction *restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:4 targetURL:relaunchURL];
    [[NSClassFromString(@"FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}

@end
