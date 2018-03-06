//
//  GlobalData.m
//  MentalCommand
//
//  Created by Nawal Kh on 6/3/1439 AH.
//

#import "GlobalData.h"


@implementation GlobalData

@synthesize message = _message;
@synthesize engineWidget= _engineWidget;



+ (GlobalData*)sharedGlobalData{
 
    static dispatch_once_t onceToken;
    static GlobalData *instance = nil;
    
    dispatch_once(&onceToken, ^{ instance = [[GlobalData alloc] init];});
    
return instance;
}

-(id) init{
    self= [super init];
    
    if(self){
        _message = nil;
        _engineWidget = [[EngineWidget alloc] init];
    }
    return self;
}




@end
