import React from 'react'
import { get } from './../../setup/request'

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      patientList: [],
      patientCase: {},
      prescriptionList: [],
      onCallPayment: '',
      longestHospitalization: [],
      roomPatientCount: [],
      lastMonthWidespeardIllness: {},
      admitterClerk: [],
      dhwlPrescription: [],
      illnessNeedslabs: [],
      labsCauseHospitalization: [],
      findDoctorRelation: []
    }
  }
  render() {
    const setData = type => {
      get('patientList')
        .then(value => {
          console.log('value ', value)
          this.setState({ [type]: value })
        })
        .catch(console.log)
    }
    const { patientList } = this.state
    return (
      <>
        <button onClick={() => setData('patientList')}>لیست بیماران </button>
        {patientList.map(patient => console.log('patient ', patient))}
      </>
    )
  }
}

export default App
