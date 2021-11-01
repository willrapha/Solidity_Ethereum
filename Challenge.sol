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

contract Challenge is Ownable {
    using SafeMath for uint;

    // Se voce nao declarar o acesso dela é considerado public
    uint price = 25 finney;
    event NewPrice(uint newProce); 
    
    function whatAbout(uint myNumber) public payable returns(string memory) {
       
       require(myNumber <= 10, "Number out of range.");
       require(msg.value == price, "Wrong msg.value"); // 0,025 ETH

       doublePrice();

       if(myNumber > 5) {
           return "É maior que cinco!";
       }

       return "É menor ou igual a cinco!";

    }

    function doublePrice() private {   
        price = price.mul(2);
        emit NewPrice(price);
    }

    function withdraw(uint myAmount) onlyOwner public {
        // address(this).balance é todo o dinheiro que tem no contrato, propriedade nativa
        // dessa forma ele ja faz todos os calculos de subtração
        require(address(this).balance >= myAmount, "Insufficent funds");

        owner.transfer(myAmount);
    }

    function getValueContract() onlyOwner public returns(uint) {
        return address(this).balance;
    }
}