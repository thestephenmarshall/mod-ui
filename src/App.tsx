import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <dl>
        <dt><blockquote>"Big things have small beginnings"</blockquote></dt>
        <dd>- T.E. Lawrence</dd>
      </dl>
    </>
  )
}

export default App
