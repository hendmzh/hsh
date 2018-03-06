//
//  ViewController.m
//  MentalCommand
//
//  Created by EmotivLifeSciences.
//  Copyright (c) 2014 EmotivLifeSciences. All rights reserved.
//

#import "McViewController.h"
#import "GlobalData.h"
#import "MentalCommand-Swift.h"
#import "MentalCommand-Bridging-Header.h"


@implementation McViewController

AppConstants *appCons;
NSString *command;

- (void)viewDidLoad {
    [super viewDidLoad];
    engineWidget = [GlobalData sharedGlobalData].engineWidget;
    //engineWidget = [[EngineWidget alloc] init];
    engineWidget.delegate = self;
    
    currentPow = 0.0f;
    currentAct = Mental_Neutral;
    isTraining = false;
    appCons = [[AppConstants alloc] init];
    

    
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateCubePosition) userInfo:nil repeats:YES];
    [timer fire];
    
    dictionaryAction = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Mental_Neutral], @"Neutral", [NSNumber numberWithInt:Mental_Push], @"Push",[NSNumber numberWithInt:Mental_Right], @"Right", nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (id) init{
    
    if(self = [super init])
    {
        self.globalcommand= command;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTableAction:(UIButton *)sender {
    self.tableAction.hidden = !self.tableAction.hidden;
}

- (IBAction)trainingAction:(UIButton *)sender {
    if(!isTraining)
    {
        MentalAction_t action = (MentalAction_t)[[dictionaryAction objectForKey:self.btAction.titleLabel.text] integerValue];
        [engineWidget setActiveAction:action];
        [engineWidget setTrainingAction:action];
        [engineWidget setTrainingControl:Mental_Start];
        isTraining = true;
    }
}

- (IBAction)clearData:(UIButton *)sender {
    
    MentalAction_t action = (MentalAction_t)[[dictionaryAction objectForKey:self.btAction.titleLabel.text] integerValue];
    [engineWidget clearTrainingData:action];
    
}

-(void) updateCubePosition {

    [UIView animateWithDuration:0.2 animations:^{
        float range = currentPow * 4;
        
        if(currentAct == Mental_Neutral)
        {
           // [GlobalData sharedGlobalData].message= @"Neutral";
           // [appCons commandWithCom:@"Neutral"];
            
            command = @"Neutral";
        }
        //move cube to left or right direction
        if((currentAct == Mental_Right) && range > 0)
        {
            self.constraintCenterX.constant = MAX(-70, self.constraintCenterX.constant - range);
        }
        else if(self.constraintCenterX.constant != 0)
        {
            self.constraintCenterX.constant = self.constraintCenterX.constant > 0 ? MAX(0, self.constraintCenterX.constant - 4) : MIN(0, self.constraintCenterX.constant + 4);
        }
        
        //move cube to forward or backward direction
        if ((currentAct == Mental_Push) && range > 0)
        {
            //[GlobalData sharedGlobalData].message= @"push";
            //[appCons commandWithCom:@"Neutral"];
            command = @"push";
            
            self.viewCube.transform = CGAffineTransformScale(CGAffineTransformIdentity, MAX(0.3, self.viewCube.transform.a - currentPow/4), MAX(0.3, self.viewCube.transform.d - currentPow/4));
        }
        else if (self.viewCube.transform.a != 1)
        {
            float scale = self.viewCube.transform.a < 1 ? 0.05 : -0.05;
            self.viewCube.transform = CGAffineTransformScale(CGAffineTransformIdentity, MAX(1, self.viewCube.transform.a + scale), MAX(1, self.viewCube.transform.d + scale));
        }
        
    }];
}

#pragma mark UITableView
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dictionaryAction count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellString"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellString"];
    }
    cell.textLabel.text = [[dictionaryAction allKeys] objectAtIndex:indexPath.row];
    MentalAction_t action = (MentalAction_t)[[dictionaryAction objectForKey:[[dictionaryAction allKeys] objectAtIndex:indexPath.row]] integerValue];
    if([engineWidget isActionTrained:action])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableAction.hidden = true;
    [self.btAction setTitle:[[dictionaryAction allKeys] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    MentalAction_t action = (MentalAction_t)[[dictionaryAction objectForKey:[[dictionaryAction allKeys] objectAtIndex:indexPath.row]] integerValue];
    
    [self.labelSkillRating setText:[NSString stringWithFormat:@"SkillRating: %d%%", [engineWidget getSkillRating:action]]];
}

#pragma mark EngineWidget Delegate
-(void) emoStateUpdate:(MentalAction_t)currentAction power:(float)currentPower {
    currentAct = currentAction;
    currentPow = currentPower;
    self.constraintPower.constant = self.viewPowerBar.frame.size.height * currentPower;
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewPower layoutIfNeeded];
    }];
}

-(void) onMentalCommandTrainingStarted {
    
}

-(void) onMentalCommandTrainingCompleted {
    isTraining = false;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Training Completed" message:@"Action was trained completed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [self.tableAction reloadData];
}

-(void) onMentalCommandTrainingSuccessed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Training Successed" message:@"Do you want to accept this training?" delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
    [alert setDelegate:self];
    [alert show];
}

-(void) onMentalCommandTrainingFailed {
    isTraining = false;
}

-(void) onMentalCommandTrainingDataErased {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erase Completed" message:@"Action was erased completed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [self.tableAction reloadData];
}

-(void) onMentalCommandTrainingRejected {
    isTraining = false;
}

-(void) onMentalCommandTrainingSignatureUpdated {
    [self.tableAction reloadData];
}

#pragma mark UIAlertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [engineWidget setTrainingControl:Mental_Accept];
            break;
        case 0:
            [engineWidget setTrainingControl:Mental_Reject];
            break;
        default:
            break;
    }
}
@end
