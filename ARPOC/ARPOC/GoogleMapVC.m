//
//  GoogleMapVC.m
//  ARPOC
//
//  Created by Mukesh Verma on 2/23/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//

#import "GoogleMapVC.h"


#define kApiKey1 @"AIzaSyDskKDCnQslFDACxdeaVBoV1_Wpc2NWE1Q"
#define kApiKeyRestricted @"AIzaSyAhOkusjGqY-A5H8-YSAl3IH_S97lTyCcE"
#define kGoogleApiKey @"AIzaSyDOdxQB5HZ0mjJRqc6c3R9CBQdRJAFKvFw"


@interface GoogleMapVC ()

@end

@implementation GoogleMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnEnableLocation setHidden:YES];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshData) name:@"RefreshData" object:nil];
    arrARStickers=[[NSMutableArray alloc] initWithArray:[ARStickersByLocation fetchARStickersByLocation]];
    
    [self FetchLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Location

-(void)FetchLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
             [self.btnEnableLocation setHidden:NO];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    currentLocation=newLocation;
    [self createGoogleMap];
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    currentLocation = [locations lastObject];
    NSLog(@"locations = %@",locations);
    NSLog(@"lat%f - lon%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [self createGoogleMap];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.btnEnableLocation setHidden:NO];
}
#pragma Google Map
-(void)createGoogleMap
{
    [self.actView startAnimating];
    [locationManager stopUpdatingLocation];
    
    __block GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
         NSString *CountryArea=@"";
         if (placemark.locality) {
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
         }
         else
             {
            
             CountryArea = Address;
             }
         
             NSLog(@"%@",CountryArea);
             
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
         
         if (camera==nil) {
             
            camera=[GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:17 bearing:30 viewingAngle:45];
             mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
             mapView.myLocationEnabled = YES;
             self.view = mapView;
             mapView.delegate=self;
         }
         
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = currentLocation.coordinate;
         bounds = [bounds includingCoordinate:currentLocation.coordinate];
             marker.title = Address;
             marker.snippet = CountryArea;
             marker.map = mapView;
          //  [marker setIcon:[UIImage imageNamed:@"addARSticker"]];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
         if (camera==nil) {
             
             camera=[GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:17 bearing:30 viewingAngle:45];
             mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
             mapView.myLocationEnabled = YES;
             self.view = mapView;
             mapView.delegate=self;
         }
         
         
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = currentLocation.coordinate;
          bounds = [bounds includingCoordinate:currentLocation.coordinate];
             marker.title = @"Current Location";
             marker.map = mapView;
          //  [marker setIcon:[UIImage imageNamed:@"addARSticker"]];
             //return;
         }
     
     [arrARStickers enumerateObjectsUsingBlock:^(ARStickersByLocation  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         
         CLLocation *Objlocation =  [[CLLocation alloc] initWithLatitude:[obj.latitude doubleValue] longitude:[obj.longitude doubleValue]];
         
         GMSMarker *marker = [[GMSMarker alloc] init];
         marker.position = Objlocation.coordinate;
         bounds = [bounds includingCoordinate:Objlocation.coordinate];
         marker.title = obj.placeName;
         marker.snippet = obj.stickerName;
         
         UIColor *color =  [UIColor redColor];
         UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small",obj.stickerName]];// Image to mask with
         UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
         CGContextRef context = UIGraphicsGetCurrentContext();
         [color setFill];
         CGContextTranslateCTM(context, 0, image.size.height);
         CGContextScaleCTM(context, 1.0, -1.0);
         CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
         CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
         
         UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
         
         [marker setIcon:coloredImg];
         marker.map = mapView;
     }];
     
      [mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
         
      [self.actView stopAnimating];
     
     UIButton *btnLocation=[UIButton buttonWithType:UIButtonTypeSystem];
     [btnLocation addTarget:self action:@selector(btnCurrentLocationTapped:) forControlEvents:UIControlEventTouchUpInside];
     [btnLocation setFrame:CGRectMake(mapView.frame.size.width-60, mapView.frame.size.height-60, 40, 40)];
     [btnLocation setImage:[UIImage imageNamed:@"currentLocation"] forState:UIControlStateNormal];
     [mapView addSubview:btnLocation];
   
     
//     [self.view bringSubviewToFront:self.btnCurrentLocation];
//     [self.view bringSubviewToFront:self.btnEnableLocation];
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
//                                                            longitude:coordinate.longitude
//                                                                 zoom:17];
//    camera=[GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) zoom:17 bearing:30 viewingAngle:45];
//
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
////    marker.title = @"Micrp Parks";
////    marker.snippet = @"Noida";
//    marker.map = mapView;
//}

- (void)mapView:(GMSMapView *)mapView
didTapPOIWithPlaceID:(NSString *)placeID
           name:(NSString *)name
       location:(CLLocationCoordinate2D)location
{
     [self.actView startAnimating];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    CLLocation *Objlocation =  [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];

    [geocoder reverseGeocodeLocation:Objlocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = location;
             marker.title = Address;
             marker.snippet = CountryArea;
             marker.map = mapView;
            //[marker setIcon:[UIImage imageNamed:@"addARSticker"]];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = location;
             marker.title = @"Current Location";
             marker.map = mapView;
           // [marker setIcon:[UIImage imageNamed:@"addARSticker"]];
             //return;
         }
         
         [self.actView stopAnimating];
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
//{
//     NSLog(@"marker yes");
//    return YES;
//}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    
    ARCameraVC *objVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ARCameraVC"];
    [objVc setObjLocation:marker];
    if (marker.icon) {
        [objVc setStrStickerName:marker.snippet];
    }
    [self.navigationController pushViewController:objVc animated:YES];
    NSLog(@"marker tapped");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)RefreshData
{
    arrARStickers=[[NSMutableArray alloc] initWithArray:[ARStickersByLocation fetchARStickersByLocation]];
    
    camera=nil;
    
    [self FetchLocation];
}

- (IBAction)btnEnableLocationTapped:(id)sender {
    [self FetchLocation];
}

- (IBAction)btnCurrentLocationTapped:(id)sender {
    
    if (currentLocation) {
        
        mapView.camera = [GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:17];
        //[mapView animateToLocation:currentLocation.coordinate];
    }
   
//    ARCameraVC *objVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ARCameraVC"];
//    [self.navigationController pushViewController:objVc animated:YES];
    
}
@end
