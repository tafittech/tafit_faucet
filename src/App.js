import { useEffect, useState } from 'react';
import './App.css';
import Web3 from 'web3';


function App() {
  const [web3Api, setWebApi] = useState({
    provider: null,
    web3: null
  })

  const [account, setAccount] = useState(null)

  useEffect(() =>{
    const loadProvider = async () => {
      let provider = null;

      if (window.ethereum) {
        provider = window.ethereum;

        try {
          await provider.enable();
        } catch {
          console.error("User denied account access")
        }
      }
      else if (window.web3) {
        provider = window.web3;
      }
      else if (!process.env.production) {
        provider = new Web3.providers.HttpProvider("http://localhost:7545")
      }
      setWebApi({
        web3: new Web3(provider),
        provider
      })
    }

    loadProvider()
  }, [])

  useEffect (() =>{
    const getAccount = async () => {
      const accounts = await web3Api.web3.ethereum.getAccounts()
      setAccount(accounts[0])
    }
  
    web3Api.web3 && getAccounts()
  }, [web3Api.web3])

  return (
    <>
    <div className="tafit-lottery-wapper">
      <div className="Tafit Lottery">
        <span>
          <strong>Account:</strong>
        </span>
        <h1>
          {account ? account : "not connected"}
        </h1>
        <div className="balance-view is-size-2">
        Congratulation<strong> YOU WON</strong> !!!
        </div>
        <b>Pay to Play:</b><strong> 0.001</strong> ETH
        <div>    
      <button className="btn mr-2">Pay Here</button>
      </div>
     </div>
    </div>
    </>
  );
}

export default App;
