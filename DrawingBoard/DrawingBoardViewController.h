//
//  DrawingBoardViewController.h
//  DrawingBoard
//
//  Created by Jyothidhar Pulakunta on 10/5/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingBoardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *mirrorEffectState;

- (IBAction)clearBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;


@end
