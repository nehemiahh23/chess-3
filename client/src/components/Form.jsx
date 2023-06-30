import React, { useState } from 'react'

function Form() {

    const [formData, setFormData] = useState("")

    function submitHandler(e) {
        // e.preventDefault()
        fetch('http://127.0.0.1:5555/data', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accepts': 'application/json'
            },
            body: JSON.stringify({"text": formData})
        })
        .then(r => r.json())
        .then(data => console.log(data))
        setFormData("")
    }

    function changeHandler(e) {
        setFormData(e.target.value)
    }

  return (
    <>
        <form onSubmit={submitHandler}>
            <input onChange={changeHandler} value={formData}></input>
            <input type='submit'></input>
        </form>
        <br></br>
    </>
  )
}

export default Form