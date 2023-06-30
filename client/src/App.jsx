import './App.css'
import Text from './components/Text'
import Form from './components/Form'
import { useState, useEffect } from 'react'

function App() {

  const [arr, setArr] = useState([])

  useEffect(() => {
    fetch('http://127.0.0.1:5555/data')
    .then(r => r.json())
    .then(data => setArr(data))
  }, [])
  
  const mappedData = arr.map(d => <Text key={d.id} data={d}/>)

  return (
    <>
      <Form />
      <br></br>
      { mappedData }
    </>
  )
}

export default App