import * as R from 'ramda'
export const getExactData  = (data, type ) => {
    if (type === 'illnessNeedsLabs') {
        return data[0]
    }
    if (type ===  'calcOnCallDoctorPayment') {  
        return R.values(data[0][0])[0]
        
    }
    else return data
}