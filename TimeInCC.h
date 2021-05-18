#import <Cephei/HBPreferences.h>

@interface CCUISensorActivityData : NSObject <NSCopying> 
@property (assign,nonatomic) unsigned long long sensorType;               
@property (nonatomic,copy) NSString * displayName;                       
@property (nonatomic,copy) NSString * bundleIdentifier;               
@property (nonatomic,copy) NSString * attributionGroup;                   
@property (nonatomic,retain) UIColor * sensorIndicatorColor;              
@property (assign,nonatomic) BOOL usedRecently;                           
@property (assign,nonatomic) BOOL launchToSettings; 
-(NSString *)displayName;
-(void)setDisplayName:(NSString *)arg1 ;
-(unsigned long long)sensorType;
-(void)setSensorType:(unsigned long long)arg1 ;
-(BOOL)launchToSettings;
-(void)setLaunchToSettings:(BOOL)arg1 ;
-(BOOL)usedRecently;
-(void)setUsedRecently:(BOOL)arg1 ;
-(UIColor *)sensorIndicatorColor;
-(void)setSensorIndicatorColor:(UIColor *)arg1 ;
-(NSString *)attributionGroup;
-(void)setAttributionGroup:(NSString *)arg1 ;
@end


@interface CCUISensorStatusButton : UIButton {
	UILabel* _descriptionLabel;
	UIView* _indicatorView;
	UIImageView* _settingsLaunchIndicatorImageView;
}
-(void)layoutSubviews;
// %new
-(void)updateLabelText;
@end


@interface CCUISensorStatusView : UIView 
-(void)layoutSubviews;
@end


@interface CCUIHeaderPocketView : UIView 
// arg1 0 when no Sensor in use and when Camera is used; 1 for microphone only
-(void)addSensorStatusForStatusType:(unsigned long long)arg1 sensorActivityData:(id)arg2 ;
@end


@interface CCUIModularControlCenterOverlayViewController {
	CCUIHeaderPocketView* _headerPocketView;
}
-(void)_updateSensorActivityStatusForHeaderPocketView;
// %new
- (CCUISensorActivityData *)setupTimeAsSensorActivityData ;
@end


@interface CCUIModuleCollectionViewController : UIViewController 
// - (void)viewWillAppear:(BOOL)arg1;
- (void)viewWillDisappear:(BOOL)arg1;
@end

// ----------------------------------------------------------------------------------------

NSString *prefBundleID = @"com.chrisknapp.timeinccpreferences";

// user preferences
HBPreferences *preferences;

BOOL isEnabled;

BOOL customTextEnabled;
NSString *customText;

BOOL displayDateEnabled;
NSString *dateFormat; 

// global variables - userpref based
NSMutableString *labelString;
NSDateFormatter *outputFormatter;
CCUISensorActivityData *activityData;

// global variables - views, objects etc.
CCUISensorStatusButton *statusButton; 
UILabel *timeLabel;
NSTimer *updateLabelTimer;