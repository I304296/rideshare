using from './cat-service';

annotate RideService.Drivers with @(
    UI: {
        Identification: [ {Value: firstName} ],
        SelectionFields: [ firstName ],
        LineItem: [
            {Value: ID},
            //{Value: firstName},
            {$Type: 'UI.DataField', Value: firstName, Label: 'First Name', "@UI.Importance": #High},
            {Value: lastName},
            {Value: status_descr, Criticality: status},
            //{$Type: 'UI.DataField', Value: status_descr, criticality: 'status_code', Label: 'Status', "@UI.Importance": #High},
            {$Type: 'UI.DataFieldForAnnotation', Label: 'Rating Indicator', Target: '@UI.DataPoint#AverageRatingValue', "@UI.Importance": #High}
        ],
        DataPoint#AverageRatingValue: {
            Title: 'Rating Indicator',
            Value: rating,
            Description: 'Rating Indicator',  
			TargetValue: 5,
			Visualization: #Rating
		},
        HeaderInfo: {
            TypeName: 'Driver',
            TypeNamePlural: 'Drivers',
            Title: {Value: firstName},
            Description: {Value: ID}
        },
        HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#DrivingSince', "@UI.Importance": #Medium},
		],
		FieldGroup#DrivingSince: {
			Data: [ {$Type: 'UI.DataField', Value: joined} ]
		},
	    // Page Facet
	    Facets:[
			{$Type: 'UI.ReferenceFacet', Label: 'Personal Info', Target: '@UI.FieldGroup#DriverInfo'},
            {$Type: 'UI.ReferenceFacet', Label: 'Performance Info', Target: '@UI.FieldGroup#Performance'},
		],
		FieldGroup#DriverInfo: {
			Label: 'Personal Info',
			Data: [
				{$Type: 'UI.DataField', Value: firstName, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: lastName, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: email, "@UI.Importance": #Medium}
			]
		},
		FieldGroup#Performance: {
			Label: 'Performance',
			Data: [
				//{$Type: 'UI.DataField', Value: rating, "@UI.Importance": #Medium},
                //{$Type: 'UI.DataField', Value: status, "@UI.Importance": #Medium},
                {Value: status_descr, Criticality: status},
                {$Type: 'UI.DataFieldForAnnotation', Label: 'Rating Indicator', Target: '@UI.DataPoint#AverageRatingValue', "@UI.Importance": #High}	
			]
		},       
    }
);

annotate RideService.Drivers with {
    ID @title:'ID' @UI.HiddenFilter;
    firstName @title:'First Name';
    lastName @title:'Last Name';
    status @title:'Status';
    rating @title:'Rating';
    email @title:'E-Mail';
    joined @title:'Started Woking';
    status_descr @title:'Status';
};

annotate RideService.Riders with {
    ID @title:'ID' @UI.HiddenFilter;
    firstName @title:'First Name';
    lastName @title:'Last Name';
    email @title:'E-mail';
    promotionProgram @title:'Frequent-Travel';
    paymentMethod @title:'Preffered Payment';

};

annotate RideService.Rides with @(
    UI: {
        //List Page
        SelectionFields: [ rideDate ],
        LineItem: [
            {Value: rideDate, "@UI.Importance": #Low},
            {$Type: 'UI.DataField', Value: driver.firstName, Label: 'Driver''s Name'},
            {$Type: 'UI.DataField', Value: rider.firstName, Label: 'Rider''s Name'},
            {$Type: 'UI.DataField', Value: source, Label: 'Start'},
            {$Type: 'UI.DataField', Value: destination, Label: 'End'},
            {$Type: 'UI.DataField', Value: amount},
            {$Type: 'UI.DataFieldForAnnotation', Label: 'Ride Rating', Target: '@UI.DataPoint#AverageRatingValue', "@UI.Importance": #High}
        ],
        DataPoint#AverageRatingValue: {
            Title: 'Rating Indicator',
            Value: rating,
            Description: 'Rating Indicator',  
			TargetValue: 5,
			Visualization: #Rating
		},
        // Object Page 
        HeaderInfo: {
            TypeName: 'Rides',
            TypeNamePlural: '{i18n>RidePlural}',
            Title: {Value: rideDate},
            Description: {Value: ID}
            //{$Type: 'UI.DataFieldForAnnotation', Label: "Launch Survey", Target : '@UI.DataFieldForAction#LaunchSurvey'}
        },
        Identification:[
            {Value: ID},
            {
                $Type              : 'UI.DataFieldForAction',
                Label              : 'Complete Ride',
                Action             : 'RideService.completeRide'
            }
        ],   
	    Facets:[
            {$Type: 'UI.ReferenceFacet', Label: 'Journey Info', Target: '@UI.FieldGroup#JourneyInfo'},
			{$Type: 'UI.ReferenceFacet', Label: 'Driver Info', Target: '@UI.FieldGroup#DriverInfo'},
            {$Type: 'UI.ReferenceFacet', Label: 'Rider Info', Target: '@UI.FieldGroup#RiderInfo'},
		], 
        FieldGroup#JourneyInfo: {
			Label: 'Journey Info',
			Data: [
				{$Type: 'UI.DataField', Value: source, Label: 'Pickup Point'},
				{$Type: 'UI.DataField', Value: destination, Label: 'Dropping Point'},
				{$Type: 'UI.DataField', Value: amount, "@UI.Importance": #High},
			]
		},
        FieldGroup#DriverInfo: {
			Label: 'Driver Info',
			Data: [
				{$Type: 'UI.DataField', Value: driver.firstName, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: driver.lastName, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: driver.email, "@UI.Importance": #Medium},
                {$Type: 'UI.DataFieldForAnnotation', Label: 'Driver''s Rating', Target: '@UI.DataPoint#DriverRatingValue', "@UI.Importance": #High}
			]
		},
        DataPoint#DriverRatingValue: {
            Title: 'Rating Indicator',
            Value: driver.rating,
            Description: 'Rating Indicator',  
			TargetValue: 5,
			Visualization: #Rating
		},
        FieldGroup#RiderInfo: {
			Label: 'Rider Info',
			Data: [
				{$Type: 'UI.DataField', Value: rider.firstName, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: rider.lastName, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: rider.email, "@UI.Importance": #Medium},
                {$Type: 'UI.DataField', Value: rider.promotionProgram, "@UI.Importance": #Medium},
                {$Type: 'UI.DataField', Value: rider.paymentMethod, "@UI.Importance": #Medium}
			]
		},                    
    }
);

annotate RideService.Rides with {
    ID @title:'ID' @UI.HiddenFilter;
    driver @title:'Driver';
    rider @title:'Rider';
    //amount @title:'Fare';
    amount @( Common.Label : 'Fare', Measures.ISOCurrency: curr_code);
    @UI.dataPoint: {  
    title:'Product Rating',   
    description: 'Rating Indicator',   
    targetValueElement: 'MaxRating',   
    visualization: #RATING
    }
    @EndUserText.label: 'Customer Rating'
    rating;
    rideDate @title:'Date';
    curr_code @title:'Currency';
}



