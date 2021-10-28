pragma solidity 0.5.3;

contract HelloWorld {
    string public text; // Variavel global
    uint public number;
    address public userAddress;
    bool public answer;
    mapping (address=>bool) public hasInterected;
    mapping (address=>uint) public hasCountInterected;
    mapping (address=>uint) public balances;

    // memory - o valor só vai estar disponivel enquanto essa função for executada
    // public - disponivel para qualquer usuario
    function setText(string memory myText) public {
        text = myText;
        setInterected();
        setCountInterected();
    }

    // ether - medida
    // msg.value - sempre vem em wei
    // solidity - so lida com numeros inteiros
    function setNumber(uint myNumber) public payable {
        // Condicao que bloqueia a execução da msg
        require(msg.value >= 1 ether, "Insufficient ETH sent.");

        balances[msg.sender] += msg.value;
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

    // transferencia de um endereço pra outro
    function sendETH(address payable targetAddress) public payable {
        targetAddress.transfer(msg.value);
    }

    // Padrao de retirada
    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds.");

        // problema da reentrancia - que remove o problema de o usuario entrar varias vezes na função sem ela ter terminado
        // zeramos o saldo antes da transferencia para evitar que o usuario entre com um contrato em vez de entrar com a conta dele 
        // ai ele conseguiria entrar nessa função repetidas vezes antes do saldo dele ser zerado, assim sacando todo o dinheiro do contrato
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        msg.sender.transfer(amount);
        
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