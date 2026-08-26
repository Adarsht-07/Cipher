import './App.css'
import { BrowserRouter, Routes, Route } from "react-router-dom"
import Home from "./Pages/Home.tsx"
import ColumnDesign from './Pages/ColumnDesign.tsx'
function App() {
  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route path='/' element={<Home/>}/>
          <Route path='/column' element={<ColumnDesign/>}/>
        </Routes>
      </BrowserRouter>
    </>
  )
}

export default App
