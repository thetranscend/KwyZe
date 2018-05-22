//
//  ARStickersByLocation+CoreDataProperties.h
//  ARPOC
//
//  Created by Verma Mukesh on 25/02/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//
//

#import "ARStickersByLocation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ARStickersByLocation (CoreDataProperties)

+ (NSFetchRequest<ARStickersByLocation *> *)fetchRequest;

@property (nonatomic) int64_t placeId;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, copy) NSString *placeName;
@property (nullable, nonatomic, copy) NSString *placeAddress;
@property (nullable, nonatomic, copy) NSString *stickerName;

+(id)SaveARStickersByLocationDeatilsWithData:(NSDictionary *)dataDict;
+(void)deleteARStickersByLocationDetail;
+(id)fetchARStickersByById:(NSInteger)StateId;
+(NSArray *)fetchARStickersByLocation;

@end

NS_ASSUME_NONNULL_END
