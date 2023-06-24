import { useEffect, useState } from 'react';
import './App.css';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import { loadContract } from './utils/load-contract';


function App() {
  const [web3Api, setWebApi] = useState({
    provider: null,
    web3: null,
    contract: null
  })

  const [account, setAccount] = useState(null)

  useEffect(() =>{
    const loadProvider = async () => {
      const provider = await detectEthereumProvider()
      const contract = await loadContract("tafitLottery")

      
      if (provider){ 
        setWebApi({
        web3: new Web3(provider),
        provider,
        contract
        })
      } else {
        console.error("PLease, install Metamask")
      }
    }

    loadProvider()
  }, [])

  useEffect (() =>{
    const getAccount = async () => {
      const accounts = await web3Api.web3.eth.getAccounts()
      setAccount(accounts[0])
    }
  
    web3Api.web3 && getAccount()
  }, [web3Api.web3])

  return (
    <>
    <div className="tafit-lottery-wrapper">
      <div className="Tafit Lottery">
        <div className=" is-flex is-align-items-center">
          <span>
          <strong className=" mr-2">Account:</strong>
          </span>
        <h1>
          {account ? <div>{account}</div> : 
          <button className="button is-info"
            onClick={() =>
              web3Api.provider.request({method:"eth_requestAccounts"}
              )}
          >
            Connect Wallet
          </button>
          }
        </h1>

        </div>
        <div className="balance-view is-size-2">
        Congratulation<strong> YOU WON</strong> !!!
        </div>
        <b>Pay to Play:</b><strong> 0.001</strong> ETH
        <div>    
      <button className="button is-primary  is-active">Pay Here</button>
      </div>
     </div>
    </div>
    </>
  );
}

export default App;
