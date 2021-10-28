pragma solidity 0.5.2;

contract HelloWorld {
    string public text; // Variavel global
    uint public number;
    address public userAddress;
    bool public answer;
    mapping (address=>bool) public hasInterected;
    mapping (address=>uint) public hasCountInterected;

    // memory - o valor só vai estar disponivel enquanto essa função for executada
    // public - disponivel para qualquer usuario
    function setText(string memory myText) public {
        text = myText;
        setInterected();
        setCountInterected();
    }

    function setNumber(uint myNumber) public {
        number = myNumber;
        setInterected();
        setCountInterected();
    }

    function setUserAddress() public {
        // msg.sender - endereço do usuario
        userAddress = msg.sender;
        setInterected();
        setCountInterected();
    }

    function setAnswer(bool trueOrFalse) public {
        answer = trueOrFalse;
        setInterected();
        setCountInterected(); 
    }

    function setInterected() private {
        hasInterected[msg.sender] = true;
    }

    function setCountInterected() private {
        hasCountInterected[msg.sender] += 1;
    }

    // pure - funcoes pure sao gratis, pois nao consultam e nem alteram nada da blockchain
    function sum(uint num1, uint num2) public pure returns (uint) {
        return num1 + num2;
    }

    function sub(uint num1, uint num2) public pure returns (uint) {
        return num1 - num2;
    }

    function mult(uint num1, uint num2) public pure returns (uint) {
        return num1 * num2;
    }

    function div(uint num1, uint num2) public pure returns (uint) {
        return num1 / num2;
    }

    // ** - potencia
    function pow(uint num1, uint num2) public pure returns (uint) {
        return num1 ** num2;
    }

    // view - funcoes view fazem apenas consultas na blockchain
    function sumStored(uint num1) public view returns (uint) {
        return num1 + number;
    }

}