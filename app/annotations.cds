using FIFOComplianceService from '../srv/fifo-service';

annotate FIFOComplianceService.FIFOCompliance with @(

    UI.HeaderInfo : {
        TypeName       : 'Cumplimiento FIFO',
        TypeNamePlural : 'Cumplimientos FIFO',
        Title : {
            Value : OutboundDelivery
        },
        Description : {
            Value : MaterialDescription
        }
    },

    UI.SelectionFields : [
        Plant,
        Material,
        Batch,
        OutboundDelivery,
        FIFOComplianceStatus
    ],

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : Plant
        },
        {
            $Type : 'UI.DataField',
            Value : Material
        },
        {
            $Type : 'UI.DataField',
            Value : MaterialDescription
        },
        {
            $Type : 'UI.DataField',
            Value : Batch
        },
        {
            $Type : 'UI.DataField',
            Value : OutboundDelivery
        },
        {
            $Type : 'UI.DataField',
            Value : DispatchQuantity
        },
        {
            $Type : 'UI.DataField',
            Value : FIFOQuantity
        },
        {
            $Type : 'UI.DataField',
            Value : NonFIFOQuantity
        },
        {
            $Type : 'UI.DataField',
            Value : FIFOCompliancePercent
        },
        {
            $Type       : 'UI.DataField',
            Value       : FIFOComplianceStatus,
            Criticality : FIFOCriticality
        }
    ],

    UI.FieldGroup #General : {
        Data : [
            { Value : Plant },
            { Value : PlantName },
            { Value : StorageLocation },
            { Value : StorageLocationName },
            { Value : Material },
            { Value : MaterialDescription },
            { Value : MaterialType },
            { Value : Batch },
            { Value : ManufacturingDate },
            { Value : ShelfLifeExpirationDate }
        ]
    },

    UI.FieldGroup #Delivery : {
        Data : [
            { Value : OutboundDelivery },
            { Value : OutboundDeliveryItem },
            { Value : TransportationDocument },
            { Value : DeliveryDate },
            { Value : GoodsIssueDate }
        ]
    },

    UI.FieldGroup #FIFO : {
        Data : [
            { Value : StockQuantity },
            { Value : DispatchQuantity },
            { Value : FIFOQuantity },
            { Value : NonFIFOQuantity },
            { Value : FIFOCompliancePercent },
            { Value : FIFODeviationQuantity },
            { Value : FIFODeviationPercent },
            // Especificamos el tipo para que herede la criticidad en la vista de detalle
            { 
                $Type       : 'UI.DataField',
                Value       : FIFOComplianceStatus,
                Criticality : FIFOCriticality 
            }
        ]
    },

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Datos Generales',
            Target : '@UI.FieldGroup#General'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Entrega',
            Target : '@UI.FieldGroup#Delivery'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Cumplimiento FIFO',
            Target : '@UI.FieldGroup#FIFO'
        }
    ]
);


//using { FIFOFEFOService } from '../srv/fifo-service;
//using { FIFOFEFOService } from './fifo-service';

