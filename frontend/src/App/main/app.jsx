import React from 'react'
import * as R from 'ramda'
import { get } from './../../setup/request'
import { getExactData } from './app.helper'

// import { get } from 'superagent'
class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      patientList: [],
      patientCase: {},
      prescriptionList: [],
      empleyeeList: [],
      hospitalizationList: [],
      calcOnCallDoctorPayment: '',
      longestHospitalization: [],
      roomPatientCount: [],
      lastMonthWidespeardIllness: {},
      admitterClerk: [],
      dhwlPrescription: [],
      illnessNeedsLabs: [],
      labsCauseHospitalization: [],
      findDoctorRelation: [],

    }
  }
  render() {
    const setData = (type, ...args) => {
      console.log("args ", args)
      get(type)
        .then(value => {
          console.log("value ", value.data)
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

    const { patientList, prescriptionList, empleyeeList, hospitalizationList, illnessNeedsLabs, 
      calcOnCallDoctorPayment } = this.state
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
        <button onClick={() => setData('hospitalizationList')}>لیست بستری ها  </button>
        {hospitalizationList.length ? renderTable(hospitalizationList): ''}
        
        <hr/>
        store procedures
        <br/>
        <button onClick={() => setData('illnessNeedsLabs')}>لیست بیماری هایی که نیاز به آزمایش دارند   </button>
        {/* {document.getElementById('doctorId') ? document.getElementById('doctorId').value : 'empty'} */}
        {illnessNeedsLabs.length ? renderTable(illnessNeedsLabs): ''}
        {/* {console.log("illnessNeedsLabs ", illnessNeedsLabs)} */}
        <hr/>
        <button onClick={() => setData('calcOnCallDoctorPayment')}>حقوق پرداختی به  پزشکان  غیر تمام وقت   </button>
           <input id="doctorId"  type="text" placeholder="doctorId" defaultValue="101"/>
           <input id="initialDate"  type="date" placeholder="doctorId" defaultValue="2019-05-05"/>
        {calcOnCallDoctorPayment}
        


      </>
    )
  }
}

export default App
