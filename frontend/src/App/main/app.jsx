import React from 'react'
import * as R from 'ramda'
import { get } from './../../setup/request'
import { getExactData } from './app.helper'

// import { get } from 'superagent'
class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      patientList: [], //
      patientCase: [], //
      prescriptionList: [], //
      empleyeeList: [], //
      hospitalizationList: [], //
      calcOnCallDoctorPayment: '', //
      longestHospitalization: [], //
      roomPatientCount: [], //
      worstIllness: [], //
      clerkAddmiter: [], //
      dhwlPrescription: [], //
      illnessNeedsLabs: [], // 
      labsCauseHospitalization: [], //
      patointHistoryByAge: [], //
      releaseList: [], //
      doctorRelations: [], //
      pharmacyIncome: ''

    }
  }
  render() {
    const setData = (type, args={}) => {
      // console.log("args ", args)
      get(type, {params: args})
        .then(value => {
          console.log("value ", (value.data))
          this.setState({ [type]: getExactData(value.data, type) })
        })
        .catch(console.log)
    }

    const renderTableBody = (inputTable = []) => {
      let rows = [];
      inputTable.forEach(function(row) {
        rows.push(
          <tr key={btoa('row'+rows.length)}>
            {R.toPairs(row).map((col, index) =>
              <td key={index} style={{border: '1px solid grey', borderCollapse: 'collapse', padding: '5px'}}>{col[1]}</td>
            )}
          </tr>
        )
      }.bind(this));
      return (<tbody>{rows}</tbody>);
    }

    const renderTableHeaders = (row = []) => {
      
      let headers = [];
      for (let i = 0; i < R.keys(row).length; i++) {
        let col = R.keys(row)[i];
        headers.push(<th key={col} style={{backgroundColor: '#177CB8', color: 'white', border: '1px solid grey', borderCollapse: 'collapse', padding: '5px'}}>{col}</th>)
      }
      return (<tr>{headers}</tr>);
    }

    const renderTable = (inputTable) =>  {
      return (
        <table>
          <thead>
            { renderTableHeaders(inputTable[0]) }
          </thead>
          { renderTableBody(inputTable) }
        </table>
      ); 
    }

    const { patientList, prescriptionList, empleyeeList, hospitalizationList, 
      illnessNeedsLabs,calcOnCallDoctorPayment, patointHistoryByAge, 
      labsCauseHospitalization, clerkAddmiter, dhwlPrescription,
      longestHospitalization, roomPatientCount , worstIllness,
      patientCase, releaseList, doctorRelations, pharmacyIncome } = this.state
    return (
      <>
        queries
        <br/>
        <button onClick={() => setData('patientList')}>لیست بیماران </button>
        {patientList.length ? <> {renderTable(patientList)} </>  : ''}
        <hr/>
        <button onClick={() => setData('prescriptionList')}>لیست نسخه ها </button>
        {prescriptionList.length ? renderTable(prescriptionList): ''}
        <hr/>
        <button onClick={() => setData('empleyeeList')}>لیست کارمندان </button>
        {empleyeeList.length ? renderTable(empleyeeList): ''}
        <hr/>

        <br/>
        view
        <br/>
        <button onClick={() => setData('hospitalizationList')}>لیست بستری ها  </button>
        {hospitalizationList.length ? renderTable(hospitalizationList): ''}
        <hr/>
        <button onClick={() => setData('releaseList')}>لیست ترخیص شده ها  </button>
        {releaseList.length ? renderTable(releaseList): ''}
        <hr/>
        
        <br/>
        functions
        <br/>
        <button onClick={() => setData('doctorRelations',{
          doctorId: document.getElementById('doctorID').value
        })}>ارتباطات پزشکان  </button>
        <input id="doctorID"  type="number" placeholder="doctorID" defaultValue="101"/>
        {doctorRelations.length ? renderTable(doctorRelations): ''}
        <hr/>
        <button onClick={() => setData('pharmacyIncome',{
          pharmacyId: document.getElementById('pharmacyId').value
        })}>محاسبه ی درآمد داروخانه  </button>
        <input id="pharmacyId"  type="number" placeholder="pharmacyId" defaultValue="100"/>
        {pharmacyIncome}
        <hr/>


        <br/>
        stored procedures
        <br/>
        <button onClick={() => setData('illnessNeedsLabs')}>لیست بیماری هایی که نیاز به آزمایش دارند   </button>
        {illnessNeedsLabs.length ? renderTable(illnessNeedsLabs): ''}
        <hr/>
        <button onClick={() => 
          setData('calcOnCallDoctorPayment', 
          {doctorId: document.getElementById('doctorId').value,
          initialDate:  document.getElementById('initialDate').value})
          }>حقوق پرداختی به  پزشکان  غیر تمام وقت   </button>
           <input id="doctorId"  type="number" placeholder="doctorId" defaultValue="101"/>
           <input id="initialDate" onChange={e => console.log(e.target.value)}  type="date" placeholder="doctorId" defaultValue="2019-05-05"/>
        {calcOnCallDoctorPayment}
        <hr/>
        <button onClick={() => 
          setData('patointHistoryByAge', 
          {
          initialAge:  document.getElementById('initialAge').value})
          }>تاریخچه ی بیماری براساس سن   </button>
           <input id="initialAge"  type="number" placeholder="age" defaultValue="15"/>
          {patointHistoryByAge.length ? renderTable(patointHistoryByAge): ''}
        <hr/>
        <button onClick={() => setData('labsCauseHospitalization',{
          minimumNumber: document.getElementById('minimumNumber').value
        })}>آزمایش هایی که منجر به بستری شدند </button>
          <input id="minimumNumber"  type="number" placeholder="minimum" defaultValue="0"/>
          {labsCauseHospitalization.length ? renderTable(labsCauseHospitalization): ''}
        <hr/>

        <button onClick={() => setData('clerkAddmiter',{
          basement: document.getElementById('basement').value
        })}>منشی با حقوق کمتر از مقدار خاص که بستری کرده اند </button>
          <input id="basement"  type="number" placeholder="basement" defaultValue="1000"/>
          {clerkAddmiter.length ? renderTable(clerkAddmiter): ''}
        <hr/>

        <button onClick={() => setData('dhwlPrescription',{
          baseNumber: document.getElementById('baseNumber').value
        })}>دکتر هایی  که بدون تجویز نسخه بیشتر از تعداد خاصی بستری کرده اند </button>
          <input id="baseNumber"  type="number" placeholder="baseNumber" defaultValue="0"/>
          {dhwlPrescription.length ? renderTable(dhwlPrescription): ''}
        <hr/>

        <button onClick={() => setData('longestHospitalization')}>طولانی ترین زمان های بستری </button>
          {longestHospitalization.length ? renderTable(longestHospitalization): ''}
        <hr/>


        <button onClick={() => setData('roomPatientCount',{
          countStartTime: document.getElementById('countStartTime').value
        })}>تعداد بیمارانی که در هر اتاق بستری شده اند </button>
          <input id="countStartTime"  type="date" placeholder="countStartTime" defaultValue="2018-05-05"/>
          {roomPatientCount.length ? renderTable(roomPatientCount): ''}
        <hr/>

        <button onClick={() => setData('worstIllness',{
          illnessStartTime: document.getElementById('illnessStartTime').value
        })}>شایع ترین بیماری </button>
          <input id="illnessStartTime"  type="date" placeholder="illnessStartTime" defaultValue="2018-05-05"/>
          {worstIllness.length ? renderTable(worstIllness): ''}
        <hr/>

        <button onClick={() => setData('patientCase',{
          nationalId: document.getElementById('nationalId').value
        })}>پرونده های یک بیمار خاص </button>
          <input id="nationalId"  type="number" placeholder="nationalId" defaultValue="1272718743"/>
          {patientCase.length ? renderTable(patientCase): ''}
        <hr/>


        


        

        
        

      </>
    )
  }
}

export default App
