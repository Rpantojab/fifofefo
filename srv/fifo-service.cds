// using { com.agrosuper as db } from '../db/schema';
// service FIFOFEFOService {

//     @odata.draft.enabled
//     entity FIFOCompliance
//         as projection on db.Z_FIFO_COMPLIANCE;

//     action CalculateFIFO()
//         returns String;

//     action RecalculateDelivery(
//         OutboundDelivery : String(10)
//     )
//         returns String;

// }

//FIFOFEFOService.cds
using { com.agrosuper as db } from '../db/schema';

service FIFOFEFOService {

    /**
     * Canal 1: Reporte Operacional (Consumido por Fiori Elements)
     */
    @readonly
    @odata.draft.enabled
    @Capabilities.SearchRestrictions.Searchable : true
    entity FIFOComplianceReport as projection on db.Z_FIFO_COMPLIANCE;

    /**
     * Canal 2: API de Alta Velocidad (Consumido exclusivamente por ABAP)
     * Sin la sobrecarga ni bloqueos del motor de Draft.
     */
    entity FIFOComplianceIntegration as projection on db.Z_FIFO_COMPLIANCE;

        /**
     * Canal 3: Aplicación / API de Mantenimiento y Datos de Prueba
     * CRUD Completo con soporte de Draft para Fiori Elements.
     */
    @odata.draft.enabled
    entity FIFOComplianceMaintenance as projection on db.Z_FIFO_COMPLIANCE;

    // Acciones analíticas pesadas
    action CalculateFIFO() returns String;
    action RecalculateDelivery( OutboundDelivery : String(10) ) returns String;
}
