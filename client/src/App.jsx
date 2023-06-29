import './App.css'

function App() {

  fetch('http://127.0.0.1:5555/data')
  .then(r => r.json())
  .then(data => console.log(data))

  return (
    <>
      lorem ipsum
    </>
  )
}

export default App