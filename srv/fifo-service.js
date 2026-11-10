import cds from '@sap/cds'

export default cds.service.impl(async function () {
    const { FIFOComplianceMaintenance } = this.entities

    // Interceptamos eventos del Preview (incluyendo PATCH para Drafts)
    this.before(['CREATE', 'UPDATE', 'PATCH'], FIFOComplianceMaintenance, async (req) => {
        const data = req.data

        // 1. Buscar el estado actual del borrador (Draft) en las tablas temporales usando la clave de tu entidad: FIFOUUID
        let draftRecord = {}
        if (data.FIFOUUID) {
            try {
                draftRecord = await cds.tx(req).run(
                    SELECT.one.from(FIFOComplianceMaintenance.drafts).where({ FIFOUUID: data.FIFOUUID })
                ) || {}
            } catch (e) {
                draftRecord = {}
            }
        }

        // 2. Fusionar datos: prioriza lo recién escrito (data), si no, usa el borrador (draftRecord)
        const dispatch = parseFloat(
            data.DispatchQuantity !== undefined && data.DispatchQuantity !== null 
                ? data.DispatchQuantity 
                : (draftRecord.DispatchQuantity || 0)
        )
        
        const fifoQty = parseFloat(
            data.FIFOQuantity !== undefined && data.FIFOQuantity !== null 
                ? data.FIFOQuantity 
                : (draftRecord.FIFOQuantity || 0)
        )

        // 3. LÓGICA DE CÁLCULO DE CANTIDADES
        const nonFifoQty = Math.max(0, dispatch - fifoQty)
        data.NonFIFOQuantity = nonFifoQty
        data.FIFODeviationQuantity = nonFifoQty

        // 4. LÓGICA DE CÁLCULO DE PORCENTAJES
        let compliancePercent = 0.00
        let deviationPercent = 0.00

        if (dispatch > 0) {
            compliancePercent = (fifoQty / dispatch) * 100
            deviationPercent = (nonFifoQty / dispatch) * 100
        }

        data.FIFOCompliancePercent = Math.round(compliancePercent * 100) / 100
        data.FIFODeviationPercent = Math.round(deviationPercent * 100) / 100

        // 5. MAPEO DE ESTADOS ENUMERADOS Y CRITICIDAD DE COLORES (SAP Fiori)
        if (dispatch === 0) {
            // Sin despacho no hay datos suficientes
            data.FIFOComplianceStatus = 'SIN_DATOS' // NODATA
            data.FIFOCriticality = 0               // Gris
        } else if (data.FIFOCompliancePercent === 100) {
            // Cumplimiento perfecto
            data.FIFOComplianceStatus = 'FIFO_OK'   // OK
            data.FIFOCriticality = 3               // Verde
        } else if (data.FIFOCompliancePercent >= 80) {
            // Cumplimiento parcial aceptable (puedes ajustar este umbral)
            data.FIFOComplianceStatus = 'FIFO_WARNING' // WARNING
            data.FIFOCriticality = 2                  // Amarillo
        } else {
            // Cumplimiento bajo o roto
            data.FIFOComplianceStatus = 'FIFO_ROTO'  // FAILED
            data.FIFOCriticality = 1                 // Rojo
        }

        // 6. TRAZABILIDAD Y AUDITORÍA
        // Usamos el campo ProcessingDate como tu tipo 'Timestamp' exige
        data.ProcessingDate = new Date().toISOString()
        data.ProcessingUser = req.user.id || 'TEST_USER'
    })

    // ==========================================
    // ACCIONES ANALÍTICAS
    // ==========================================
    this.on('CalculateFIFO', async (req) => {
        return "Cálculo FIFO ejecutado con éxito mediante ESM"
    })

    this.on('RecalculateDelivery', async (req) => {
        const { OutboundDelivery } = req.data
        return `Entrega ${OutboundDelivery} recalculada mediante ESM`
    })
})
