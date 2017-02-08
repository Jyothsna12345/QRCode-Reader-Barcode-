//
//  ViewController.h
//  QRCodeReader
//
//  Created by vmoksha on 14/11/16.
//  Copyright © 2016 vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnItemStart;

- (IBAction)startStopReading:(id)sender;

@end

