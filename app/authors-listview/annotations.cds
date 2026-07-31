using BookstoreService as service from '../../srv/service';
annotate service.Authors with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'EBook',
            ID : 'EBook',
            Target : '@UI.FieldGroup#EBook',
        },
    ],
    UI.FieldGroup #EBook : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : content,
                Label : 'EBook file',
            },
            {
                $Type : 'UI.DataField',
                Value : attachments.up_.name,
                Label : 'name',
            },
        ],
    },
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : name,
            Label : 'name',
        },
        {
            $Type : 'UI.DataField',
            Value : fileName,
            Label : 'fileName',
        },
    ],
);

