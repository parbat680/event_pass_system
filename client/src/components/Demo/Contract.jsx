import { useRef, useEffect } from "react";

function Contract({ value: event }) {
  const spanEle = useRef(null);

  useEffect(() => {
    spanEle.current.classList.add("flash");
    const flash = setTimeout(() => {
      spanEle.current.classList.remove("flash");
    }, 300);
    return () => {
      clearTimeout(flash);
    };
  }, [event.totalTickets]);

  return (
    <code>
      {`Event Details\n\n`}

      <span className="secondary-color" ref={spanEle}>
        {/* <strong>{event}</strong> */}
      </span>

      {`
Event Name : ${event["0"] ?? ""}\n
Event Url : ${event["1"] ?? ""}\n
Event Status : ${event["isOpen"] ?? ""}\n
Available tickets : ${
        parseInt(event["totalTickets"]) - parseInt(event["sales"]) ?? ""
      }\n
      `}
    </code>
  );
}

export default Contract;
