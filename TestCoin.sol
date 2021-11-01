pragma solidity 0.5.3;

library SafeMath {
    // pure - funcoes pure sao gratis, pois nao consultam e nem alteram nada da blockchain
    function add(uint a, uint b) internal pure returns (uint) {
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
    // Sempre quando precisamos usar ou sacar ether usamos o atributo payable
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

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    // uint remaining quantidade de tokens que pode ser movimentado por determinado usuario
    function allowance(address tokenOwner, address spender) public view returns (uint remaining); // Consulta pra saber se determinado usuario tem permissão para movimentar moedas em nome de outro usuario
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success); // Permite que outros usuarios transfiram moedas no seu nome
    function transferFrom(address from, address to, uint tokens) public returns (bool success); // Como o procurador movimenta as moedas

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BasicToken is Ownable, ERC20 {
    using SafeMath for unit;

    uint internal _totalSupply;
    mapping(address => uint) internal _balances;
    mapping(address => mapping(address => uint)) internal _allowed;

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return _balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(_balances[msg.sender] >= tokens);
        require(to != address(0));

        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        _allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return _allowed[tokenOwner][spender];
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(_allowed[from][msg.sender] >= tokens);
        require(_balances[from] >= tokens);
        require(to != address(0));

        _balances[from] = _balances[from].sub(tokens);
        _balances[to] = _balances[to].add(tokens);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);

        emit Transfer(from, to, tokens);

        return true;
    }
}

contract MintableToken is BasicToken {
    // indexed - podemos usar em tudo que vamos utilizar para ser filtrado
    event Mint(address indexed to, uint tokens);

    // mint - mintar token - é aumentar quanto o usuario tem daquele token e aumentar o total supply
    function mint(address to, uint tokens) onlyOwner public {
        _balances[to] = _balances[to].add(tokens);
        _totalSupply = _totalSupply.add(tokens);

        emit Mint(to, tokens);
    }
}

contract TestCoin is MintableToken {
    string public constant name = "Test Coin";
    string public constant sumbol = "TST";
    uint8 public constant decimals = 18;
}