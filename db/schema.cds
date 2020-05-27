namespace com.sap.qualtrics.rideshare;
using { Currency, managed, cuid } from '@sap/cds/common';

type Status : Association to Statuses;

entity Statuses {
    key code: Integer;
    text: String;
}

entity Drivers: cuid,person{
    status: Integer;
    status_descr: String;
    rating: Decimal(5, 2);
    joined: Date
}


entity Riders: cuid,person{
    promotionProgram: String;
    paymentMethod: String;
}


entity Rides: cuid{
    driver: Association to Drivers;
    rider: Association to Riders;
    rideDate: Date;
    amount: Decimal(5, 2);
    curr: Currency;
    rating: Decimal(5, 2);
    source: String;
    destination: String;
}

aspect person{
    firstName: String;
    lastName: String;
    email: String;
}

/*
aspect CodeList @(
    cds.autoexpose,
    cds.persistence.skip : 'if-unused'
  ) {
    name  : localized String(255)  @title : '{i18n>Name}';
    descr : localized String(1000) @title : '{i18n>Description}';
  }
*/
