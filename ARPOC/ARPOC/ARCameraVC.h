//
//  ARCameraVC.h
//  ARPOC
//
//  Created by Mukesh Verma on 2/23/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "StickerCollectionCell.h"
#import "ARStickersByLocation+CoreDataClass.h"
#import <GoogleMaps/GoogleMaps.h>



@interface ARCameraVC : UIViewController<ARSCNViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *arrStickers;
    
    
}
- (IBAction)btnBackTapped:(id)sender;
@property(nonatomic,strong) GMSMarker *objLocation;
- (IBAction)btnSaveTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *stickerCollectionView;
@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property(nonatomic,strong) NSString *strStickerName;
@end
