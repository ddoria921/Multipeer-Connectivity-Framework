//
//  ViewController.h
//  MultiPeer
//
//  Created by Darin Doria on 4/22/15.
//  Copyright (c) 2015 Doria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController : UIViewController

// MCPeerID
// MCSession
// MCNearbyServiceBrowser
// MCNearbyServiceAdvertiser

@property (strong, nonatomic) MCPeerID *myPeer;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;













@end

