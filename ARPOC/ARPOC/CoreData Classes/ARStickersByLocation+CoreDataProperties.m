//
//  ARStickersByLocation+CoreDataProperties.m
//
//
//  Created by Verma Mukesh on 25/02/18.
//
//

#import "ARStickersByLocation+CoreDataProperties.h"
#import "AppDelegate.h"
#import "NSDictionary+Extra.h"

#define APP_DELEGATE                (AppDelegate *)[[UIApplication sharedApplication] delegate]

@implementation ARStickersByLocation (CoreDataProperties)

+ (NSFetchRequest<ARStickersByLocation *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"ARStickersByLocation"];
}

@dynamic placeId;
@dynamic latitude;
@dynamic longitude;
@dynamic placeName;
@dynamic placeAddress;
@dynamic stickerName;

+(id)SaveARStickersByLocationDeatilsWithData:(NSDictionary *)dataDict
{
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    NSError *error = nil;
    
    ARStickersByLocation *loginObjInsert =  [NSEntityDescription insertNewObjectForEntityForName:@"ARStickersByLocation" inManagedObjectContext:context];
    
    [loginObjInsert setPlaceName:[dataDict ObjectForKeyWithNullChecking:@"placeName"]];
    [loginObjInsert setLatitude:[dataDict ObjectForKeyWithNullChecking:@"latitude"]];
    [loginObjInsert setLongitude:[dataDict ObjectForKeyWithNullChecking:@"longitude"]];
    [loginObjInsert setPlaceAddress:[dataDict ObjectForKeyWithNullChecking:@"placeAddress"]];
    [loginObjInsert setStickerName:[dataDict ObjectForKeyWithNullChecking:@"stickerName"]];
    [loginObjInsert setPlaceId:([[dataDict ObjectForKeyWithNullChecking:@"placeId"] integerValue])];
    
    if ([context save:&error]) {
        NSLog(@"saved successfully");
        return loginObjInsert;
    } else {
        NSLog(@"Failed to save User : %@", [error userInfo]);
        return nil;
    }
    
//    ARStickersByLocation *objUpdate=[self fetchARStickersByById:[[dataDict ObjectForKeyWithNullChecking:@"placeId"] integerValue]] ;
//    if (objUpdate!=nil) {
//
//        [objUpdate setPlaceName:[dataDict ObjectForKeyWithNullChecking:@"placeName"]];
//        [objUpdate setLatitude:[dataDict ObjectForKeyWithNullChecking:@"latitude"]];
//        [objUpdate setLongitude:[dataDict ObjectForKeyWithNullChecking:@"longitude"]];
//        [objUpdate setPlaceAddress:[dataDict ObjectForKeyWithNullChecking:@"placeAddress"]];
//        [objUpdate setStickerName:[dataDict ObjectForKeyWithNullChecking:@"stickerName"]];
//
//        [objUpdate setPlaceId:([[dataDict ObjectForKeyWithNullChecking:@"placeId"] integerValue])];
//
//
//        if ([context save:&error]) {
//            NSLog(@"saved successfully");
//
//            return objUpdate;
//        } else {
//            NSLog(@"Failed to save User : %@", [error userInfo]);
//            return nil;
//        }
//
//    }
//    else{
//
//        ARStickersByLocation *loginObjInsert =  [NSEntityDescription insertNewObjectForEntityForName:@"ARStickersByLocation" inManagedObjectContext:context];
//
//        [loginObjInsert setPlaceName:[dataDict ObjectForKeyWithNullChecking:@"placeName"]];
//        [loginObjInsert setLatitude:[dataDict ObjectForKeyWithNullChecking:@"latitude"]];
//        [loginObjInsert setLongitude:[dataDict ObjectForKeyWithNullChecking:@"longitude"]];
//        [loginObjInsert setPlaceAddress:[dataDict ObjectForKeyWithNullChecking:@"placeAddress"]];
//        [loginObjInsert setStickerName:[dataDict ObjectForKeyWithNullChecking:@"stickerName"]];
//        [loginObjInsert setPlaceId:([[dataDict ObjectForKeyWithNullChecking:@"placeId"] integerValue])];
//
//        if ([context save:&error]) {
//            NSLog(@"saved successfully");
//            return loginObjInsert;
//        } else {
//            NSLog(@"Failed to save User : %@", [error userInfo]);
//            return nil;
//        }
//
//    }
    return nil;
}

+(void)deleteARStickersByLocationDetail
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ARStickersByLocation" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *object = [context executeFetchRequest:request error:&error];
        
        for (NSInteger i=0; i<[object count]; i++) {
            [context deleteObject:[object objectAtIndex:i]];
        }
        
        if ([context save:&error]) {
            NSLog(@"User Deleted Succesfully!");
        } else {
            NSLog(@"User Deletion Failed : %@", [error userInfo]);
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(id)fetchARStickersByById:(NSInteger)StateId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ARStickersByLocation" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        // *** Set Predicate to Find Users with ID ***
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(placeId =%d)", StateId];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if([objects count] > 0)
            return [objects objectAtIndex:0];
        else
            return nil;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(NSArray *)fetchARStickersByLocation
{
    
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ARStickersByLocation" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        return objects;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end


