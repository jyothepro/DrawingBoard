//
//  DrawingBoardViewController.m
//  DrawingBoard
//
//  Created by Jyothidhar Pulakunta on 10/5/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import "DrawingBoardViewController.h"

@interface DrawingBoardViewController () {
		CGPoint lastPoint;
		CGPoint currentPoint;
		CGPoint location;
		UIImageView *drawImage;
}
@end

@implementation DrawingBoardViewController
@synthesize mirrorEffectState = _mirrorEffectState;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 400);
	[self.view addSubview:drawImage];
	
	[drawImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
	[drawImage.layer setBorderWidth: 2.0];
}

- (IBAction)clearBtn:(id)sender {
	drawImage.image = nil;
}

- (IBAction)saveBtn:(id)sender {
	UIGraphicsBeginImageContextWithOptions(drawImage.bounds.size, NO, 0.0);
	[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
	UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    // Was there an error?
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Image could not be saved. Please give access to the photos"
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"Close",
							  nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
														message:@"Image saved successfully to the photo album"
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"Close",
							  nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches
		   withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	
    
	location = [touch locationInView:touch.view];
    lastPoint = [touch locationInView:self.view];
    lastPoint.y -= 0;
	
    
	[super touchesBegan: touches withEvent: event];
}

-(CGPoint) getMirror:(CGPoint) src {
	CGPoint dst = src;
	dst.x = self.view.frame.size.width - dst.x;
	if (dst.x < 0) {
		dst.x *= -1;
	}
	return dst;
}

- (void)touchesMoved:(NSSet *)touches
		   withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	currentPoint = [touch locationInView:self.view];
	
    UIGraphicsBeginImageContext(CGSizeMake(320, 400));
    [drawImage.image drawInRect:CGRectMake(0, 0, 320, 400)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1, 0, 0, 1);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	
	if (_mirrorEffectState.selectedSegmentIndex == 0) {
		CGPoint mirrorlast = [self getMirror:lastPoint];
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), mirrorlast.x, mirrorlast.y);
		CGPoint mirrorCUrrent = [self getMirror:currentPoint];
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), mirrorCUrrent.x, currentPoint.y);
	}
	
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    
    [drawImage setFrame:CGRectMake(0, 0, 320, 400)];
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();


    UIGraphicsEndImageContext();
	lastPoint = currentPoint;
	
	[self.view addSubview:drawImage];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end