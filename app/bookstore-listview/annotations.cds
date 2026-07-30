using BookstoreService as service from '../../srv/service';
using from '@sap/cds/common';

annotate service.Books with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'published at',
                Value : publishedAt,
            },
            {
                $Type : 'UI.DataField',
                Value : genre_code,
                Label : 'Genre',
            },
            {
                $Type : 'UI.DataField',
                Label : 'pages',
                Value : pages,
            },
            {
                $Type : 'UI.DataField',
                Label : 'price',
                Value : price,
            },
            {
                $Type : 'UI.DataField',
                Value : currency_code,
                Label : 'Currency',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.ConnectedFields#connected',
                Label : 'Book Status',
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Entry Infomation',
            ID : 'EntryInfomation',
            Target : '@UI.FieldGroup#EntryInfomation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Chapters',
            ID : 'Chapters',
            Target : 'chapters/@UI.LineItem#Chapters',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Value : status_code,
            Label : 'status_code',
            Criticality : status.criticality,
        },
        {
            $Type : 'UI.DataField',
            Value : stock,
            Label : 'stock',
        },
        {
            $Type : 'UI.DataField',
            Label : 'genre',
            Value : genre_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'publishedAt',
            Value : publishedAt,
        },
        {
            $Type : 'UI.DataField',
            Label : 'pages',
            Value : pages,
        },
        {
            $Type : 'UI.DataField',
            Label : 'price',
            Value : price,
        },
        {
            $Type : 'UI.DataField',
            Value : author_ID,
            Label : 'author_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : author.name,
            Label : 'name',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'BookstoreService.addStock',
            Label : 'addStock',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'BookstoreService.changePulishData',
            Label : 'changePulishData',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'BookstoreService.changeStatus',
            Label : 'changeStatus',
        },
    ],
    UI.SelectionFields : [
        price,
        status_code,
        genre.description,
    ],
    UI.HeaderInfo : {
        TypeName : 'Book',
        TypeNamePlural : 'Books',
        Title : {
            $Type : 'UI.DataField',
            Value : title,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : ID,
        },
        TypeImageUrl : 'sap-icon://course-book',
    },
    UI.HeaderFacets : [
        
    ],
    UI.FieldGroup #EntryInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    },
    UI.FieldGroup #EntryInfomation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : modifiedAt,
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy,
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy,
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
            },
        ],
    },
    Communication.Contact #contact : {
        $Type : 'Communication.ContactType',
        fn : status_code,
    },
    UI.ConnectedFields #connected : {
        $Type : 'UI.ConnectedFieldsType',
        Template : '{status_code} {stock}',
        Data : {
            $Type : 'Core.Dictionary',
            status_code : {
                $Type : 'UI.DataField',
                Value : status_code,
                Criticality : status.criticality,
            },
            stock : {
                $Type : 'UI.DataField',
                Value : stock,
                Criticality : status.criticality,
            },
        },
    },
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'BookstoreService.addStock',
            Label : 'addStock',
        },
    ],
);

annotate service.Books with {
    author @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Authors',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : author_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
        ],
    }
};

annotate service.Books with {
    price @Common.Label : 'price'
};

annotate service.Chapters with @(
    UI.LineItem #Chapters : [
        {
            $Type : 'UI.DataField',
            Value : book.chapters.book_ID,
            Label : 'book ID',
        },
        {
            $Type : 'UI.DataField',
            Value : book.chapters.number,
            Label : 'number',
        },
        {
            $Type : 'UI.DataField',
            Value : book.chapters.ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Value : book.chapters.book.title,
            Label : 'title',
        },
    ]
);

annotate service.Books with {
    status @(
        Common.Text : status.displayText,
        Common.Text.@UI.TextArrangement : #TextOnly,
        Common.Label : 'status_code',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'BookStatus',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status_code,
                    ValueListProperty : 'code',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.BookStatus with {
    code @(
        Common.Text : displayText,
        Common.Text.@UI.TextArrangement : #TextOnly,
)};

annotate service.Books with {
    currency @Common.ValueListWithFixedValues : true
};

annotate service.Currencies with {
    code @(
        Common.Text : name,
        Common.Text.@UI.TextArrangement : #TextFirst,
)};

annotate service.Books with {
    genre @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Genres',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : genre_code,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Genre',
        },
        Common.ValueListWithFixedValues : true,
)};

annotate service.Genres with {
    description @(
        Common.Label : 'genre/description',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Genres',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : description,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Genres',
        },
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Genres with {
    code @Common.Text : description
};