annotate FIFOFEFOService.FIFOComplianceMaintenance with {
    // Clave
    FIFOUUID                 @title: 'ID Único FIFO';

    // Organización
    Plant                    @title: 'Centro / Planta' 
                             @Common.FieldControl: #Mandatory; // Obligatorio
    PlantName                @title: 'Nombre de Planta';
    StorageLocation          @title: 'Almacén';
    StorageLocationName      @title: 'Nombre de Almacén';

    // Material
    Material                 @title: 'Material (Código)'
                             @Common.FieldControl: #Mandatory;
    MaterialDescription      @title: 'Descripción de Material';
    MaterialType             @title: 'Tipo de Material';
    BaseUnit                 @title: 'Unidad Base';
    ProductHierarchy         @title: 'Jerarquía de Producto';

    // Batch
    Batch                    @title: 'Lote / Batch';
    ManufacturingDate        @title: 'Fecha de Fabricación'; // Fiori mostrará un DatePicker automáticamente
    ShelfLifeExpirationDate  @title: 'Fecha de Vencimiento';  // Fiori mostrará un DatePicker automáticamente
    BatchStatus              @title: 'Estado del Lote';

    // Documento Logístico
    OutboundDelivery         @title: 'Entrega de Salida';
    OutboundDeliveryItem     @title: 'Posición de Entrega';
    TransportationDocument   @title: 'Documento de Transporte';
    GoodsIssueDate           @title: 'Fecha de Salida de Mercancías';
    DeliveryDate             @title: 'Fecha de Entrega';

    // Cantidades
    StockQuantity            @title: 'Cantidad en Stock';    // Fiori validará que sean solo números decimales
    DispatchQuantity         @title: 'Cantidad Despachada';
    FIFOQuantity             @title: 'Cantidad FIFO';
    NonFIFOQuantity          @title: 'Cantidad No FIFO';
    QuantityUnit             @title: 'Unidad de Medida (ISO)';

    // Valorización
    StockValue               @title: 'Valor de Stock';
    DispatchValue            @title: 'Valor Despachado';
    CurrencyCode             @title: 'Moneda';

    // Resultado FIFO
    FIFOCompliancePercent    @title: '% Cumplimiento FIFO';
    FIFOComplianceStatus     @title: 'Estado Cumplimiento FIFO';
    FIFODeviationQuantity    @title: 'Cantidad Desviación FIFO';
    FIFODeviationPercent     @title: '% Desviación FIFO';

    // Trazabilidad
    SourceSystem             @title: 'Sistema Origen';
    ProcessingDate           @title: 'Fecha de Procesamiento';
    ProcessingUser           @title: 'Usuario Procesador';
    CalculationRunID         @title: 'ID Corrida de Cálculo';
    Comments                 @title: 'Comentarios / Observaciones';
}

annotate FIFOFEFOService.FIFOComplianceMaintenance with @(

    // 1. AGREGA ESTO: Fuerza al Preview a recalcular en tiempo real mientras el usuario escribe
    Common.SideEffects : {
        $Type : 'Common.SideEffectsType',
        SourceProperties : [ DispatchQuantity, FIFOQuantity ],
        TargetProperties : [ NonFIFOQuantity, FIFOCompliancePercent, FIFODeviationQuantity, FIFODeviationPercent, FIFOComplianceStatus, FIFOCriticality ]
    },
    // Configuración de la Tabla Principal
        // 2. MODIFICA ESTO: Se añade la propiedad Criticality para activar los colores en la tabla
    UI.LineItem : [
        { Value : Plant },
        { Value : Material },
        { Value : MaterialDescription },
        { Value : Batch },
        { Value : OutboundDelivery },
        { Value : StockQuantity },
        { Value : DispatchQuantity },
        { 
            Value : FIFOCompliancePercent,   // <-- Añadimos el porcentaje a la tabla
            Criticality : FIFOCriticality    // <-- Le aplicamos el color dinámico (1, 2, 3)
        },
        { 
            Value : FIFOComplianceStatus,
            Criticality : FIFOCriticality,       // <-- Mapea el color dinámico (1, 2, 3)
            CriticalityRepresentation : #WithIcon // Muestra el color con un icono semántico de SAP
        }
    ],

    // Filtros de búsqueda rápidos
    UI.SelectionFields : [
        Plant,
        Material,
        OutboundDelivery,
        FIFOComplianceStatus
    ],

    // Cabecera de la página de detalle
    UI.HeaderInfo : {
        TypeName       : 'Registro FIFO (Mantenimiento)',
        TypeNamePlural : 'Registros FIFO (Mantenimiento)',
        Title          : { Value : MaterialDescription },
        Description    : { Value : Material }
    },
    
    // Secciones del formulario de edición (Draft)
    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Datos de la Organización y Material',
            Target : '@UI.FieldGroup#OrgAndMaterial'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Cantidades y FIFO',
            Target : '@UI.FieldGroup#Quantities'
        }
    ],
    
    UI.FieldGroup #OrgAndMaterial : {
        Data : [
            { Value : Plant },
            { Value : PlantName },
            { Value : StorageLocation },
            { Value : StorageLocationName },
            { Value : Material },
            { Value : MaterialDescription },
            { Value : Batch },
            { Value : ManufacturingDate }
        ]
    },

    UI.FieldGroup #Quantities : {
        Data : [
            { Value : StockQuantity },
            { Value : DispatchQuantity },
            { Value : FIFOQuantity },
            { Value : NonFIFOQuantity },
            { Value : QuantityUnit },
            { Value : FIFOCompliancePercent },
            { Value : FIFOComplianceStatus }
        ]
    }
);
