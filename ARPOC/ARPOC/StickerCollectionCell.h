//
//  StickerCollectionCell.h
//  ARPOC
//
//  Created by Verma Mukesh on 24/02/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
- (IBAction)btnDSaveTapped:(id)sender;

@end
