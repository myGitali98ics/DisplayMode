service Service {
  @odata.draft.enabled
  entity RootEntity {
    key ID                                  : Integer       @Common.Label: 'ID';
        StringProperty                      : String        @Common.Label: 'String Property';
        IntegerProperty                     : Integer       @Common.Label: 'Integer Property';
        NumberProperty                      : Decimal(4, 2) @Common.Label: 'Number Property';
        BooleanProperty                     : Boolean       @Common.Label: 'Boolean Property';
        DateProperty                        : Date          @Common.Label: 'Date Property';
        TimeProperty                        : Time          @Common.Label: 'Time Property';
        PropertyWithUnit                    : Integer64     @Common.Label: 'Property With Unit'      @Measures.Unit       : Unit;
        PropertyWithCurrency                : Integer64     @Common.Label: 'Property With Currency'  @Measures.ISOCurrency: Currency;
        Unit                                : String;
        Currency                            : String;
        TextProperty                        : String;
        TextArrangementTextOnlyProperty     : String        @Common      : {
          Text           : TextProperty,
          TextArrangement: #TextOnly
        };
        TextArrangementTextLastProperty     : String        @Common      : {
          Text           : TextProperty,
          TextArrangement: #TextLast
        };
        TextArrangementTextFirstProperty    : String        @Common      : {
          Text           : TextProperty,
          TextArrangement: #TextFirst
        };
        TextArrangementTextSeparateProperty : String        @Common      : {
          Text           : TextProperty,
          TextArrangement: #TextSeparate
        };
        PropertyWithValueHelp               : String        @(Common: {
          Label    : 'Property with Value Help',
          ValueList: {
            Label         : 'Value with Value Help',
            CollectionPath: 'ValueHelpEntity',
            Parameters    : [
              {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: PropertyWithValueHelp,
                ValueListProperty: 'KeyProp'
              },
              {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Description'
              }
            ]
          }
        });
        Criticality                         : Integer;
        dataFieldForAnnotationContact       : String;
        emailAddress                        : String        @Communication.IsEmailAddress;
        phoneNumber                         : String        @Communication.IsPhoneNumber;
        role                                : String;
        PostalCode                          : String;
        CityName                            : String;
        Country                             : String;
  }


  annotate RootEntity with @(
    Communication.Contact: {
      fn   : dataFieldForAnnotationContact,
      role : role,
      email: [{
        type   : #work,
        address: emailAddress
      }],
      tel  : [{
        type: #fax,
        uri : phoneNumber
      }],
      adr  : [{
        type    : #work,
        code    : PostalCode,
        country : Country,
        locality: CityName
      }]
    },
    UI                   : {HeaderInfo: {Title: {TypeImageUrl: 'sap-icon://add-contact'}}}
  );
  annotate RootEntity with @(UI: {LineItem: {
    ![@UI.Criticality]: Criticality,
    $value            : [
      {Value: ID},
      {Value: IntegerProperty},
      {Value: NumberProperty},
      {
        $Type : 'UI.DataFieldForAnnotation',
        Target: '@Communication.Contact',
        Label : 'Property With Contact annotation'
      },
      {Value: StringProperty},
      {Value: BooleanProperty},
      {Value: TextArrangementTextFirstProperty},
      {Value: PropertyWithValueHelp}
    ]
  }
  });
  entity ValueHelpEntity {
    key KeyProp     : String(1)  @(
          Common: {
            Text           : Description,
            TextArrangement: #TextFirst
          },
          title : 'Value Help Key'
        );
        Description : String(20) @(
          Core.Immutable: true,
          Common        : {Label: 'Value Help Description'}
        );
  }
}
