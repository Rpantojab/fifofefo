// import cds from '@sap/cds';

// const STATUS = {
//     OK: 'FIFO_OK',
//     WARNING: 'FIFO_WARNING',
//     FAILED: 'FIFO_ROTO',
//     NODATA: 'SIN_DATOS'
// };

// function calculateFIFORow(data) {
//     const fifoQty = Number(data.FIFOQuantity || 0);
//     const nonFifoQty = Number(data.NonFIFOQuantity || 0);
//     const theoreticalQty = fifoQty + nonFifoQty;

//     data.TheoreticalDispatchQty = Number(theoreticalQty.toFixed(3));

//     if (theoreticalQty <= 0) {
//         data.FIFOCompliancePercent = 0;
//         data.FIFODeviationQuantity = 0;
//         data.FIFODeviationPercent = 0;
//         data.FIFOComplianceStatus = STATUS.NODATA;
//         data.FIFOCriticality = 0;
//         return;
//     }

//     const compliance = (fifoQty / theoreticalQty) * 100;
//     data.FIFOCompliancePercent = Number(compliance.toFixed(2));
//     data.FIFODeviationQuantity = Number(nonFifoQty.toFixed(3));
//     data.FIFODeviationPercent = Number(((nonFifoQty / theoreticalQty) * 100).toFixed(2));

//     if (compliance >= 95) {
//         data.FIFOComplianceStatus = STATUS.OK;
//         data.FIFOCriticality = 3;
//     } else if (compliance >= 80) {
//         data.FIFOComplianceStatus = STATUS.WARNING;
//         data.FIFOCriticality = 2;
//     } else {
//         data.FIFOComplianceStatus = STATUS.FAILED;
//         data.FIFOCriticality = 1;
//     }
// }

// // REEMPLAZO DE module.exports POR LA EXPORTACIÓN MODERNA
// export default cds.service.impl(async function () {
    
//     this.before(['CREATE', 'UPDATE'], 'FIFOComplianceIntegration', (req) => {
//         if (!req.data) return;

//         if (Array.isArray(req.data)) {
//             const len = req.data.length;
//             for (let i = 0; i < len; i++) {
//                 calculateFIFORow(req.data[i]);
//             }
//         } else {
//             calculateFIFORow(req.data);
//         }
//     });

//     this.on('CalculateFIFO', async (req) => {
//         return "Procesamiento masivo ejecutado con éxito";
//     });

//     this.on('RecalculateDelivery', async (req) => {
//         const { OutboundDelivery } = req.data;
//         return `Entrega ${OutboundDelivery} recalculada con éxito.`;
//     });
// });

// console.log('Calculando FIFO...');
// console.log(req.data);

