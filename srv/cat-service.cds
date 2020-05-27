using { com.sap.qualtrics.rideshare as rs } from '../db/schema';

service RideService {
    entity Riders as projection on rs.Riders;
    @Capabilities : {
        Insertable : true,
        Updatable  : true,
        Deletable  : true
    }
    entity Drivers as projection on rs.Drivers;
    //entity Rides as select from rs.Rides;
    @Capabilities : {
        Insertable : false,
        Updatable  : true,
        Deletable  : false
    }
    entity Rides as
        select from rs.Rides{
            *
        } actions{
            action completeRide(
               // @(title : 'Complete Ride')
               // rideID:Rides.ID
                  surveyEmail: Rides.rider.email
            );
        }
}