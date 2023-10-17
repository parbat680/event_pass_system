import { useState, useEffect } from "react";
import useEth from "../../contexts/EthContext/useEth";

function ContractBtns({ setValue }) {
  const {
    state: { contract, accounts },
  } = useEth();
  const [inputValue, setInputValue] = useState("");

  const handleInputChange = (e) => {
    if (/^\d+$|^$/.test(e.target.value)) {
      setInputValue(e.target.value);
    }
  };

  const read = async () => {
    const value = await contract.methods
      .readEvent()
      .call({ from: accounts[0] });
    console.log(value);
    setValue(value);
  };

  useEffect(() => {
    read();
  }, []);

  const write = async (e) => {
    if (e.target.tagName === "INPUT") {
      return;
    }
    if (inputValue === "") {
      alert("Please enter a number of tickets.");
      return;
    }
    const newValue = parseInt(inputValue);
    console.log(
      await contract.methods.buyTickets(newValue).send({
        from: accounts[0],
        gasLimit: 500000,
        value: 1000000 * newValue,
      })
    );
  };

  return (
    <div className="btns">
      <button onClick={read}>Event Details</button>

      <div onClick={write} className="input-btn">
        Buy(
        <input
          type="text"
          placeholder="uint"
          value={inputValue}
          onChange={handleInputChange}
        />
        )
      </div>
    </div>
  );
}

export default ContractBtns;
