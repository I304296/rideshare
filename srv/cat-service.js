const cds = require("@sap/cds");
const axios = require('axios');
//const xsenv = require('@sap/xsenv');

const request = require('request');
const cfenv = require('cfenv');

module.exports = cds.service.impl(async srv => {
    const {
        Rides,
        Riders
    } = srv.entities;
    srv.on("completeRide", "Rides", async req => {

        const tx = cds.transaction(req);
        var url = "";
        var qToken = "";


        //Get riderID when rideID is passed in payload
        //const rides = await tx.run(SELECT.from(Rides).where({ID:req.data.rideID}));

        //Get riderID from the query param
        console.log(req.query.SELECT.where[2].val);
        const rides = await tx.run(SELECT.from(Rides).where({ ID: req.query.SELECT.where[2].val }));
        const riders = await tx.run(SELECT.from(Riders).where({ ID: rides[0].rider_ID }));

        var payload = {
            ride_ID: req.data.rideID,
            rideDate: rides[0].rideDate,
            rideAmount: rides[0].amount,
            rideCurrency: rides[0].curr_code,
            driver_ID: rides[0].driver_ID,
            rider_ID: riders[0].ID,
            riderFirstName: riders[0].firstName,
            riderLastName: riders[0].lastName,
            //riderEmail: riders[0].email
            riderEmail: req.data.surveyEmail
        }
        console.log(payload);

        // //**** Local Testing */
        // //var destinations = xsenv.filterServices({ label: 'destinations' });
        // var services = xsenv.readServices();
        // //var svc = services[process.env.destinations];
        // url = services.qualtrics.url;
        // qToken = services.qualtrics.token;
        // console.log(`URL: ${services.qualtrics.url}`);
        // console.log(`TOKEN: ${services.qualtrics.token}`);
        // //**** end of - Local Testing */

        //**** Server setting */
        /*********************************************************************
        *************** Step 1: Read the environment variables ***************
        *********************************************************************/
        //const oServices = cfenv.getAppEnv().getServices();
        const uaa_service = cfenv.getAppEnv().getService('uaa_app_router');
        const dest_service = cfenv.getAppEnv().getService('rides-destination');
        const sUaaCredentials = dest_service.credentials.clientid + ':' + dest_service.credentials.clientsecret;
        console.log(`1.1.sUaaCredentials:${JSON.stringify(sUaaCredentials)}`);

        const sDestinationName = 'qualtrics'; // Check destination under cockpit root -> connectivity
       // const sEndpoint = '/secure/';

        /*********************************************************************
        **** Step 2: Request a JWT token to access the destination service ***
        *********************************************************************/
        // var uaaURL = 'https://c0f03a16trial.authentication.eu10.hana.ondemand.com';

        //console.log(`2.uaa_service.credentials.url:${uaa_service.credentials[0]}`); //Issue
        console.log(`2.Preparing POST`);
        const post_options = {
            url: uaa_service.credentials.url + '/oauth/token', //'https://c0f03a16trial.authentication.eu10.hana.ondemand.com/oauth/token',
            method: 'POST',
            headers: {
                'Authorization': 'Basic ' + Buffer.from(sUaaCredentials).toString('base64'),
                'Content-type': 'application/x-www-form-urlencoded'
            },
            form: {
                'client_id': dest_service.credentials.clientid,
                'grant_type': 'client_credentials'
            }
        }
        console.log(`2.1.Call POST`);
        request(post_options, (err, res, data) => {
            if (res.statusCode === 200) {

                /*************************************************************
                 *** Step 3: Search your destination in the destination service ***
                *************************************************************/
                console.log(`3.data:${JSON.parse(data)}`);
                const token = JSON.parse(data).access_token;
                console.log(`4.token:${token}`);
                console.log(`5.dest. url:${dest_service.credentials.uri}`);
                const get_options = {
                    url: dest_service.credentials.uri + '/destination-configuration/v1/destinations/' + sDestinationName,
                    headers: {
                        'Authorization': 'Bearer ' + token
                    }
                }

                request(get_options, (err, res, data) => {

                    /*********************************************************
                     ********* Step 4: Access the destination securely *******
                    *********************************************************/
                    const oDestination = JSON.parse(data);
                    //const token = oDestination.authTokens[0];
                    console.log(`6.1.Qualtrocs URL:${oDestination.destinationConfiguration.URL}`);
                    url = oDestination.destinationConfiguration.URL;
                    console.log(`6.2.Qualtrocs token:${oDestination.destinationConfiguration.token}`);
                    qToken = oDestination.destinationConfiguration.token;
                    //*** Call Qualtrics */
                    //'https://iad1.qualtrics.com/inbound-event/v1/events/JSON/triggers?contextId=SV_cCKzAy3aICPmQKN&userId=UR_9BmQTS1ynq3aDJ3&brandId=dpeetrialaccount&triggerId=OC_O6VY2pkAKn2BVVD';
                    const qualtricsURL = url;

                    //'S9ZuEtn1RVIRsp6CPPJTqNqFen0sM3A49Bsyh44b'
                    //const token = services.qualtrics.token;
                    const config = {
                        headers: { 'X-API-TOKEN': qToken }
                    };


                    //Make call to Qualtrics
                    axios
                        .post(qualtricsURL, payload, config)
                        .then(res => {
                            //console.log(`statusCode: ${res.IncomingMessage}`)
                            var response = res;

                            console.log(`SUCCESS: Response Message \n` + JSON.stringify(response.data));
                        })
                        .catch(error => {
                            console.error(error)
                        });


                });
            }
        });

        //*** Call Qualtrics */
        //'https://iad1.qualtrics.com/inbound-event/v1/events/JSON/triggers?contextId=SV_cCKzAy3aICPmQKN&userId=UR_9BmQTS1ynq3aDJ3&brandId=dpeetrialaccount&triggerId=OC_O6VY2pkAKn2BVVD';
        const qualtricsURL = url;

        //'S9ZuEtn1RVIRsp6CPPJTqNqFen0sM3A49Bsyh44b'
        //const token = services.qualtrics.token;
        const config = {
            headers: { 'X-API-TOKEN': qToken }
        };


        //Make call to Qualtrics
        axios
            .post(qualtricsURL, payload, config)
            .then(res => {
                //console.log(`statusCode: ${res.IncomingMessage}`)
                var response = res;

                console.log(`SUCCESS: Response Message \n` + JSON.stringify(response.data));
            })
            .catch(error => {
                console.error(error)
            });

    });
});