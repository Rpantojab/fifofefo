using {managed, Currency} from '@sap/cds/common';

namespace com.agrosuper;

type FIFOComplianceStatusType : String enum {
    OK = 'FIFO_OK';
    WARNING = 'FIFO_WARNING';
    FAILED = 'FIFO_ROTO';
    NODATA = 'SIN_DATOS';
};

entity Z_FIFO_COMPLIANCE : managed {
    key FIFOUUID                : UUID;

        // =====================================================
        // Organización
        // =====================================================
        Plant                   : String(4); // WERKS
        PlantName               : String(100);
        StorageLocation         : String(4); // LGORT
        StorageLocationName     : String(100);

        // =====================================================
        // Material
        // =====================================================
        Material                : String(40); // MATNR
        MaterialDescription     : String(255);
        MaterialType            : String(4); // MTART
        BaseUnit                : String(3); // MEINS
        ProductHierarchy        : String(18);

        // =====================================================
        // Batch
        // =====================================================
        Batch                   : String(10); // CHARG
        ManufacturingDate       : Date; // HSDAT
        ShelfLifeExpirationDate : Date; // VFDAT
        BatchStatus             : String(20);

        // =====================================================
        // Documento Logístico
        // =====================================================
        OutboundDelivery        : String(10); // LIKP-VBELN
        OutboundDeliveryItem    : String(6); // LIPS-POSNR
        TransportationDocument  : String(20);
        GoodsIssueDate          : Date;
        DeliveryDate            : Date;

        // =====================================================
        // Cantidades
        // =====================================================
        StockQuantity           : Decimal(15, 3);
        DispatchQuantity        : Decimal(15, 3);
        FIFOQuantity            : Decimal(15, 3);
        NonFIFOQuantity         : Decimal(15, 3);
        QuantityUnit            : String(3); // ISO UOM

        // =====================================================
        // Valorización
        // =====================================================
        StockValue              : Decimal(15, 2);
        DispatchValue           : Decimal(15, 2);
        CurrencyCode            : Currency;

        // =====================================================
        // Resultado FIFO
        // =====================================================

        TheoreticalDispatchQty  : Decimal(15, 3);
        FIFOCompliancePercent   : Decimal(5, 2);
        FIFODeviationQuantity   : Decimal(15, 3);
        FIFODeviationPercent    : Decimal(5, 2);
        FIFOComplianceStatus    : FIFOComplianceStatusType;
        FIFOCriticality         : Integer;

        // =====================================================
        // Trazabilidad
        // =====================================================
        SourceSystem            : String(20);
        ProcessingDate          : Timestamp;
        ProcessingUser          : String(100);
        CalculationRunID        : String(36);
        Comments                : String(500);

}
