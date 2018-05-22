//
//  ARCameraVC.m
//  ARPOC
//
//  Created by Mukesh Verma on 2/23/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//

#import "ARCameraVC.h"

@interface ARCameraVC ()

@end

@implementation ARCameraVC

@synthesize strStickerName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = NO;
    
    // Create a new scene
   
    
    self.sceneView.autoenablesDefaultLighting = NO;
    self.sceneView.automaticallyUpdatesLighting = NO;
    
   
    
    arrStickers=[[NSMutableArray alloc] init];
    [arrStickers addObject:@"begging"];
    [arrStickers addObject:@"bully"];
    [arrStickers addObject:@"child_labour"];
    [arrStickers addObject:@"rough sleep"];
    
    // We insert the geometry slightly above the point the user tapped, so that it drops onto the plane
    // using the physics engine
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self AddNode];
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection=ARPlaneDetectionHorizontal;
    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
}

-(void)AddNode
{
    SCNScene *scene = [SCNScene new];//
    SCNMaterial *silverMaterial = [SCNMaterial material];
    silverMaterial.diffuse.contents = [UIImage imageNamed:strStickerName];
    
    SCNBox *horizontalBarOne = [SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0];
    SCNNode *horizontalBarOneNode = [SCNNode nodeWithGeometry:horizontalBarOne];
    horizontalBarOneNode.position = SCNVector3Make(0, -1, -2);
    horizontalBarOne.materials = @[silverMaterial];
    [scene.rootNode addChildNode:horizontalBarOneNode];
    
    //    UIImage *env = [UIImage imageNamed: @"art.scnassets/texture.png"];
    //    self.sceneView.scene.lightingEnvironment.contents = env;
    
    // Set the scene to the view
    self.sceneView.scene = scene;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate


// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
    
    // Add geometry to the node...
    
    return node;
}


- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    NSLog(@"error occured =%@",error);
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    NSLog(@"Session interrupted");
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    NSLog(@"Session interrupted end");
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrStickers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgIcon setImage:[UIImage imageNamed:[arrStickers objectAtIndex:indexPath.row]]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    strStickerName=[arrStickers objectAtIndex:indexPath.row];
    [self.sceneView.scene.rootNode removeFromParentNode];
    
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration:configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    [self AddNode];
}

- (IBAction)btnSaveTapped:(id)sender {
    
    if (strStickerName==nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Please select one sticker"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    NSMutableDictionary *objDicc=[[NSMutableDictionary alloc] init];
    [objDicc setObject:strStickerName forKey:@"stickerName"];
    [objDicc setObject:self.objLocation.title forKey:@"placeName"];
    [objDicc setObject:self.objLocation.snippet forKey:@"placeAddress"];
    [objDicc setObject:[NSString stringWithFormat:@"%f",self.objLocation.position.latitude] forKey:@"latitude"];
   [objDicc setObject:[NSString stringWithFormat:@"%f",self.objLocation.position.longitude] forKey:@"longitude"];
    
    [ARStickersByLocation SaveARStickersByLocationDeatilsWithData:objDicc];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
