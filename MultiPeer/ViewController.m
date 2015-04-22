//
//  ViewController.m
//  MultiPeer
//
//  Created by Darin Doria on 4/22/15.
//  Copyright (c) 2015 Doria. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // peer
    self.myPeer = [[MCPeerID alloc] initWithDisplayName:@"Darin"];
    
    // session
    self.session = [[MCSession alloc] initWithPeer:self.myPeer];
    self.session.delegate = self;
    
    // browser
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeer serviceType:@"forever-alone"];
    self.browser.delegate = self;
    
    // advertiser
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeer discoveryInfo:nil serviceType:@"forever-alone"];
    self.advertiser.delegate = self;

//    [self.advertiser startAdvertisingPeer];
    [self.browser startBrowsingForPeers];
}

#pragma mark - MCNearbyServiceAdvertiser
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    
    NSLog(@"Received invitation from %@", peerID.displayName);
    invitationHandler(YES, self.session);
}

#pragma mark - MCNearbyServiceBrowser Delegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    NSLog(@"Found %@!", peerID.displayName);
    [browser invitePeer:peerID toSession:self.session withContext:nil timeout:15.0f];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
    NSLog(@"Lost %@!", peerID.displayName);
}


#pragma mark - MCSession Delegates
- (void) session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSString* message;
    NSData * data;
    NSError *error;
    
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"Connected to peer %@", peerID.displayName);
            message = [NSString stringWithFormat:@"Let's be forever alone, together %@", peerID.displayName];
            data = [NSKeyedArchiver archivedDataWithRootObject:message];
            [self.session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:&error];
            if (error) {
                NSLog(@"Data failed to send %@", [error localizedDescription]);
            }
            break;
        case MCSessionStateConnecting:
            NSLog(@"Connecting to peer %@", peerID.displayName);
            break;
        case MCSessionStateNotConnected:
            NSLog(@"Disconnected from peer %@", peerID.displayName);
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSString *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"Peer %@ said: %@", peerID.displayName, message);
}










@end
