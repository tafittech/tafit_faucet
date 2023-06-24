import { useEffect } from 'react';
import './App.css';


function App() {

  useEffect(() =>{
    const loadProvider = async () => {
    // Metamask have access to windows.ethereum & to window.web3
    // metamask injects a global API into website
    // this API allows websites to request users, account,
    //read data to Blockchain, send messages and Transactions

    console.log(window.web3)
    console.log(window.ethereum)
    }

    loadProvider()
  }, [])

  return (
    <>
    <div className="tafit-lottery-wapper">
      <div className="Tafit Lottery">
        <div className="balance-view is-size-2">
        Congratulation<strong> YOU WON</strong> !!!
        </div>
        <b>Pay to Play:</b><strong> 0.001</strong> ETH
        <div>
          <button className="btn mr-2"
          onClick={async () => {
            const accounts = await window.ethereum.request({method:"eth_requestAccounts"})
            console.log(accounts)
          }}>Check Funds</button>
      <button className="btn mr-2">Pay Here</button>
      </div>
     </div>
    </div>
    </>
  );
}

export default App;
