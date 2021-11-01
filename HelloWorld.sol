pragma solidity 0.5.3;

library SafeMath {
    // pure - funcoes pure sao gratis, pois nao consultam e nem alteram nada da blockchain
    function sum(uint a, uint b) internal pure returns (uint) {
        uint c =  a + b;
        require(c >= a, "Sum Overflow!");
        
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a, "Sub Underflow!");
        uint c = a - b;
        
        return c;
    }

    function mul(uint a, uint b) internal pure returns (uint) {
        if(a == 0) {
            return 0;
        }
        
        uint c = a * b;
        require(c / a == b, "Mul Overflow!");
        
        return c;
    }
    
    // Divisao nao causa overflow
    function div(uint a, uint b) internal pure returns (uint) {
        uint c = a / b;
        
        return c;
    }
}

contract Ownable {
    // Sempre quando precisamos usar o sacar ether usamos o atributo payable
    address payable public owner;
    
    // Eventos
    // Esses eventos podem ser consultados por aplicativos web, maneira tbm de qualquer um registro de tudo que aconteceu
    // É possivel tbm ser utilizado como uma fonte de dados bruto
    event OwnershipTransferred(address newOwner);

    // chamado uma vez na vida do contrato
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _; // Executa o resto da função esse modifier é chamado 
    }

    function transferOwnership(address payable newOwner) onlyOwner public {
        owner = newOwner;

        emit OwnershipTransferred(owner);
    }
    
}

contract HelloWorld is Ownable {
    using SafeMath for uint;
    
    string public text; // Variavel global
    uint public number;
    address payable public userAddress;
    bool public answer;
    mapping (address=>bool) public hasInterected;
    mapping (address=>uint) public hasCountInterected;
    mapping (address=>uint) public balances;

    // memory - o valor só vai estar disponivel enquanto essa função for executada
    // public - disponivel para qualquer usuario
    function setText(string memory myText) onlyOwner public {
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

        balances[msg.sender] = balances[msg.sender].sum(msg.value);
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
        hasCountInterected[msg.sender] = hasCountInterected[msg.sender].sum(1);
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
    
    // view - funcoes view fazem apenas consultas na blockchain
    function sumStored(uint num1) public view returns (uint) {
        return num1.sum(number);
    }

}