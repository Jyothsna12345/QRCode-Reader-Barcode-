//
//  ViewController.m
//  QRCodeReader
//
//  Created by vmoksha on 14/11/16.
//  Copyright © 2016 vmoksha. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic) BOOL * isReading;
@property (nonatomic,strong) AVCaptureSession * capturesession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * vedioPreviewLayer;

-(BOOL)startReading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isReading = NO;
    _capturesession = nil;
    NSLog(@"Testing");
    NSLog(@"Hi");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopReading:(id)sender
{

    if (!(_isReading))
    {
        
        if ([self startReading])
        {
            [_barBtnItemStart setTitle:@"Stop"];
            [_statusLbl setText:@"Scanning for QR Code..."];
        }
    }
    else
    {
       [self stopReading];
        [_barBtnItemStart setTitle:@"Start!"];
    }
    
    _isReading = !_isReading;
}

-(BOOL)startReading
{
    NSError * error;
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput * deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!(deviceInput))
    {
        NSLog(@"%@",[error localizedDescription]);
        return  NO;
    }
    _capturesession = [[AVCaptureSession alloc] init];
    [_capturesession addInput:deviceInput];
    
    AVCaptureMetadataOutput * captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [_capturesession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    _vedioPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_capturesession];
    [_vedioPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_vedioPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_vedioPreviewLayer];
    
    [_capturesession startRunning];
    
    return YES;
}

-(void)stopReading
{
    [_capturesession stopRunning];
    _capturesession = nil;
    
    [_vedioPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            [_statusLbl performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_barBtnItemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            
            _isReading = NO;
        }
    }
}


@end
