#import "TimeInCC.h"


%group TimeInCC


/* Assign the CCUISensorStatusButton to our global variable for later use */
%hook CCUISensorStatusView

-(void)layoutSubviews {
	%orig;
	statusButton = MSHookIvar<CCUISensorStatusButton *>(self, "_cameraSensorStatusButton");
}

%end


/*
	Prevent new aissignments of the CCUIStatusButton by changing the code within the update function
*/
%hook CCUIModularControlCenterOverlayViewController

%new
- (CCUISensorActivityData *)setupTimeAsSensorActivityData {
	// Put the NSString into a NSMutableString to prevent 
	// weird output if NSDateFormatter declared faulty
	[labelString setString:@""];
	if (customTextEnabled) {
		[labelString appendString:customText];
	}
	if (displayDateEnabled) {
		NSDate *now = [NSDate date];
		[outputFormatter setDateFormat:dateFormat];
		NSString *dateString = [outputFormatter stringFromDate:now];
		[labelString appendString:dateString];
	}

	[activityData setDisplayName:labelString];
	[activityData setAttributionGroup:labelString];
	// [activityData setBundleIdentifier: @"com.apple.mobiletime"];
	[activityData setBundleIdentifier: @"com.apple.camera"];
	[activityData setSensorType:0];	// 0 = Cam, 1 = Mic
	[activityData setUsedRecently:NO];
	[activityData setLaunchToSettings:NO];
	return activityData;
}


-(void)_updateSensorActivityStatusForHeaderPocketView {
	// Completely override creating any additional CCUISensorStatusViews and -Buttons	
	%orig;
	CCUIHeaderPocketView *pocketView = MSHookIvar<CCUIHeaderPocketView *>(self, "_headerPocketView");
	[pocketView addSensorStatusForStatusType:0 sensorActivityData:[self setupTimeAsSensorActivityData]];
}

%end


%hook CCUISensorStatusButton

%new
-(void)updateTimeLabel {

	NSDate *now = [NSDate date];
	[outputFormatter setDateFormat:dateFormat];
	NSString *dateString = [outputFormatter stringFromDate:now];

	[labelString setString:@""];
	if (customTextEnabled) {
		[labelString appendString:customText];
	}

	// don't need to check if displayDateEnabled as we already checked for it
	[labelString appendString:dateString];
	
	[timeLabel setText:labelString];
}

-(void)layoutSubviews{
	%orig;

	// This should be the final method which is called to modidfy the label. 
	// So here we can modify the subviews

	// ! Not the ideal solution !
	// We remove the Camera icon after it's being created. Therefore we remove 2 views  
	UIImageView *icon = MSHookIvar<UIImageView *>(self, "_settingsLaunchIndicatorImageView");
	[icon removeFromSuperview];
	UIView *indiView = MSHookIvar<UIView *>(self, "_indicatorView");
	[indiView removeFromSuperview];

	// Hook into the label to modify its position, width and height based on its superview
	timeLabel = MSHookIvar<UILabel *>(self, "_descriptionLabel");

	// Set the labels width equal to the superviews (buttons) width and center the text within the label
	[timeLabel setFrame:CGRectMake(0, 2, statusButton.frame.size.width, statusButton.frame.size.height)];
	[timeLabel setTextAlignment:NSTextAlignmentCenter];

	if (displayDateEnabled) {
		if (updateLabelTimer == nil) {
			// create an NSTimer object to update our label string every second
			updateLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f 
			target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
		}
	}
}

%end


/* Delete the NSTimer after we leave the control center */
%hook CCUIModuleCollectionViewController

-(void)viewWillDisappear:(BOOL)arg1 {
	%orig;

	// Stop and delete the timer
	[updateLabelTimer invalidate];
	updateLabelTimer = nil;

}
%end

%end



%ctor {
	// Get preferences from preference bundle; if not registered yet, use default
	// registration is only done, when the user changes a preference
	preferences = [[HBPreferences alloc] initWithIdentifier:prefBundleID];

	[preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];

	[preferences registerBool:&customTextEnabled default:NO forKey:@"customTextEnabled"];
	[preferences registerObject:&customText default:@"" forKey:@"customText"];

	[preferences registerBool:&displayDateEnabled default:YES forKey:@"displayDateEnabled"];
	[preferences registerObject:&dateFormat default:@"HH:mm" forKey:@"dateFormat"];


	if (isEnabled) {
		// init objects as global variable once, so that we are not allocating storage 
		// everytime by declaring a new variable and leaving the old behind
		activityData = [[objc_getClass("CCUISensorActivityData") alloc] init];
		labelString = [[NSMutableString alloc] initWithCapacity:50];

		if (displayDateEnabled) {
			outputFormatter = [[NSDateFormatter alloc] init];
		}
		%init(TimeInCC);
	}

}