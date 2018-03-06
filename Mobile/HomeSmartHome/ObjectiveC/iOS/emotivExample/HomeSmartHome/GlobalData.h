//
//  GlobalData.h
//  MentalCommand
//
//  Created by Nawal Kh on 6/3/1439 AH.
//

#import <Foundation/Foundation.h>
#import "EngineWidget.h"

@interface GlobalData : NSObject
{
NSString *_message;
    EngineWidget *engineWidget;
}

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) EngineWidget *engineWidget;


+ (GlobalData*) sharedGlobalData;


@end
