import * as R from 'ramda'
export const getExactData  = (data, type ) => {
    if (type === 'illnessNeedsLabs' || type === 'patointHistoryByAge'
    || type === 'labsCauseHospitalization'
    || type === 'clerkAddmiter' 
    || type === 'dhwlPrescription' 
    || type === 'longestHospitalization' 
    || type === 'roomPatientCount' 
    || type === 'worstIllness' 
    || type === 'patientCase' 
    || type === 'doctorRelations' 
    
    ) {
        return data[0]
    }
    if (type ===  'calcOnCallDoctorPayment' || type === 'pharmacyIncome') {  
        return R.values(data[0][0])[0]
        
    }
    
    else return data
}